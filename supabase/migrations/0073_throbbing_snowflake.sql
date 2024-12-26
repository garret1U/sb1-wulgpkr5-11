-- ===================================================================
-- 1. Create Required Functions
-- ===================================================================

-- Function to check if a user is admin
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_profiles.user_id = user_id
      AND role = 'admin'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ===================================================================
-- 2. Enable RLS on All Tables
-- ===================================================================

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_monthly_costs ENABLE ROW LEVEL SECURITY;
ALTER TABLE environment_variables ENABLE ROW LEVEL SECURITY;

-- ===================================================================
-- 3. Create RLS Policies for User Profiles
-- ===================================================================

-- Allow users to view their own profile
CREATE POLICY "user_profiles_select_own"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- Allow admins to view all profiles
CREATE POLICY "user_profiles_select_admin"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (is_admin(auth.uid()));

-- Allow users to update their own profile
CREATE POLICY "user_profiles_update_own"
  ON user_profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Allow admins to update any profile
CREATE POLICY "user_profiles_update_admin"
  ON user_profiles
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

-- ===================================================================
-- 4. Create RLS Policies for Other Tables
-- ===================================================================

-- Companies
CREATE POLICY "companies_select"
  ON companies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "companies_insert"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "companies_update"
  ON companies
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "companies_delete"
  ON companies
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Locations
CREATE POLICY "locations_select"
  ON locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "locations_insert"
  ON locations
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "locations_update"
  ON locations
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "locations_delete"
  ON locations
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Circuits
CREATE POLICY "circuits_select"
  ON circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "circuits_insert"
  ON circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "circuits_update"
  ON circuits
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "circuits_delete"
  ON circuits
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Proposals
CREATE POLICY "proposals_select"
  ON proposals
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposals_insert"
  ON proposals
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposals_update"
  ON proposals
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposals_delete"
  ON proposals
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Proposal Locations
CREATE POLICY "proposal_locations_select"
  ON proposal_locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposal_locations_insert"
  ON proposal_locations
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_locations_update"
  ON proposal_locations
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_locations_delete"
  ON proposal_locations
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Proposal Circuits
CREATE POLICY "proposal_circuits_select"
  ON proposal_circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposal_circuits_insert"
  ON proposal_circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_circuits_update"
  ON proposal_circuits
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_circuits_delete"
  ON proposal_circuits
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Proposal Monthly Costs
CREATE POLICY "proposal_monthly_costs_select"
  ON proposal_monthly_costs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "proposal_monthly_costs_insert"
  ON proposal_monthly_costs
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_monthly_costs_update"
  ON proposal_monthly_costs
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "proposal_monthly_costs_delete"
  ON proposal_monthly_costs
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));

-- Environment Variables
CREATE POLICY "environment_variables_select"
  ON environment_variables
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "environment_variables_insert"
  ON environment_variables
  FOR INSERT
  TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "environment_variables_update"
  ON environment_variables
  FOR UPDATE
  TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "environment_variables_delete"
  ON environment_variables
  FOR DELETE
  TO authenticated
  USING (is_admin(auth.uid()));