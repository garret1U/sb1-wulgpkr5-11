-- Drop existing triggers first
DROP TRIGGER IF EXISTS sync_profile_data_trigger ON user_profiles;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS companies_audit_trigger ON companies;
DROP TRIGGER IF EXISTS locations_audit_trigger ON locations;
DROP TRIGGER IF EXISTS circuits_audit_trigger ON circuits;
DROP TRIGGER IF EXISTS proposals_audit_trigger ON proposals;
DROP TRIGGER IF EXISTS circuit_changes ON circuits;
DROP TRIGGER IF EXISTS proposal_circuit_changes ON proposal_circuits;

-- Drop existing functions
DROP FUNCTION IF EXISTS handle_circuit_changes() CASCADE;
DROP FUNCTION IF EXISTS handle_proposal_circuit_changes() CASCADE;

-- Create triggers for user profiles
CREATE TRIGGER sync_profile_data_trigger
  BEFORE INSERT OR UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION sync_profile_data();

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION handle_new_user();

-- Create audit triggers
CREATE TRIGGER companies_audit_trigger
  BEFORE INSERT OR UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION manage_audit_fields();

CREATE TRIGGER locations_audit_trigger
  BEFORE INSERT OR UPDATE ON locations
  FOR EACH ROW
  EXECUTE FUNCTION manage_audit_fields();

CREATE TRIGGER circuits_audit_trigger
  BEFORE INSERT OR UPDATE ON circuits
  FOR EACH ROW
  EXECUTE FUNCTION manage_audit_fields();

CREATE TRIGGER proposals_audit_trigger
  BEFORE INSERT OR UPDATE ON proposals
  FOR EACH ROW
  EXECUTE FUNCTION manage_audit_fields();

-- Create trigger function for circuit changes
CREATE OR REPLACE FUNCTION handle_circuit_changes()
RETURNS TRIGGER AS $$
DECLARE
  affected_proposal_id uuid;
BEGIN
  -- Only proceed if relevant fields changed
  IF (TG_OP = 'UPDATE' AND (
    OLD.monthlycost != NEW.monthlycost OR
    OLD.contract_start_date != NEW.contract_start_date OR
    OLD.contract_end_date != NEW.contract_end_date
  )) OR TG_OP IN ('INSERT', 'DELETE') THEN
    -- Recalculate costs for all affected proposals
    FOR affected_proposal_id IN 
      SELECT DISTINCT proposal_id 
      FROM proposal_circuits 
      WHERE circuit_id = COALESCE(NEW.id, OLD.id)
    LOOP
      PERFORM refresh_proposal_monthly_costs(affected_proposal_id);
    END LOOP;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create trigger function for proposal circuit changes
CREATE OR REPLACE FUNCTION handle_proposal_circuit_changes()
RETURNS TRIGGER AS $$
BEGIN
  -- Recalculate costs for affected proposal
  IF TG_OP = 'DELETE' THEN
    PERFORM refresh_proposal_monthly_costs(OLD.proposal_id);
  ELSE
    PERFORM refresh_proposal_monthly_costs(NEW.proposal_id);
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create proposal triggers
CREATE TRIGGER circuit_changes
  AFTER INSERT OR UPDATE OR DELETE ON circuits
  FOR EACH ROW
  EXECUTE FUNCTION handle_circuit_changes();

CREATE TRIGGER proposal_circuit_changes
  AFTER INSERT OR UPDATE OR DELETE ON proposal_circuits
  FOR EACH ROW
  EXECUTE FUNCTION handle_proposal_circuit_changes();