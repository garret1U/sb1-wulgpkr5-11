/*
  # Azure Maps Configuration
  
  Adds Azure Maps API keys and configuration to environment variables
*/

INSERT INTO environment_variables (key, value, description)
VALUES
  (
    'AZURE_MAPS_CLIENT_ID',
    'c5b432a0-df11-408b-9b45-901749598ad7',
    'Azure Maps Client ID'
  ),
  (
    'AZURE_MAPS_PRIMARY_KEY',
    '9ECI3Tr3IBqanjfubsNI6RNRnkMKtNTBuRBfIsiNNx4aOtglgOLKJQQJ99ALACYeBjFGtcyPAAAgAZMPKUg5',
    'Primary key used to authenticate Azure Maps requests'
  ),
  (
    'AZURE_MAPS_SECONDARY_KEY',
    '7XWSOgKyVrGg5Myo99apmAPBqX7CCefZOgVGGNE9oSZaO3luH0U6JQQJ99ALACYeBjFGtcyPAAAgAZMP4AHQ',
    'Secondary key for Azure Maps'
  )
ON CONFLICT (key)
DO UPDATE
  SET value = EXCLUDED.value,
      description = EXCLUDED.description;