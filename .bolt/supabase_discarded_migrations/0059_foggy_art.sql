-- Create base tables
CREATE TABLE IF NOT EXISTS companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name character varying(255) NOT NULL,
  street_address text NOT NULL,
  address_city text NOT NULL,
  address_state text NOT NULL,
  address_zip text NOT NULL,
  address_country text NOT NULL DEFAULT 'United States',
  phone character varying(20) NOT NULL,
  email character varying(255) NOT NULL,
  website character varying(255),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid,
  last_updated_by uuid
);

CREATE TABLE IF NOT EXISTS locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name character varying(255) NOT NULL,
  address text NOT NULL,
  city character varying(100) NOT NULL,
  state character varying(50) NOT NULL,
  zip_code character varying(20) NOT NULL,
  country character varying(100) NOT NULL,
  criticality character varying(10) NOT NULL,
  site_description text,
  critical_processes text,
  active_users integer DEFAULT 0,
  num_servers integer DEFAULT 0,
  num_devices integer DEFAULT 0,
  hosted_applications text,
  longitude text,
  latitude text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  company_id uuid REFERENCES companies(id) ON DELETE CASCADE NOT NULL,
  created_by uuid,
  last_updated_by uuid
);

CREATE TABLE IF NOT EXISTS circuits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  carrier text NOT NULL,
  type text NOT NULL,
  purpose text NOT NULL,
  status text NOT NULL,
  bandwidth text NOT NULL,
  monthlycost numeric NOT NULL CHECK (monthlycost >= 0),
  static_ips integer NOT NULL DEFAULT 0,
  upload_bandwidth character varying(255),
  contract_start_date date,
  contract_term integer CHECK (contract_term > 0),
  contract_end_date date,
  billing character varying(10) NOT NULL,
  usage_charges boolean DEFAULT false,
  installation_cost numeric(10,2) DEFAULT 0 CHECK (installation_cost >= 0),
  notes text,
  location_id uuid REFERENCES locations(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid,
  last_updated_by uuid
);

-- Create user profiles and auth
CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  role text NOT NULL CHECK (role IN ('admin', 'viewer')),
  first_name text,
  last_name text,
  email text,
  phone text,
  address text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(user_id)
);

-- Create proposals system
CREATE TABLE IF NOT EXISTS proposals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  company_id uuid REFERENCES companies(id) ON DELETE CASCADE NOT NULL,
  status text NOT NULL DEFAULT 'Draft' CHECK (status IN ('Draft', 'Pending', 'Approved', 'Rejected')),
  valid_until date,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES user_profiles(user_id),
  last_updated_by uuid REFERENCES user_profiles(user_id)
);

CREATE TABLE IF NOT EXISTS proposal_locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid REFERENCES proposals(id) ON DELETE CASCADE NOT NULL,
  location_id uuid REFERENCES locations(id) ON DELETE CASCADE NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(proposal_id, location_id)
);

CREATE TABLE IF NOT EXISTS proposal_circuits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid REFERENCES proposals(id) ON DELETE CASCADE NOT NULL,
  circuit_id uuid REFERENCES circuits(id) NOT NULL,
  location_id uuid REFERENCES locations(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT proposal_circuits_unique_circuit UNIQUE (proposal_id, circuit_id)
);

CREATE TABLE IF NOT EXISTS proposal_monthly_costs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid REFERENCES proposals(id) ON DELETE CASCADE NOT NULL,
  circuit_id uuid REFERENCES circuits(id) ON DELETE CASCADE NOT NULL,
  month_year date NOT NULL,
  monthly_cost numeric(10,2) NOT NULL DEFAULT 0 CHECK (monthly_cost >= 0),
  circuit_status text NOT NULL DEFAULT 'active' CHECK (circuit_status IN ('active', 'proposed')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT proposal_monthly_costs_unique UNIQUE (proposal_id, circuit_id, month_year)
);

-- Create environment variables table
CREATE TABLE IF NOT EXISTS environment_variables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  value text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);