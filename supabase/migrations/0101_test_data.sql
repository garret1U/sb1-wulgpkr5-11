--------------------------------------------------------------------------------
-- EXAMPLE: Recreate Test Data for Companies, Locations, and Circuits
--------------------------------------------------------------------------------

DO $$
DECLARE
  company_id uuid;
BEGIN
  --------------------------------------------------------------------------------
  -- 1) If no companies exist, create a quick placeholder company 
  --------------------------------------------------------------------------------
  IF NOT EXISTS (SELECT 1 FROM companies) THEN
    INSERT INTO companies (
      name,
      street_address,
      address_city,
      address_state,
      address_zip,
      address_country,
      phone,
      email
    )
    VALUES (
      'Test Corporation',
      '1001 Example Street',
      'FakeCity',
      'XX',
      '12345',
      'United States',
      '555-1000',
      'test@example.com'
    );
  END IF;

  --------------------------------------------------------------------------------
  -- Retrieve the first company's ID
  --------------------------------------------------------------------------------
  SELECT id
    INTO company_id
    FROM companies
    ORDER BY created_at
    LIMIT 1;

  --------------------------------------------------------------------------------
  -- 2) Insert 10 test locations for that company
  --------------------------------------------------------------------------------
  INSERT INTO locations (
    name,
    address,
    city,
    state,
    zip_code,
    country,
    criticality,
    company_id
  )
  VALUES
    ('Data Center Alpha',      '123 Tech Park Drive',  'Austin',   'TX', '78701', 'USA', 'High',   company_id),
    ('Regional Office Beta',   '456 Business Ave',     'Denver',   'CO', '80202', 'USA', 'Medium', company_id),
    ('Branch Office Gamma',    '789 Commerce St',      'Seattle',  'WA', '98101', 'USA', 'Low',    company_id),
    ('Operations Center Delta','321 Enterprise Way',   'Chicago',  'IL', '60601', 'USA', 'High',   company_id),
    ('Sales Office Epsilon',   '654 Market Square',    'Boston',   'MA', '02108', 'USA', 'Medium', company_id),
    ('Support Center Zeta',    '987 Service Road',     'Atlanta',  'GA', '30301', 'USA', 'Medium', company_id),
    ('Distribution Hub Eta',   '147 Logistics Pkwy',   'Phoenix',  'AZ', '85001', 'USA', 'High',   company_id),
    ('Research Lab Theta',     '258 Innovation Blvd',  'Portland', 'OR', '97201', 'USA', 'Low',    company_id),
    ('Call Center Iota',       '369 Contact Drive',    'Miami',    'FL', '33101', 'USA', 'Medium', company_id),
    ('Backup Site Kappa',      '741 Redundancy Lane',  'Nashville','TN', '37201', 'USA', 'High',   company_id);

  --------------------------------------------------------------------------------
  -- 3) Insert 2 active circuits per location
  --------------------------------------------------------------------------------
  INSERT INTO circuits (
    carrier,
    type,
    purpose,
    status,
    bandwidth,
    monthlycost,
    static_ips,
    upload_bandwidth,
    contract_start_date,
    contract_term,
    contract_end_date,
    billing,
    usage_charges,
    installation_cost,
    location_id,
    notes
  )
  SELECT
    CASE (RANDOM() * 3)::INT
      WHEN 0 THEN 'AT&T'
      WHEN 1 THEN 'Verizon'
      WHEN 2 THEN 'CenturyLink'
      ELSE 'Spectrum'
    END AS carrier,
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'MPLS'
      WHEN 1 THEN 'DIA'
      ELSE 'Broadband'
    END AS type,
    CASE MOD(ROW_NUMBER() OVER (), 2)
      WHEN 0 THEN 'Primary'
      ELSE 'Secondary'
    END AS purpose,
    'Active' AS status,
    ((RANDOM() * 900 + 100)::INT || ' Mbps') AS bandwidth,
    (RANDOM() * 2000 + 500)::NUMERIC(10,2) AS monthlycost,
    (RANDOM() * 8 + 1)::INT AS static_ips,
    ((RANDOM() * 400 + 100)::INT || ' Mbps') AS upload_bandwidth,
    CURRENT_DATE - (RANDOM() * 365)::INT AS contract_start_date,
    12 * (RANDOM() * 2 + 1)::INT AS contract_term,
    CURRENT_DATE + (RANDOM() * 365)::INT AS contract_end_date,
    'Monthly' AS billing,
    (RANDOM() > 0.7) AS usage_charges,
    (RANDOM() * 1000)::NUMERIC(10,2) AS installation_cost,
    id AS location_id,
    'Active circuit configuration' AS notes
  FROM locations;

  --------------------------------------------------------------------------------
  -- 4) Insert 1-3 proposed ("Quoted") circuits per location
  --------------------------------------------------------------------------------
  INSERT INTO circuits (
    carrier,
    type,
    purpose,
    status,
    bandwidth,
    monthlycost,
    static_ips,
    upload_bandwidth,
    contract_start_date,
    contract_term,
    contract_end_date,
    billing,
    usage_charges,
    installation_cost,
    location_id,
    notes
  )
  SELECT
    CASE (RANDOM() * 3)::INT
      WHEN 0 THEN 'Lumen'
      WHEN 1 THEN 'Cox'
      WHEN 2 THEN 'Comcast'
      ELSE 'Charter'
    END AS carrier,
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'MPLS'
      WHEN 1 THEN 'DIA'
      ELSE 'Broadband'
    END AS type,
    CASE (RANDOM() * 2)::INT
      WHEN 0 THEN 'Primary'
      WHEN 1 THEN 'Secondary'
      ELSE 'Backup'
    END AS purpose,
    'Quoted' AS status,
    ((RANDOM() * 900 + 100)::INT || ' Mbps') AS bandwidth,
    (RANDOM() * 2000 + 500)::NUMERIC(10,2) AS monthlycost,
    (RANDOM() * 8 + 1)::INT AS static_ips,
    ((RANDOM() * 400 + 100)::INT || ' Mbps') AS upload_bandwidth,
    CURRENT_DATE + (RANDOM() * 30)::INT AS contract_start_date,
    12 * (RANDOM() * 2 + 1)::INT AS contract_term,
    CURRENT_DATE + (RANDOM() * 365 + 365)::INT AS contract_end_date,
    'Monthly' AS billing,
    (RANDOM() > 0.7) AS usage_charges,
    (RANDOM() * 1000)::NUMERIC(10,2) AS installation_cost,
    id AS location_id,
    'Proposed circuit quote' AS notes
  FROM locations
  CROSS JOIN generate_series(1, (RANDOM() * 2 + 1)::INT);

END;
$$ LANGUAGE plpgsql;
