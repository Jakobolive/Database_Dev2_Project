// api/submit-post.js
const { createClient } = require('@supabase/supabase-js');

// Initialize Supabase client (make sure to set the URL and anon key in environment variables)
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

module.exports = async (req, res) => {
  if (req.method === 'POST') {
    try {
      const { message, blog_title } = req.body;  // Get form data
      const user = JSON.parse(req.headers['x-user']); // Extract logged-in user from request header

      if (!user || !user.id || !user.name) {
        return res.status(400).json({ success: false, message: "User not logged in" });
      }

      // Insert the new blog post into the Supabase 'blog_table'
      const { data, error } = await supabase
        .from('blog_table')  // Replace with your actual table name
        .insert([
          {
            blog_title,
            message,
            author: user.name,
            employee_id: user.id,
            published_date: new Date().toISOString(), // Server-generated timestamp
          }
        ]);

      if (error) {
        console.error("Supabase Insert Error:", error);
        return res.status(500).json({ success: false, message: "Failed to save blog post" });
      }

      console.log("Blog post saved:", data);
      res.json({ success: true, message: "Blog post submitted successfully" });

    } catch (error) {
      console.error("Unexpected Error:", error);
      res.status(500).json({ success: false, message: "Server error" });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
};