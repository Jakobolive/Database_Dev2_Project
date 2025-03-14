// Import shared Supabase client
const supabase = require('./supabase'); 
// Export function
module.exports = async function () {
    // Get the employee data
    const { data, error } = await supabase
        .from('employees_table')
        .select('id, name, username, email, phone_number, created_at');
    // handle errors
    if (error) {
        console.error("Error Fetching Employees:", error);
        return [];
    }

    return data;
};
