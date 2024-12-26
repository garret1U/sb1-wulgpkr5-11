-- Drop triggers first to avoid dependency issues
DO $$ 
DECLARE
  trigger_rec RECORD;
BEGIN
  FOR trigger_rec IN (
    SELECT tgname, relname 
    FROM pg_trigger t
    JOIN pg_class c ON t.tgrelid = c.oid
    JOIN pg_namespace n ON c.relnamespace = n.oid
    WHERE n.nspname = 'public'
  ) LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I CASCADE', 
      trigger_rec.tgname, 
      trigger_rec.relname
    );
  END LOOP;
END $$;

-- Drop all functions
DO $$ 
DECLARE
  func_rec RECORD;
BEGIN
  FOR func_rec IN (
    SELECT proname, oidvectortypes(proargtypes) as args
    FROM pg_proc
    JOIN pg_namespace ON pg_proc.pronamespace = pg_namespace.oid
    WHERE nspname = 'public'
  ) LOOP
    EXECUTE format('DROP FUNCTION IF EXISTS %I(%s) CASCADE', 
      func_rec.proname, 
      func_rec.args
    );
  END LOOP;
END $$;

-- Drop all policies
DO $$ 
DECLARE
  policy_rec RECORD;
BEGIN
  FOR policy_rec IN (
    SELECT schemaname, tablename, policyname 
    FROM pg_policies 
    WHERE schemaname = 'public'
  ) LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', 
      policy_rec.policyname, 
      policy_rec.schemaname, 
      policy_rec.tablename
    );
  END LOOP;
END $$;

-- Drop materialized views
DROP MATERIALIZED VIEW IF EXISTS admin_status CASCADE;
DROP MATERIALIZED VIEW IF EXISTS admin_users CASCADE;
DROP MATERIALIZED VIEW IF EXISTS circuit_location_details CASCADE;

-- Drop tables in correct dependency order
DROP TABLE IF EXISTS proposal_monthly_costs CASCADE;
DROP TABLE IF EXISTS proposal_circuits CASCADE;
DROP TABLE IF EXISTS proposal_locations CASCADE;
DROP TABLE IF EXISTS proposals CASCADE;
DROP TABLE IF EXISTS circuits CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS environment_variables CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;

-- Drop and recreate schema
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- Grant permissions
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;