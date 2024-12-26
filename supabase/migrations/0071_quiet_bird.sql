-- Drop existing policies
DROP POLICY IF EXISTS "basic_select" ON user_profiles;
DROP POLICY IF EXISTS "basic_insert" ON user_profiles;
DROP POLICY IF EXISTS "basic_update" ON user_profiles;

-- Create materialized view for admin users if it doesn't exist
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_users AS
SELECT user_id
FROM user_profiles
WHERE role = 'admin';

-- Create unique index for fast lookups if it doesn't exist
CREATE UNIQUE INDEX IF NOT EXISTS idx_admin_users_user_id ON admin_users(user_id);

-- Create function to refresh admin users if it doesn't exist
CREATE OR REPLACE FUNCTION refresh_admin_users()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY admin_users;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to refresh admin users if it doesn't exist
DROP TRIGGER IF EXISTS refresh_admin_users_trigger ON user_profiles;
CREATE TRIGGER refresh_admin_users_trigger
  AFTER INSERT OR UPDATE OR DELETE ON user_profiles
  FOR EACH STATEMENT
  EXECUTE FUNCTION refresh_admin_users();

-- Create new non-recursive policies for user_profiles
CREATE POLICY "allow_select_profile"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid())
  );

CREATE POLICY "allow_insert_profile"
  ON user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "allow_update_profile"
  ON user_profiles
  FOR UPDATE
  TO authenticated
  USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid())
  )
  WITH CHECK (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid())
  );

-- Create policies for companies
CREATE POLICY "allow_select_companies"
  ON companies
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_companies"
  ON companies
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_companies"
  ON companies
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_companies"
  ON companies
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for locations
CREATE POLICY "allow_select_locations"
  ON locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_locations"
  ON locations
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_locations"
  ON locations
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_locations"
  ON locations
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for circuits
CREATE POLICY "allow_select_circuits"
  ON circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_circuits"
  ON circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_circuits"
  ON circuits
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_circuits"
  ON circuits
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for proposals
CREATE POLICY "allow_select_proposals"
  ON proposals
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_proposals"
  ON proposals
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_proposals"
  ON proposals
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_proposals"
  ON proposals
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for proposal_locations
CREATE POLICY "allow_select_proposal_locations"
  ON proposal_locations
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_proposal_locations"
  ON proposal_locations
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_proposal_locations"
  ON proposal_locations
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_proposal_locations"
  ON proposal_locations
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for proposal_circuits
CREATE POLICY "allow_select_proposal_circuits"
  ON proposal_circuits
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_proposal_circuits"
  ON proposal_circuits
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_proposal_circuits"
  ON proposal_circuits
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_proposal_circuits"
  ON proposal_circuits
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for proposal_monthly_costs
CREATE POLICY "allow_select_proposal_costs"
  ON proposal_monthly_costs
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_proposal_costs"
  ON proposal_monthly_costs
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_proposal_costs"
  ON proposal_monthly_costs
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_proposal_costs"
  ON proposal_monthly_costs
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Create policies for environment_variables
CREATE POLICY "allow_select_env_vars"
  ON environment_variables
  FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_insert_env_vars"
  ON environment_variables
  FOR INSERT
  TO authenticated
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_update_env_vars"
  ON environment_variables
  FOR UPDATE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

CREATE POLICY "allow_delete_env_vars"
  ON environment_variables
  FOR DELETE
  TO authenticated
  USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));

-- Initial refresh of admin users view
REFRESH MATERIALIZED VIEW admin_users;