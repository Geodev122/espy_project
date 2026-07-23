const admin = require('firebase-admin');
const axios = require('axios');
const path = require('path');

// 1. CONFIGURATION
const SERVICE_ACCOUNT_PATH = 'C:\\Users\\Dell\\AppData\\Roaming\\firebase\\geo_elnajjar_gmail.com_application_default_credentials.json';
const PROJECT_ID = 'espy-453d3';
const LOCATION = 'us-east1';
const SERVICE_ID = 'espy-453d3-service';
const CONNECTOR_ID = 'espy';

const GRAPHQL_ENDPOINT = `https://firebasedataconnect.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/services/${SERVICE_ID}/connectors/${CONNECTOR_ID}:impersonateMutation`;

// 2. LOAD CREDENTIALS
const credentials = require(SERVICE_ACCOUNT_PATH);

// 3. DATASET - LEBANON GEOGRAPHY
const LEBANON_DATA = {
  country: {
    id: 'LB',
    nameEn: 'Lebanon',
    nameAr: 'لبنان',
    flagEmoji: '🇱🇧'
  },
  regions: [
    { id: 'beirut', nameEn: 'Beirut', nameAr: 'بيروت', regionCode: 'BE' },
    { id: 'mount-lebanon', nameEn: 'Mount Lebanon', nameAr: 'جبل لبنان', regionCode: 'ML' },
    { id: 'north', nameEn: 'North', nameAr: 'الشمال', regionCode: 'NO' },
    { id: 'akkar', nameEn: 'Akkar', nameAr: 'عكار', regionCode: 'AK' },
    { id: 'bekaa', nameEn: 'Bekaa', nameAr: 'البقاع', regionCode: 'BK' },
    { id: 'baalbek-hermel', nameEn: 'Baalbek-Hermel', nameAr: 'بعلبك - الهرمل', regionCode: 'BH' },
    { id: 'south', nameEn: 'South', nameAr: 'الجنوب', regionCode: 'SO' },
    { id: 'nabatieh', nameEn: 'Nabatieh', nameAr: 'النبطية', regionCode: 'NA' }
  ],
  cities: {
    'beirut': [
      { id: 'beirut-city', nameEn: 'Beirut', nameAr: 'بيروت', lat: 33.8938, lng: 35.5018 }
    ],
    'mount-lebanon': [
      { id: 'baabda', nameEn: 'Baabda', nameAr: 'بعبدا', lat: 33.8333, lng: 35.5444 },
      { id: 'jounieh', nameEn: 'Jounieh', nameAr: 'جونية', lat: 33.9811, lng: 35.6186 },
      { id: 'aley', nameEn: 'Aley', nameAr: 'عالية', lat: 33.8064, lng: 35.6019 },
      { id: 'jbeil', nameEn: 'Jbeil (Byblos)', nameAr: 'جبيل', lat: 34.1231, lng: 35.6519 },
      { id: 'jdeideh', nameEn: 'Jdeideh', nameAr: 'الجديدة', lat: 33.8833, lng: 35.5667 },
      { id: 'beiteddine', nameEn: 'Beiteddine', nameAr: 'بيت الدين', lat: 33.6953, lng: 35.5808 }
    ],
    'north': [
      { id: 'tripoli', nameEn: 'Tripoli', nameAr: 'طرابلس', lat: 34.4333, lng: 35.8333 },
      { id: 'zgharta', nameEn: 'Zgharta', nameAr: 'زغرتا', lat: 34.3833, lng: 35.8833 },
      { id: 'batroun', nameEn: 'Batroun', nameAr: 'البترون', lat: 34.2553, lng: 35.6581 },
      { id: 'bsharri', nameEn: 'Bsharri', nameAr: 'بشري', lat: 34.2508, lng: 36.0111 },
      { id: 'amyoun', nameEn: 'Amyoun', nameAr: 'أميون', lat: 34.3, lng: 35.8167 },
      { id: 'minieh', nameEn: 'Minieh', nameAr: 'المنية', lat: 34.4833, lng: 35.9167 }
    ],
    'akkar': [
      { id: 'halba', nameEn: 'Halba', nameAr: 'حلبا', lat: 34.5444, lng: 36.0806 },
      { id: 'qoubaiyat', nameEn: 'Qoubaiyat', nameAr: 'القبيات', lat: 34.5667, lng: 36.2667 }
    ],
    'bekaa': [
      { id: 'zahle', nameEn: 'Zahle', nameAr: 'زحلة', lat: 33.8439, lng: 35.9022 },
      { id: 'rashaya', nameEn: 'Rashaya', nameAr: 'راشيا', lat: 33.5, lng: 35.8444 },
      { id: 'jeb-jannine', nameEn: 'Jeb Jannine', nameAr: 'جب جنين', lat: 33.6289, lng: 35.7844 }
    ],
    'baalbek-hermel': [
      { id: 'baalbek', nameEn: 'Baalbek', nameAr: 'بعلبك', lat: 34.0058, lng: 36.2058 },
      { id: 'hermel', nameEn: 'Hermel', nameAr: 'الهرمل', lat: 34.3944, lng: 36.3844 }
    ],
    'south': [
      { id: 'sidon', nameEn: 'Sidon (Saida)', nameAr: 'صيدا', lat: 33.5633, lng: 35.3722 },
      { id: 'tyre', nameEn: 'Tyre (Sour)', nameAr: 'صور', lat: 33.2708, lng: 35.1961 },
      { id: 'jezzine', nameEn: 'Jezzine', nameAr: 'جزين', lat: 33.5422, lng: 35.5844 }
    ],
    'nabatieh': [
      { id: 'nabatieh-city', nameEn: 'Nabatieh', nameAr: 'النبطية', lat: 33.3789, lng: 35.4839 },
      { id: 'marjayoun', nameEn: 'Marjayoun', nameAr: 'مرجعيون', lat: 33.36, lng: 35.5919 },
      { id: 'hasbaya', nameEn: 'Hasbaya', nameAr: 'حاصبيا', lat: 33.3986, lng: 35.6881 },
      { id: 'bint-jbeil', nameEn: 'Bint Jbeil', nameAr: 'بنت جبيل', lat: 33.1222, lng: 35.4358 }
    ]
  }
};

