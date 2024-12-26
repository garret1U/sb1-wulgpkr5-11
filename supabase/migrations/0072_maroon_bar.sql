-- Drop all RLS policies
DO $$ 
DECLARE
  r RECORD;
BEGIN
  -- Drop policies from all tables
  FOR r IN (
    SELECT schemaname, tablename 
    FROM pg_tables 
    WHERE schemaname = 'public'
  ) LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
      'allow_select_' || r.tablename,
      r.schemaname,
      r.tablename
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
      'allow_insert_' || r.tablename,
      r.schemaname,
      r.tablename
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
      'allow_update_' || r.tablename,
      r.schemaname,
      r.tablename
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
      'allow_delete_' || r.tablename,
      r.schemaname,
      r.tablename
    );
  END LOOP;
END $$;

-- Disable RLS on all tables
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE locations DISABLE ROW LEVEL SECURITY;
ALTER TABLE circuits DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposals DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_locations DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_circuits DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_monthly_costs DISABLE ROW LEVEL SECURITY;
ALTER TABLE environment_variables DISABLE ROW LEVEL SECURITY;

-- Update all existing users to be admin
UPDATE user_profiles SET role = 'admin';

-- Drop admin users materialized view since it's no longer needed
DROP MATERIALIZED VIEW IF EXISTS admin_users CASCADE;

-- Update handle_new_user function to make all new users admin
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (
    user_id,
    role,
    email
  )
  VALUES (
    NEW.id,
    'admin', -- Always make new users admin
    NEW.email
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;