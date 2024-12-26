/*
  # Add RLS Policies
  
  This migration adds Row Level Security (RLS) policies for all tables:
  1. Basic read access for authenticated users
  2. Write access for admin users
  3. User profile specific policies
*/

-- Create admin check function if it doesn't exist
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
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Admins can view all profiles"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (is_admin());

CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can update all profiles"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

-- Companies Policies
CREATE POLICY "Anyone can view companies"
  ON companies FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert companies"
  ON companies FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update companies"
  ON companies FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete companies"
  ON companies FOR DELETE
  TO authenticated
  USING (is_admin());

-- Locations Policies
CREATE POLICY "Anyone can view locations"
  ON locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert locations"
  ON locations FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update locations"
  ON locations FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete locations"
  ON locations FOR DELETE
  TO authenticated
  USING (is_admin());

-- Circuits Policies
CREATE POLICY "Anyone can view circuits"
  ON circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert circuits"
  ON circuits FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update circuits"
  ON circuits FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete circuits"
  ON circuits FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposals Policies
CREATE POLICY "Anyone can view proposals"
  ON proposals FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert proposals"
  ON proposals FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update proposals"
  ON proposals FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete proposals"
  ON proposals FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Locations Policies
CREATE POLICY "Anyone can view proposal locations"
  ON proposal_locations FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert proposal locations"
  ON proposal_locations FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update proposal locations"
  ON proposal_locations FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete proposal locations"
  ON proposal_locations FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Circuits Policies
CREATE POLICY "Anyone can view proposal circuits"
  ON proposal_circuits FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert proposal circuits"
  ON proposal_circuits FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update proposal circuits"
  ON proposal_circuits FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete proposal circuits"
  ON proposal_circuits FOR DELETE
  TO authenticated
  USING (is_admin());

-- Proposal Monthly Costs Policies
CREATE POLICY "Anyone can view proposal costs"
  ON proposal_monthly_costs FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert proposal costs"
  ON proposal_monthly_costs FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update proposal costs"
  ON proposal_monthly_costs FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete proposal costs"
  ON proposal_monthly_costs FOR DELETE
  TO authenticated
  USING (is_admin());

-- Environment Variables Policies
CREATE POLICY "Anyone can view environment variables"
  ON environment_variables FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Admins can insert environment variables"
  ON environment_variables FOR INSERT
  TO authenticated
  WITH CHECK (is_admin());

CREATE POLICY "Admins can update environment variables"
  ON environment_variables FOR UPDATE
  TO authenticated
  USING (is_admin())
  WITH CHECK (is_admin());

CREATE POLICY "Admins can delete environment variables"
  ON environment_variables FOR DELETE
  TO authenticated
  USING (is_admin());