// 4. HELPER FUNCTIONS
async function getAccessToken() {
  console.log('Refreshing access token...');
  const response = await axios.post('https://oauth2.googleapis.com/token', {
    client_id: credentials.client_id,
    client_secret: credentials.client_secret,
    refresh_token: credentials.refresh_token,
    grant_type: 'refresh_token'
  });
  return response.data.access_token;
}

async function executeMutation(token, operationName, variables) {
  try {
    const response = await axios.post(GRAPHQL_ENDPOINT, {
      operationName: operationName,
      variables: variables
    }, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    if (response.data.errors) {
      console.error(`GraphQL Errors for ${operationName} (${variables.id || variables.nameEn}):`, JSON.stringify(response.data.errors, null, 2));
      return false;
    }
    return true;
  } catch (error) {
    console.error(`Request Error for ${operationName} (${variables.id || variables.nameEn}):`, error.message);
    if (error.response) {
      console.error('Response Data:', JSON.stringify(error.response.data, null, 2));
    }
    return false;
  }
}

// 5. MAIN SEEDING LOGIC
async function seed() {
  console.log('--- STARTING LEBANON TAXONOMY SEEDING (DataConnect Connector) ---');

  const token = await getAccessToken();
  console.log('Access token acquired.');

  // Step 1: Country
  console.log(`Upserting Country: ${LEBANON_DATA.country.nameEn}...`);
  const countryOk = await executeMutation(token, 'UpsertCountry', LEBANON_DATA.country);
  if (!countryOk) {
    console.error('Failed to upsert country. Aborting.');
    return;
  }

  // Step 2: Regions
  for (const region of LEBANON_DATA.regions) {
    console.log(`  Upserting Region: ${region.nameEn}...`);
    const regionVariables = {
      ...region,
      countryId: LEBANON_DATA.country.id
    };
    const regionOk = await executeMutation(token, 'UpsertRegion', regionVariables);

    if (regionOk) {
      // Step 3: Cities for this region
      const cities = LEBANON_DATA.cities[region.id] || [];
      for (const city of cities) {
        console.log(`    Upserting City: ${city.nameEn}...`);
        const cityVariables = {
          ...city,
          regionId: region.id
        };
        await executeMutation(token, 'UpsertCity', cityVariables);
      }
    }
  }

  console.log('--- SEEDING COMPLETE ---');
}

seed().catch(err => {
  console.error('Fatal Error:', err);
  process.exit(1);
});
