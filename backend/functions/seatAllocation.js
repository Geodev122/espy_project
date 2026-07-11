/**
 * Seat Allocation Utilities for Firebase Functions
 * Handles automatic seat assignment with priority: Center > Right > Left
 */

const admin = require('firebase-admin');
const rtdb = admin.database();

// Direction constants
const DIRECTIONS = {
  CENTER: 'C',
  RIGHT: 'R',
  LEFT: 'L',
};

// Direction priority (lower number = higher priority)
const DIRECTION_PRIORITY = {
  [DIRECTIONS.CENTER]: 1,
  [DIRECTIONS.RIGHT]: 2,
  [DIRECTIONS.LEFT]: 3,
};

/**
 * Get human-readable direction label
 */
function getDirectionLabel(direction) {
  const labels = {
    [DIRECTIONS.CENTER]: 'Center',
    [DIRECTIONS.RIGHT]: 'Right',
    [DIRECTIONS.LEFT]: 'Left',
  };
  return labels[direction] || direction;
}

/**
 * Get all allocated seats for a seating level
 */
async function getAllocatedSeats(seatingLevelId) {
  const snapshot = await rtdb.ref('seatBookings').orderByChild('seatingLevelId').equalTo(seatingLevelId).once('value');
  const val = snapshot.val() || {};
  const bookings = { docs: Object.entries(val).map(([id, data]) => ({ id, data: () => data })) };
  
  // Apply the second filter in memory for RTDB
  const statuses = ['confirmed', 'pending_payment', 'payment_uploaded'];
  const filteredDocs = bookings.docs.filter(doc => statuses.includes(doc.data().status));
  
  const allocatedSeats = new Set();
  filteredDocs.forEach(doc => {

  const allocatedSeats = new Set();
  filteredDocs.forEach(doc => {
    const data = doc.data();
    if (data.seatNumbers && Array.isArray(data.seatNumbers)) {
      data.seatNumbers.forEach(seat => {
        if (seat && seat.trim()) {
          allocatedSeats.add(seat.toUpperCase());
        }
      });
    }
  });

  return allocatedSeats;
}

/**
 * Parse seat number to extract direction and number
 * Format: LevelName-Direction-Number (e.g., "VIP-C-1", "Gold-R-15")
 */
function parseSeatNumber(seatNumber) {
  const match = seatNumber.match(/^(.+)-(C|R|L)-(\d+)$/);
  if (!match) return null;
  
  return {
    levelName: match[1],
    direction: match[2],
    number: parseInt(match[3], 10),
  };
}

/**
 * Get allocation summary for a seating level
 */
async function getSeatAllocationSummary(seatingLevelId, seatingLevelName, levelConfig) {
  const allocatedSeats = await getAllocatedSeats(seatingLevelId);
  
  // Parse allocated seats by direction
  const allocationByDirection = {
    [DIRECTIONS.CENTER]: new Set(),
    [DIRECTIONS.RIGHT]: new Set(),
    [DIRECTIONS.LEFT]: new Set(),
  };

  allocatedSeats.forEach(seat => {
    const parsed = parseSeatNumber(seat);
    if (parsed && allocationByDirection[parsed.direction]) {
      allocationByDirection[parsed.direction].add(parsed.number);
    }
  });

  // Calculate capacities from level config
  const capacities = {
    [DIRECTIONS.CENTER]: levelConfig.centerSeats || Math.floor(levelConfig.totalSeats * 0.4),
    [DIRECTIONS.RIGHT]: levelConfig.rightSeats || Math.floor(levelConfig.totalSeats * 0.3),
    [DIRECTIONS.LEFT]: levelConfig.leftSeats || Math.floor(levelConfig.totalSeats * 0.3),
  };

  // Build summary for each direction
  const directions = Object.keys(DIRECTION_PRIORITY)
    .sort((a, b) => DIRECTION_PRIORITY[a] - DIRECTION_PRIORITY[b])
    .map(direction => {
      const total = capacities[direction];
      const allocated = allocationByDirection[direction].size;
      const available = total - allocated;
      
      // Find next available seat number
      let nextNumber = 1;
      while (allocationByDirection[direction].has(nextNumber) && nextNumber <= total) {
        nextNumber++;
      }

      return {
        direction,
        label: getDirectionLabel(direction),
        priority: DIRECTION_PRIORITY[direction],
        total,
        allocated,
        available,
        nextNumber: nextNumber <= total ? nextNumber : null,
        allocationPercentage: total > 0 ? Math.round((allocated / total) * 100) : 0,
      };
    });

  return {
    seatingLevelId,
    seatingLevelName,
    totalSeats: levelConfig.totalSeats,
    totalAllocated: allocatedSeats.size,
    totalAvailable: levelConfig.totalSeats - allocatedSeats.size,
    directions,
  };
}

/**
 * Allocate seats automatically following priority order
 * Priority: Center (highest) > Right > Left (lowest)
 */
async function allocateSeatsAutomatically(seatingLevelId, seatingLevelName, levelConfig, seatsNeeded) {
  console.log('[ALLOCATION] Starting automatic allocation...');
  console.log('[ALLOCATION] Level:', seatingLevelName);
  console.log('[ALLOCATION] Seats needed:', seatsNeeded);

  const summary = await getSeatAllocationSummary(seatingLevelId, seatingLevelName, levelConfig);
  
  if (summary.totalAvailable < seatsNeeded) {
    throw new Error(`Not enough seats available. Need ${seatsNeeded}, have ${summary.totalAvailable}`);
  }

  const seatNumbers = [];
  let seatsRemaining = seatsNeeded;
  let allocatedDirection = null;

  // Try to allocate all seats from the same direction for group seating
  for (const dir of summary.directions) {
    if (dir.available >= seatsNeeded) {
      // Can fit all seats in this direction
      allocatedDirection = dir.direction;
      
      // Get currently allocated numbers for this direction
      const allocatedInDir = new Set();
      const snapshot = await rtdb.ref('seatBookings').orderByChild('seatingLevelId').equalTo(seatingLevelId).once('value');
      const bookings = { docs: Object.entries(snapshot.val() || {}).map(([id, data]) => ({ id, data: () => data })) };
      
      filteredDocs.forEach(doc => {
        const data = doc.data();
        if (data.seatNumbers) {
          data.seatNumbers.forEach(seat => {
            const parsed = parseSeatNumber(seat);
            if (parsed && parsed.direction === dir.direction) {
              allocatedInDir.add(parsed.number);
            }
          });
        }
      });

      // Find consecutive seats if possible
      let startNumber = 1;
      while (startNumber <= dir.total) {
        let canFitGroup = true;
        for (let i = 0; i < seatsNeeded; i++) {
          if (allocatedInDir.has(startNumber + i) || startNumber + i > dir.total) {
            canFitGroup = false;
            break;
          }
        }
        
        if (canFitGroup) {
          for (let i = 0; i < seatsNeeded; i++) {
            seatNumbers.push(`${seatingLevelName}-${dir.direction}-${startNumber + i}`);
          }
          break;
        }
        startNumber++;
      }

      // If consecutive not found, just find any available
      if (seatNumbers.length === 0) {
        let seatNum = 1;
        while (seatNumbers.length < seatsNeeded && seatNum <= dir.total) {
          if (!allocatedInDir.has(seatNum)) {
            seatNumbers.push(`${seatingLevelName}-${dir.direction}-${seatNum}`);
          }
          seatNum++;
        }
      }

      break;
    }
  }

  // If couldn't fit all in one direction, allocate across directions
  if (seatNumbers.length < seatsNeeded) {
    console.log('[ALLOCATION] Splitting across directions...');
    
    for (const dir of summary.directions) {
      if (seatsRemaining <= 0) break;
      
      const allocatedInDir = new Set();
      const snapshot = await rtdb.ref('seatBookings').orderByChild('seatingLevelId').equalTo(seatingLevelId).once('value');
      const bookings = { docs: Object.entries(snapshot.val() || {}).map(([id, data]) => ({ id, data: () => data })) };
      
      filteredDocs.forEach(doc => {
        const data = doc.data();
        if (data.seatNumbers) {
          data.seatNumbers.forEach(seat => {
            const parsed = parseSeatNumber(seat);
            if (parsed && parsed.direction === dir.direction) {
              allocatedInDir.add(parsed.number);
            }
          });
        }
      });

      let seatNum = 1;
      while (seatsRemaining > 0 && seatNum <= dir.total) {
        if (!allocatedInDir.has(seatNum)) {
          seatNumbers.push(`${seatingLevelName}-${dir.direction}-${seatNum}`);
          seatsRemaining--;
          if (!allocatedDirection) allocatedDirection = dir.direction;
        }
        seatNum++;
      }
    }
  }

  if (seatNumbers.length < seatsNeeded) {
    throw new Error(`Could not allocate all seats. Allocated ${seatNumbers.length}/${seatsNeeded}`);
  }

  console.log('[ALLOCATION] Allocated seats:', seatNumbers);
  console.log('[ALLOCATION] Primary direction:', allocatedDirection);

  return {
    seatNumbers,
    direction: allocatedDirection,
  };
}

/**
 * Validate seat numbers for conflicts
 */
async function validateSeatNumbers(seatingLevelId, seatNumbers) {
  const allocatedSeats = await getAllocatedSeats(seatingLevelId);
  const conflicts = seatNumbers.filter(seat => allocatedSeats.has(seat.toUpperCase()));
  
  return {
    valid: conflicts.length === 0,
    conflicts,
  };
}

/**
 * Allocate seats using row configuration
 * Format: A-1, A-2, B-1, B-2, etc.
 */
async function allocateSeatsWithRows(seatingLevelId, seatingLevelName, rows, seatsNeeded) {
  console.log('[ALLOCATION] Starting row-based allocation...');
  console.log('[ALLOCATION] Level:', seatingLevelName);
  console.log('[ALLOCATION] Seats needed:', seatsNeeded);
  console.log('[ALLOCATION] Rows config:', JSON.stringify(rows));

  // Get already allocated seats
  const allocatedSeats = await getAllocatedSeats(seatingLevelId);
  console.log('[ALLOCATION] Already allocated:', allocatedSeats.size, 'seats');

  const assignedSeats = [];

  // Iterate through rows in order
  for (const row of rows) {
    if (assignedSeats.length >= seatsNeeded) break;

    // Try to assign seats in this row
    for (let seatNum = 1; seatNum <= row.seatsInRow; seatNum++) {
      const seatId = `${row.rowLetter}-${seatNum}`;
      
      // Check if this seat is available
      if (!allocatedSeats.has(seatId) && !allocatedSeats.has(seatId.toUpperCase())) {
        assignedSeats.push(seatId);
        
        if (assignedSeats.length >= seatsNeeded) break;
      }
    }
  }

  if (assignedSeats.length < seatsNeeded) {
    throw new Error(`Could not allocate ${seatsNeeded} seats. Only ${assignedSeats.length} available.`);
  }

  console.log('[ALLOCATION] ✅ Allocated seats:', assignedSeats);
  return assignedSeats;
}

/**
 * Main allocation function that handles both row-based and direction-based allocation
 */
async function allocateSeats(seatingLevelId, seatingLevelName, levelConfig, seatsNeeded) {
  console.log('[ALLOCATION] Starting seat allocation');
  console.log('[ALLOCATION] Level Config:', JSON.stringify({
    name: seatingLevelName,
    totalSeats: levelConfig.totalSeats,
    hasRows: !!levelConfig.rows,
    rowCount: levelConfig.rows?.length || 0
  }));

  // Check if level uses row configuration
  if (levelConfig.rows && levelConfig.rows.length > 0) {
    return await allocateSeatsWithRows(seatingLevelId, seatingLevelName, levelConfig.rows, seatsNeeded);
  } else {
    // Fall back to direction-based allocation
    return await allocateSeatsAutomatically(seatingLevelId, seatingLevelName, levelConfig, seatsNeeded);
  }
}

module.exports = {
  DIRECTIONS,
  DIRECTION_PRIORITY,
  getDirectionLabel,
  getAllocatedSeats,
  parseSeatNumber,
  getSeatAllocationSummary,
  allocateSeatsAutomatically,
  allocateSeatsWithRows,
  allocateSeats,
  validateSeatNumbers,
};
