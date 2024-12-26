-- Enable RLS on all tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_circuits ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_monthly_costs ENABLE ROW LEVEL SECURITY;
ALTER TABLE environment_variables ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policies for companies
CREATE POLICY "companies_view_policy"
  ON companies FOR SELECT TO authenticated USING (true);

CREATE POLICY "companies_create_policy"
  ON companies FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "companies_modify_policy"
  ON companies FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "companies_remove_policy"
  ON companies FOR DELETE TO authenticated USING (true);

-- Create policies for locations
CREATE POLICY "locations_view_policy"
  ON locations FOR SELECT TO authenticated USING (true);

CREATE POLICY "locations_create_policy"
  ON locations FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "locations_modify_policy"
  ON locations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "locations_remove_policy"
  ON locations FOR DELETE TO authenticated USING (true);

-- Create policies for circuits
CREATE POLICY "circuits_view_policy"
  ON circuits FOR SELECT TO authenticated USING (true);

CREATE POLICY "circuits_create_policy"
  ON circuits FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "circuits_modify_policy"
  ON circuits FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "circuits_remove_policy"
  ON circuits FOR DELETE TO authenticated USING (true);

-- Create policies for proposals
CREATE POLICY "proposals_view_policy"
  ON proposals FOR SELECT TO authenticated USING (true);

CREATE POLICY "proposals_create_policy"
  ON proposals FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "proposals_modify_policy"
  ON proposals FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "proposals_remove_policy"
  ON proposals FOR DELETE TO authenticated USING (true);

-- Create policies for proposal_locations
CREATE POLICY "proposal_locations_view_policy"
  ON proposal_locations FOR SELECT TO authenticated USING (true);

CREATE POLICY "proposal_locations_create_policy"
  ON proposal_locations FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "proposal_locations_modify_policy"
  ON proposal_locations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "proposal_locations_remove_policy"
  ON proposal_locations FOR DELETE TO authenticated USING (true);

-- Create policies for proposal_circuits
CREATE POLICY "proposal_circuits_view_policy"
  ON proposal_circuits FOR SELECT TO authenticated USING (true);

CREATE POLICY "proposal_circuits_create_policy"
  ON proposal_circuits FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "proposal_circuits_modify_policy"
  ON proposal_circuits FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "proposal_circuits_remove_policy"
  ON proposal_circuits FOR DELETE TO authenticated USING (true);

-- Create policies for proposal_monthly_costs
CREATE POLICY "monthly_costs_view_policy"
  ON proposal_monthly_costs FOR SELECT TO authenticated USING (true);

CREATE POLICY "monthly_costs_create_policy"
  ON proposal_monthly_costs FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "monthly_costs_modify_policy"
  ON proposal_monthly_costs FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "monthly_costs_remove_policy"
  ON proposal_monthly_costs FOR DELETE TO authenticated USING (true);

-- Create admin-only policies for environment_variables
CREATE POLICY "env_vars_view_policy"
  ON environment_variables FOR SELECT TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "env_vars_create_policy"
  ON environment_variables FOR INSERT TO authenticated
  WITH CHECK (is_admin(auth.uid()));

CREATE POLICY "env_vars_modify_policy"
  ON environment_variables FOR UPDATE TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));

-- Create policies for user_profiles
CREATE POLICY "user_profiles_view_own_policy"
  ON user_profiles FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "user_profiles_view_admin_policy"
  ON user_profiles FOR SELECT TO authenticated
  USING (is_admin(auth.uid()));

CREATE POLICY "user_profiles_create_policy"
  ON user_profiles FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_profiles_modify_own_policy"
  ON user_profiles FOR UPDATE TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_profiles_modify_admin_policy"
  ON user_profiles FOR UPDATE TO authenticated
  USING (is_admin(auth.uid()))
  WITH CHECK (is_admin(auth.uid()));