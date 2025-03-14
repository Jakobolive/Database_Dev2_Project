require('dotenv').config(); // Load environment variables from .env file
const { createClient } = require('@supabase/supabase-js');

// Get the Supabase credentials from environment variables
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

module.exports = async function () {
    const { data, error } = await supabase
        .from('blog_table')
        .select('blog_id, blog_title, author, message, published_date, employee_id');

    if (error) {
        console.error("Error Fetching Posts:", error);
        return []; // Always return an empty array if there is an error
    }

    // Do not decode HTML entities in the message field
    return data || []; // Ensure that we are always returning an array, even if data is undefined
};

