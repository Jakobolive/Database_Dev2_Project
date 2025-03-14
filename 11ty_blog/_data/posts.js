const supabase = require('./supabase'); // Import shared Supabase client

module.exports = async function () {
    const { data, error } = await supabase
        .from('blog_table')
        .select('blog_id, blog_title, author, message, published_date, employee_id');

    if (error) {
        console.error("Error Fetching Posts:", error);
        return [];
    }

    return data || [];
};
