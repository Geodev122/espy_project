import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:espy_app/theme/espy_theme.dart';

enum UserStatus { pending, active, verified, suspended }

class EspyStatusBadge extends StatelessWidget {
  final UserStatus status;
  final bool hasProfile;
  final bool isActive;
  final bool isApproved;

  const EspyStatusBadge({
    super.key,
    required this.status,
  }) : hasProfile = true, isActive = true, isApproved = true; // For named constructors

  const EspyStatusBadge.fromFlags({
    super.key,
    required this.hasProfile,
    required this.isActive,
    required this.isApproved,
  }) : status = UserStatus.pending; // Logic handled in build

  @override
  Widget build(BuildContext context) {
    UserStatus currentStatus = status;

    if (status == UserStatus.pending) { // If using fromFlags
      if (!isActive) {
        currentStatus = UserStatus.suspended;
      } else if (isApproved) {
        currentStatus = UserStatus.verified;
      } else if (hasProfile) {
        currentStatus = UserStatus.active;
      } else {
        currentStatus = UserStatus.pending;
      }
    }

    final Color color = _getColor(currentStatus);
    final String label = currentStatus.name.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 8,
          fontWeight: FontWeight.w900,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Color _getColor(UserStatus s) {
    switch (s) {
      case UserStatus.pending: return EspyTheme.gold;
      case UserStatus.active: return EspyTheme.electricBlue;
      case UserStatus.verified: return EspyTheme.success;
      case UserStatus.suspended: return EspyTheme.error;
    }
  }
}
