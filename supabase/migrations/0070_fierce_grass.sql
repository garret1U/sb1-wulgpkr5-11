-- Drop existing policies
DROP POLICY IF EXISTS "allow_select_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "allow_select_all_profiles_admin" ON user_profiles;
DROP POLICY IF EXISTS "allow_update_own_profile" ON user_profiles;
DROP POLICY IF EXISTS "allow_update_all_profiles_admin" ON user_profiles;
DROP POLICY IF EXISTS "allow_insert_own_profile" ON user_profiles;

-- Create materialized view for admin users
CREATE MATERIALIZED VIEW IF NOT EXISTS admin_users AS
SELECT user_id
FROM user_profiles
WHERE role = 'admin';

-- Create unique index for fast lookups
CREATE UNIQUE INDEX IF NOT EXISTS idx_admin_users_user_id ON admin_users(user_id);

-- Create function to refresh admin users
CREATE OR REPLACE FUNCTION refresh_admin_users()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY admin_users;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to refresh admin users
CREATE TRIGGER refresh_admin_users_trigger
  AFTER INSERT OR UPDATE OR DELETE ON user_profiles
  FOR EACH STATEMENT
  EXECUTE FUNCTION refresh_admin_users();

-- Create new non-recursive policies
CREATE POLICY "basic_select"
  ON user_profiles
  FOR SELECT
  TO authenticated
  USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid())
  );

CREATE POLICY "basic_insert"
  ON user_profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "basic_update"
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

-- Initial refresh of admin users
REFRESH MATERIALIZED VIEW admin_users;