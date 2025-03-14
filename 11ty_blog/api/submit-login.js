// Constants Needed
const { createClient } = require('@supabase/supabase-js');
const bcrypt = require('bcryptjs');
// Create Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);
// Export functionality
export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      // Get user input
      const { email, password } = req.body;
      // Test user input
      const { data: user, error } = await supabase
        .from('employees_table')
        .select('*')
        .eq('email', email)
        .single();
      // Check for errors
      if (error || !user) {
        console.error("Error retrieving user:", error);
        return res.status(400).json({ success: false, message: 'Invalid email or password' });
      }
      // Check for match
      const passwordMatches = await bcrypt.compare(password, user.password);
      // Handle results
      if (passwordMatches) {
        res.json({ success: true, message: 'Login successful', user });
      } else {
        return res.status(400).json({ success: false, message: 'Invalid email or password' });
      }
    } catch (error) {
      console.error("Error during login:", error);
      return res.status(500).json({ success: false, message: 'Internal server error' });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
};
