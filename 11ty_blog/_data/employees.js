require('dotenv').config(); // Load environment variables from .env file
const { createClient } = require('@supabase/supabase-js');

// Get the Supabase credentials from environment variables
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

module.exports = async function () {
    // Fetch employee data from 'employees_table'
    const { data, error } = await supabase
        .from('employees_table')
        .select('id, name, username, email, phone_number, created_at');
    
    if (error) {
        console.error("Error Fetching Employees:", error);
        return [];
    }

    return data;
};
