-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own profile" ON user_profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON user_profiles;
DROP POLICY IF EXISTS "Anyone can view companies" ON companies;
DROP POLICY IF EXISTS "Anyone can view locations" ON locations;
DROP POLICY IF EXISTS "Anyone can view circuits" ON circuits;
DROP POLICY IF EXISTS "Anyone can view proposals" ON proposals;
DROP POLICY IF EXISTS "Anyone can view proposal locations" ON proposal_locations;
DROP POLICY IF EXISTS "Anyone can view proposal circuits" ON proposal_circuits;
DROP POLICY IF EXISTS "Anyone can view proposal costs" ON proposal_monthly_costs;
DROP POLICY IF EXISTS "Anyone can view environment variables" ON environment_variables;

-- Create non-recursive admin check function
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM user_profiles 
    WHERE user_id = auth.uid() 
    AND role = 'admin'
  );
$$;

-- User Profiles Policies
CREATE POLICY "select_own_profile"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "select_all_profiles_admin"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "update_own_profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "update_all_profiles_admin"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Companies Policies
CREATE POLICY "select_companies"
  ON companies FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_companies_admin"
  ON companies FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_companies_admin"
  ON companies FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_companies_admin"
  ON companies FOR DELETE
  TO authenticated
  USING (is_admin());

-- Locations Policies
CREATE POLICY "select_locations"
  ON locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_locations_admin"
  ON locations FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_locations_admin"
  ON locations FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_locations_admin"
  ON locations FOR DELETE
  TO authenticated
  USING (is_admin());

-- Circuits Policies
CREATE POLICY "select_circuits"
  ON circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_circuits_admin"
  ON circuits FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_circuits_admin"
  ON circuits FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_circuits_admin"
  ON circuits FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposals Policies
CREATE POLICY "select_proposals"
  ON proposals FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_proposals_admin"
  ON proposals FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_proposals_admin"
  ON proposals FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_proposals_admin"
  ON proposals FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Locations Policies
CREATE POLICY "select_proposal_locations"
  ON proposal_locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_proposal_locations_admin"
  ON proposal_locations FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_proposal_locations_admin"
  ON proposal_locations FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_proposal_locations_admin"
  ON proposal_locations FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Circuits Policies
CREATE POLICY "select_proposal_circuits"
  ON proposal_circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_proposal_circuits_admin"
  ON proposal_circuits FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_proposal_circuits_admin"
  ON proposal_circuits FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_proposal_circuits_admin"
  ON proposal_circuits FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Monthly Costs Policies
CREATE POLICY "select_proposal_costs"
  ON proposal_monthly_costs FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_proposal_costs_admin"
  ON proposal_monthly_costs FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_proposal_costs_admin"
  ON proposal_monthly_costs FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_proposal_costs_admin"
  ON proposal_monthly_costs FOR DELETE
  TO authenticated
  USING (is_admin());

-- Environment Variables Policies
CREATE POLICY "select_env_vars"
  ON environment_variables FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "insert_env_vars_admin"
  ON environment_variables FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "update_env_vars_admin"
  ON environment_variables FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "delete_env_vars_admin"
  ON environment_variables FOR DELETE
  TO authenticated
  USING (is_admin());