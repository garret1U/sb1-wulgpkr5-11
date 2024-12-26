-- Drop all objects in the public schema
DROP SCHEMA IF EXISTS public CASCADE;

-- Re-create the public schema
CREATE SCHEMA public;

-- Grant default permissions
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Note: We don't need to drop extensions or other system schemas
-- since they are managed by Supabase and should remain intact