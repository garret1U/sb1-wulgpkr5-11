-- Filename: 0001_bootstrap.sql
-- Purpose: Completely drop the public schema, then create all objects (tables, triggers, policies, etc.)

BEGIN;

-------------------------------------------------------------------------------
-- 1) Nuke the entire "public" schema.
-------------------------------------------------------------------------------
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-------------------------------------------------------------------------------
-- 2) (Optional) If you rely on "auth" or other Supabase schemas, ensure they're present.
--    Supabase typically has "auth" and "extensions" by default, so you might skip this
--    unless your environment is 100% custom.
-------------------------------------------------------------------------------
-- CREATE SCHEMA IF NOT EXISTS auth;
-- CREATE SCHEMA IF NOT EXISTS extensions;

-------------------------------------------------------------------------------
-- 3) Recreate all base tables, user profiles, environment variables, etc.
-------------------------------------------------------------------------------

-- If you use Postgres “uuid-ossp” extension, enable it
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;

-------------------------------------------------------------------------------
-- Example: user_profiles table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
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

-- If you rely on references to auth.users
-- (In Supabase, user_id references auth.users(id).)
-- Then do it explicitly if the table is truly in public:
-- (If you want to keep it in-line, otherwise adapt as needed.)
ALTER TABLE public.user_profiles
  ADD CONSTRAINT user_profiles_user_id_fkey
  FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE;

-- RLS enable:
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: companies table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.companies (
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

-- RLS enable:
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: locations table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.locations (
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
  num_devices integer DEFAULT 0 CHECK (num_devices >= 0),
  hosted_applications text,
  longitude text,
  latitude text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  company_id uuid NOT NULL,
  created_by uuid,
  last_updated_by uuid
);

ALTER TABLE public.locations
  ADD CONSTRAINT locations_company_id_fkey
  FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;

ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: circuits table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.circuits (
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
  location_id uuid NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid,
  last_updated_by uuid
);

ALTER TABLE public.circuits
  ADD CONSTRAINT circuits_location_id_fkey
  FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;

ALTER TABLE public.circuits ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: proposals table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proposals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  company_id uuid NOT NULL REFERENCES public.companies(id) ON DELETE CASCADE,
  status text NOT NULL DEFAULT 'Draft' CHECK (status IN ('Draft', 'Pending', 'Approved', 'Rejected')),
  valid_until date,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  created_by uuid REFERENCES public.user_profiles(user_id),
  last_updated_by uuid
);

ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: proposal_locations table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proposal_locations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid NOT NULL REFERENCES public.proposals(id) ON DELETE CASCADE,
  location_id uuid NOT NULL REFERENCES public.locations(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(proposal_id, location_id)
);

ALTER TABLE public.proposal_locations ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: proposal_circuits table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proposal_circuits (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid REFERENCES public.proposals(id) ON DELETE CASCADE NOT NULL,
  circuit_id uuid REFERENCES public.circuits(id) NOT NULL,
  location_id uuid REFERENCES public.locations(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT proposal_circuits_unique_circuit UNIQUE (proposal_id, circuit_id)
);

ALTER TABLE public.proposal_circuits ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: proposal_monthly_costs table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proposal_monthly_costs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id uuid REFERENCES public.proposals(id) ON DELETE CASCADE NOT NULL,
  circuit_id uuid REFERENCES public.circuits(id) ON DELETE CASCADE NOT NULL,
  month_year date NOT NULL,
  monthly_cost numeric(10,2) NOT NULL DEFAULT 0 CHECK (monthly_cost >= 0),
  circuit_status text NOT NULL DEFAULT 'active' CHECK (circuit_status IN ('active', 'proposed')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(proposal_id, circuit_id, month_year)
);

ALTER TABLE public.proposal_monthly_costs ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- Example: environment_variables table
-------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.environment_variables (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  value text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.environment_variables ENABLE ROW LEVEL SECURITY;

-------------------------------------------------------------------------------
-- 4) (Optional) Create or restore triggers/functions for auditing or RLS policies
-------------------------------------------------------------------------------
-- Below are placeholders for your actual trigger & function definitions:

-- Example: manage_audit_fields
CREATE OR REPLACE FUNCTION public.manage_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_by = auth.uid();
    NEW.last_updated_by = auth.uid();
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.last_updated_by = auth.uid();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example triggers on companies, etc.
CREATE TRIGGER companies_audit_trigger
  BEFORE INSERT OR UPDATE ON public.companies
  FOR EACH ROW
  EXECUTE FUNCTION public.manage_audit_fields();

-- ...and so on for locations, circuits, proposals, user_profiles, etc.

-------------------------------------------------------------------------------
-- 5) Example Row Level Security (RLS) policies.
-------------------------------------------------------------------------------
-- For user_profiles:
CREATE POLICY user_profiles_select_own
  ON public.user_profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- ...any additional policy definitions you need...
-- (The rest are up to your needs.)

-------------------------------------------------------------------------------
-- 6) Indexes (just examples)
-------------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_companies_name ON public.companies(name);
CREATE INDEX IF NOT EXISTS idx_locations_name ON public.locations(name);
CREATE INDEX IF NOT EXISTS idx_circuits_carrier ON public.circuits(carrier);
CREATE INDEX IF NOT EXISTS idx_proposals_company ON public.proposals(company_id);
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_proposal ON public.proposal_monthly_costs(proposal_id);

COMMIT;
