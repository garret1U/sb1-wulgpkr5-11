/*
  # Bootstrap Cleanup Migration
  This script force-drops any existing tables, policies, triggers, and functions that might conflict.
  Adjust or remove sections you need to keep.
*/

-- =============== Drop triggers & functions referencing your schema ===============
-- (List all known triggers/functions that might be leftover.)
DROP TRIGGER IF EXISTS sync_profile_data_trigger ON user_profiles;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS companies_audit_trigger ON companies;
DROP TRIGGER IF EXISTS locations_audit_trigger ON locations;
DROP TRIGGER IF EXISTS circuits_audit_trigger ON circuits;
DROP TRIGGER IF EXISTS proposals_audit_trigger ON proposals;
DROP TRIGGER IF EXISTS circuit_changes ON circuits;
DROP TRIGGER IF EXISTS proposal_circuit_changes ON proposal_circuits;
DROP TRIGGER IF EXISTS refresh_admin_users_trigger ON user_profiles;
DROP TRIGGER IF EXISTS validate_proposal_circuit ON proposal_circuits;

-- Drop some functions
DROP FUNCTION IF EXISTS handle_circuit_changes() CASCADE;
DROP FUNCTION IF EXISTS handle_proposal_circuit_changes() CASCADE;
DROP FUNCTION IF EXISTS refresh_proposal_monthly_costs(uuid) CASCADE;
DROP FUNCTION IF EXISTS sync_profile_data_trigger() CASCADE;
DROP FUNCTION IF EXISTS handle_new_user() CASCADE;
DROP FUNCTION IF EXISTS manage_audit_fields() CASCADE;
DROP FUNCTION IF EXISTS refresh_admin_users() CASCADE;
DROP FUNCTION IF EXISTS validate_circuit_location() CASCADE;
DROP FUNCTION IF EXISTS is_admin(uuid) CASCADE;
DROP FUNCTION IF EXISTS has_admin_role(uuid) CASCADE;
DROP FUNCTION IF EXISTS check_admin_role(uuid) CASCADE;
DROP FUNCTION IF EXISTS refresh_admin_status() CASCADE;
DROP FUNCTION IF EXISTS sync_is_admin() CASCADE;
-- (Add or remove more as needed.)

-- =============== Drop policies if they exist (for each table) ===============
-- For example, let's do it for proposals:
DROP POLICY IF EXISTS "proposals_select" ON proposals;
DROP POLICY IF EXISTS "proposals_insert" ON proposals;
DROP POLICY IF EXISTS "proposals_update" ON proposals;
DROP POLICY IF EXISTS "proposals_delete" ON proposals;
-- ...and so on for all your tables (companies, locations, circuits, user_profiles, environment_variables, etc.).

-- =============== Drop tables in correct order (to satisfy foreign keys) ===============
-- For example, first drop anything referencing others (proposal_monthly_costs, proposal_circuits, etc.),
-- then proposals, circuits, locations, companies, user_profiles, environment_variables, etc.

DROP TABLE IF EXISTS proposal_monthly_costs CASCADE;
DROP TABLE IF EXISTS proposal_circuits CASCADE;
DROP TABLE IF EXISTS proposal_locations CASCADE;
DROP TABLE IF EXISTS proposals CASCADE;
DROP TABLE IF EXISTS circuits CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS companies CASCADE;
DROP TABLE IF EXISTS environment_variables CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;

-- If you have a materialized view or special objects:
DROP MATERIALIZED VIEW IF EXISTS admin_status CASCADE;
DROP MATERIALIZED VIEW IF EXISTS admin_users CASCADE;

-- This ensures you start from a truly blank slate.