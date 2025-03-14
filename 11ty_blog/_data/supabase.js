// Get environment variables
require("dotenv").config();
const { createClient } = require('@supabase/supabase-js');
// Create a new client instance
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
// Export the instance
module.exports = supabase;
