-- Create function to check admin status
CREATE OR REPLACE FUNCTION is_admin(user_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 
    FROM user_profiles 
    WHERE user_profiles.user_id = $1 
    AND role = 'admin'
  );
$$;

-- Create function to sync profile with auth data
CREATE OR REPLACE FUNCTION sync_profile_data()
RETURNS TRIGGER AS $$
DECLARE
  auth_user auth.users%ROWTYPE;
BEGIN
  SELECT * INTO auth_user
  FROM auth.users
  WHERE id = NEW.user_id;

  NEW.email = COALESCE(NEW.email, auth_user.email);
  NEW.phone = COALESCE(NEW.phone, auth_user.phone);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  user_count INT;
BEGIN
  SELECT COUNT(*) INTO user_count FROM user_profiles;
  
  INSERT INTO public.user_profiles (
    user_id,
    role,
    email,
    phone
  )
  VALUES (
    NEW.id,
    CASE WHEN user_count = 0 THEN 'admin' ELSE 'viewer' END,
    NEW.email,
    NEW.phone
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to manage audit fields
CREATE OR REPLACE FUNCTION manage_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_by = auth.uid();
    NEW.last_updated_by = auth.uid();
  ELSIF TG_OP = 'UPDATE' THEN
    NEW.last_updated_by = auth.uid();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to refresh proposal monthly costs
CREATE OR REPLACE FUNCTION refresh_proposal_monthly_costs(proposal_uuid uuid)
RETURNS void AS $$
DECLARE
  start_dt date;
  end_dt date;
  curr_dt date;
  circ RECORD;
BEGIN
  -- Delete existing costs for this proposal
  DELETE FROM proposal_monthly_costs WHERE proposal_id = proposal_uuid;

  -- Get date range from all circuits in proposal
  SELECT 
    LEAST(
      COALESCE(MIN(c.contract_start_date), CURRENT_DATE),
      CURRENT_DATE
    ) as min_date,
    GREATEST(
      COALESCE(MAX(c.contract_end_date), CURRENT_DATE + interval '36 months'),
      CURRENT_DATE + interval '36 months'
    ) as max_date
  INTO start_dt, end_dt
  FROM proposal_circuits pc
  JOIN circuits c ON c.id = pc.circuit_id
  WHERE pc.proposal_id = proposal_uuid;

  -- If no dates found, use current date range
  IF start_dt IS NULL THEN
    start_dt := CURRENT_DATE;
    end_dt := CURRENT_DATE + interval '36 months';
  END IF;

  -- For each month in the range
  curr_dt := date_trunc('month', start_dt);
  WHILE curr_dt <= end_dt LOOP
    -- First handle active circuits
    FOR circ IN 
      SELECT 
        c.id as circuit_id,
        c.monthlycost,
        c.contract_start_date,
        c.contract_end_date
      FROM circuits c
      JOIN locations l ON l.id = c.location_id
      JOIN proposal_locations pl ON pl.location_id = l.id
      WHERE pl.proposal_id = proposal_uuid
      AND c.status = 'Active'
    LOOP
      -- If circuit is active in this month
      IF (circ.contract_start_date IS NULL OR circ.contract_start_date <= curr_dt)
      AND (circ.contract_end_date IS NULL OR circ.contract_end_date >= curr_dt) THEN
        INSERT INTO proposal_monthly_costs (
          proposal_id,
          circuit_id,
          month_year,
          monthly_cost,
          circuit_status
        ) VALUES (
          proposal_uuid,
          circ.circuit_id,
          curr_dt,
          circ.monthlycost,
          'active'
        )
        ON CONFLICT (proposal_id, circuit_id, month_year)
        DO UPDATE SET 
          monthly_cost = EXCLUDED.monthly_cost,
          circuit_status = EXCLUDED.circuit_status;
      END IF;
    END LOOP;

    -- Then handle proposed circuits
    FOR circ IN 
      SELECT 
        c.id as circuit_id,
        c.monthlycost,
        c.contract_start_date,
        c.contract_end_date
      FROM proposal_circuits pc
      JOIN circuits c ON c.id = pc.circuit_id
      WHERE pc.proposal_id = proposal_uuid
    LOOP
      -- If circuit is active in this month
      IF (circ.contract_start_date IS NULL OR circ.contract_start_date <= curr_dt)
      AND (circ.contract_end_date IS NULL OR circ.contract_end_date >= curr_dt) THEN
        INSERT INTO proposal_monthly_costs (
          proposal_id,
          circuit_id,
          month_year,
          monthly_cost,
          circuit_status
        ) VALUES (
          proposal_uuid,
          circ.circuit_id,
          curr_dt,
          circ.monthlycost,
          'proposed'
        )
        ON CONFLICT (proposal_id, circuit_id, month_year)
        DO UPDATE SET 
          monthly_cost = EXCLUDED.monthly_cost,
          circuit_status = EXCLUDED.circuit_status;
      END IF;
    END LOOP;

    curr_dt := curr_dt + interval '1 month';
  END LOOP;
END;
$$ LANGUAGE plpgsql;