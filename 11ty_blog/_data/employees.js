const supabase = require('./supabase'); // Import shared Supabase client

module.exports = async function () {
    const { data, error } = await supabase
        .from('employees_table')
        .select('id, name, username, email, phone_number, created_at');
    
    if (error) {
        console.error("Error Fetching Employees:", error);
        return [];
    }

    return data;
};
