// Constants Needed.
const { createClient } = require('@supabase/supabase-js');
// Create Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);
// Export functionality
export default async function handler(req, res) {
  if (req.method === 'POST') {
    // Get the data from the request body
    const { blog_title, message } = req.body;
    const user = JSON.parse(req.headers['x-user']); // Get user info from the request headers

    // Check if user is logged in
    if (!user || !user.id || !user.name) {
      return res.status(400).json({ success: false, message: "User not logged in" });
    }

    try {
      // Insert the blog post data into the database
      const { data, error } = await supabase
        .from('blog_table')
        .insert([
          {
            blog_title,
            message,
            author: user.name,
            employee_id: user.id,
            published_date: new Date().toISOString(),
          }
        ]);

      // Handle any errors during the insertion
      if (error) {
        console.error("Supabase Insert Error:", error);
        return res.status(500).json({ success: false, message: "Failed to save blog post" });
      }

      // Successfully created the post
      res.json({ success: true, message: "Blog post submitted successfully" });
    } catch (error) {
      // Catch any unexpected errors
      console.error("Unexpected Error:", error);
      res.status(500).json({ success: false, message: "Server error occurred while saving the post" });
    }
  } else {
    // If not a POST request, return method not allowed
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
}
