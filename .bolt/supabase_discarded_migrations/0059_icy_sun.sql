-- Create indexes for companies
CREATE INDEX IF NOT EXISTS idx_companies_name ON companies(name);
CREATE INDEX IF NOT EXISTS idx_companies_city ON companies(address_city);
CREATE INDEX IF NOT EXISTS idx_companies_state ON companies(address_state);

-- Create indexes for locations
CREATE INDEX IF NOT EXISTS idx_locations_name ON locations(name);
CREATE INDEX IF NOT EXISTS idx_locations_city ON locations(city);
CREATE INDEX IF NOT EXISTS idx_locations_state ON locations(state);
CREATE INDEX IF NOT EXISTS idx_locations_criticality ON locations(criticality);
CREATE INDEX IF NOT EXISTS idx_locations_company ON locations(company_id);
CREATE INDEX IF NOT EXISTS idx_locations_coordinates 
ON locations(longitude, latitude) 
WHERE longitude IS NOT NULL AND latitude IS NOT NULL;

-- Create indexes for circuits
CREATE INDEX IF NOT EXISTS idx_circuits_carrier ON circuits(carrier);
CREATE INDEX IF NOT EXISTS idx_circuits_type ON circuits(type);
CREATE INDEX IF NOT EXISTS idx_circuits_status ON circuits(status);
CREATE INDEX IF NOT EXISTS idx_circuits_location ON circuits(location_id);
CREATE INDEX IF NOT EXISTS idx_circuits_contract_dates
ON circuits(contract_start_date, contract_end_date)
WHERE contract_start_date IS NOT NULL;

-- Create indexes for proposals
CREATE INDEX IF NOT EXISTS idx_proposals_company ON proposals(company_id);
CREATE INDEX IF NOT EXISTS idx_proposals_status ON proposals(status);

-- Create indexes for proposal relationships
CREATE INDEX IF NOT EXISTS idx_proposal_locations_proposal ON proposal_locations(proposal_id);
CREATE INDEX IF NOT EXISTS idx_proposal_locations_location ON proposal_locations(location_id);
CREATE INDEX IF NOT EXISTS idx_proposal_circuits_proposal ON proposal_circuits(proposal_id);
CREATE INDEX IF NOT EXISTS idx_proposal_circuits_circuit ON proposal_circuits(circuit_id);
CREATE INDEX IF NOT EXISTS idx_proposal_circuits_location ON proposal_circuits(location_id);

-- Create indexes for monthly costs
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_proposal ON proposal_monthly_costs(proposal_id);
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_circuit ON proposal_monthly_costs(circuit_id);
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_date ON proposal_monthly_costs(month_year);
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_status ON proposal_monthly_costs(circuit_status);
CREATE INDEX IF NOT EXISTS idx_proposal_monthly_costs_composite ON proposal_monthly_costs(proposal_id, month_year);

-- Create index for user profiles
CREATE INDEX IF NOT EXISTS idx_user_profiles_admin_check
ON user_profiles(user_id, role)
WHERE role = 'admin';