/*
  # Remove All Users
  
  This migration:
  1. Removes all user sessions
  2. Deletes all user profiles
  3. Deletes all auth users
*/

-- First remove all sessions
DELETE FROM auth.sessions;

-- Then remove all user profiles
DELETE FROM user_profiles;

-- Finally remove all users from auth schema
DELETE FROM auth.users;

-- Reset any sequences
ALTER SEQUENCE IF EXISTS auth.users_id_seq RESTART;
ALTER SEQUENCE IF EXISTS user_profiles_id_seq RESTART;