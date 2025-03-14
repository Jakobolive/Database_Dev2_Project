const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

export default async function handler(req, res) {
  if (req.method === 'POST') {
    const { message, blog_title } = req.body;
    const user = JSON.parse(req.headers['x-user']);

    if (!user || !user.id || !user.name) {
      return res.status(400).json({ success: false, message: "User not logged in" });
    }

    try {
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

      if (error) {
        console.error("Supabase Insert Error:", error);
        return res.status(500).json({ success: false, message: "Failed to save blog post" });
      }

      res.json({ success: true, message: "Blog post submitted successfully" });
    } catch (error) {
      console.error("Unexpected Error:", error);
      res.status(500).json({ success: false, message: "Server error" });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
};
