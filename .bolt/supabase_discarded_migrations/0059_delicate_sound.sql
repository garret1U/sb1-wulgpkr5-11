-- Drop existing policies
DROP POLICY IF EXISTS "user_profiles_select_own" ON user_profiles;
DROP POLICY IF EXISTS "user_profiles_select_admin" ON user_profiles;
DROP POLICY IF EXISTS "user_profiles_insert_own" ON user_profiles;
DROP POLICY IF EXISTS "user_profiles_update_own" ON user_profiles;
DROP POLICY IF EXISTS "user_profiles_update_admin" ON user_profiles;

DROP POLICY IF EXISTS "companies_select" ON companies;
DROP POLICY IF EXISTS "companies_insert" ON companies;
DROP POLICY IF EXISTS "companies_update" ON companies;
DROP POLICY IF EXISTS "companies_delete" ON companies;

DROP POLICY IF EXISTS "locations_select" ON locations;
DROP POLICY IF EXISTS "locations_insert" ON locations;
DROP POLICY IF EXISTS "locations_update" ON locations;
DROP POLICY IF EXISTS "locations_delete" ON locations;

DROP POLICY IF EXISTS "circuits_select" ON circuits;
DROP POLICY IF EXISTS "circuits_insert" ON circuits;
DROP POLICY IF EXISTS "circuits_update" ON circuits;
DROP POLICY IF EXISTS "circuits_delete" ON circuits;

DROP POLICY IF EXISTS "proposals_select" ON proposals;
DROP POLICY IF EXISTS "proposals_insert" ON proposals;
DROP POLICY IF EXISTS "proposals_update" ON proposals;
DROP POLICY IF EXISTS "proposals_delete" ON proposals;

DROP POLICY IF EXISTS "proposal_locations_select" ON proposal_locations;
DROP POLICY IF EXISTS "proposal_locations_insert" ON proposal_locations;
DROP POLICY IF EXISTS "proposal_locations_update" ON proposal_locations;
DROP POLICY IF EXISTS "proposal_locations_delete" ON proposal_locations;

DROP POLICY IF EXISTS "proposal_circuits_select" ON proposal_circuits;
DROP POLICY IF EXISTS "proposal_circuits_insert" ON proposal_circuits;
DROP POLICY IF EXISTS "proposal_circuits_update" ON proposal_circuits;
DROP POLICY IF EXISTS "proposal_circuits_delete" ON proposal_circuits;

DROP POLICY IF EXISTS "monthly_costs_select" ON proposal_monthly_costs;
DROP POLICY IF EXISTS "monthly_costs_insert" ON proposal_monthly_costs;
DROP POLICY IF EXISTS "monthly_costs_update" ON proposal_monthly_costs;
DROP POLICY IF EXISTS "monthly_costs_delete" ON proposal_monthly_costs;

DROP POLICY IF EXISTS "env_vars_select_admin" ON environment_variables;
DROP POLICY IF EXISTS "env_vars_insert_admin" ON environment_variables;
DROP POLICY IF EXISTS "env_vars_update_admin" ON environment_variables;

-- Enable RLS on all tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_monthly_costs ENABLE ROW LEVEL SECURITY;
ALTER TABLE environment_variables ENABLE ROW LEVEL SECURITY;

-- User Profiles Policies
CREATE POLICY "user_profiles_select_own"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "user_profiles_select_admin"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "user_profiles_insert_own"
  ON user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_profiles_update_own"
  ON user_profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_profiles_update_admin"
  ON user_profiles
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

-- Companies Policies
CREATE POLICY "companies_select"
  ON companies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "companies_insert"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "companies_update"
  ON companies
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "companies_delete"
  ON companies
  FOR DELETE
  TO authenticated
  USING (true);

-- Locations Policies
CREATE POLICY "locations_select"
  ON locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "locations_insert"
  ON locations
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "locations_update"
  ON locations
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "locations_delete"
  ON locations
  FOR DELETE
  TO authenticated
  USING (true);

-- Circuits Policies
CREATE POLICY "circuits_select"
  ON circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "circuits_insert"
  ON circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "circuits_update"
  ON circuits
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "circuits_delete"
  ON circuits
  FOR DELETE
  TO authenticated
  USING (true);

-- Proposals Policies
CREATE POLICY "proposals_select"
  ON proposals
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposals_insert"
  ON proposals
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "proposals_update"
  ON proposals
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "proposals_delete"
  ON proposals
  FOR DELETE
  TO authenticated
  USING (true);

-- Proposal Locations Policies
CREATE POLICY "proposal_locations_select"
  ON proposal_locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposal_locations_insert"
  ON proposal_locations
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "proposal_locations_update"
  ON proposal_locations
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "proposal_locations_delete"
  ON proposal_locations
  FOR DELETE
  TO authenticated
  USING (true);

-- Proposal Circuits Policies
CREATE POLICY "proposal_circuits_select"
  ON proposal_circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposal_circuits_insert"
  ON proposal_circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "proposal_circuits_update"
  ON proposal_circuits
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "proposal_circuits_delete"
  ON proposal_circuits
  FOR DELETE
  TO authenticated
  USING (true);

-- Proposal Monthly Costs Policies
CREATE POLICY "monthly_costs_select"
  ON proposal_monthly_costs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "monthly_costs_insert"
  ON proposal_monthly_costs
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "monthly_costs_update"
  ON proposal_monthly_costs
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "monthly_costs_delete"
  ON proposal_monthly_costs
  FOR DELETE
  TO authenticated
  USING (true);

-- Environment Variables Policies
CREATE POLICY "env_vars_select_admin"
  ON environment_variables
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "env_vars_insert_admin"
  ON environment_variables
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "env_vars_update_admin"
  ON environment_variables
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));