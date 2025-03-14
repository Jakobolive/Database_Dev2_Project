// Import shared Supabase client
const supabase = require('./supabase');
// export the function
module.exports = async function () {
    // Get blog data
    const { data, error } = await supabase
        .from('blog_table')
        .select('blog_id, blog_title, author, message, published_date, employee_id');
    // Handle errors
    if (error) {
        console.error("Error Fetching Posts:", error);
        return [];
    }

    return data || [];
};
