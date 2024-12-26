-- Drop existing policies
DROP POLICY IF EXISTS "select_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "select_all_profiles_admin" ON user_profiles;
DROP POLICY IF EXISTS "update_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "update_all_profiles_admin" ON user_profiles;

-- Create user profile policies
CREATE POLICY "allow_select_own_profile"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "allow_select_all_profiles_admin"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_update_own_profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "allow_update_all_profiles_admin"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

-- Create insert policy for user profiles
CREATE POLICY "allow_insert_own_profile"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Create basic read policies for all tables
CREATE POLICY "allow_read_all_companies"
  ON companies FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_locations"
  ON locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_circuits"
  ON circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_proposals"
  ON proposals FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_proposal_locations"
  ON proposal_locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_proposal_circuits"
  ON proposal_circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_proposal_costs"
  ON proposal_monthly_costs FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "allow_read_all_env_vars"
  ON environment_variables FOR SELECT
  TO authenticated
  USING (true);

-- Create admin-only write policies
CREATE POLICY "allow_admin_write_companies"
  ON companies FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_locations"
  ON locations FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_circuits"
  ON circuits FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_proposals"
  ON proposals FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_proposal_locations"
  ON proposal_locations FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_proposal_circuits"
  ON proposal_circuits FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_proposal_costs"
  ON proposal_monthly_costs FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));

CREATE POLICY "allow_admin_write_env_vars"
  ON environment_variables FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM user_profiles
    WHERE user_id = auth.uid()
    AND role = 'admin'
  ));