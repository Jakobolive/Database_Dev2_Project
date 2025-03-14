// api/submit-login.js
const { createClient } = require('@supabase/supabase-js');
const bcrypt = require('bcryptjs');

// Initialize Supabase client (make sure to set the URL and anon key in environment variables)
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

module.exports = async (req, res) => {
  if (req.method === 'POST') {
    try {
      const { email, password } = req.body;

      // Fetch user from Supabase
      const { data: user, error } = await supabase
        .from('employees_table')
        .select('id, email, password, name')
        .eq('email', email)
        .single();

      if (error || !user) {
        return res.status(400).json({ success: false, message: 'Invalid email or password' });
      }

      // Compare password with hashed password in Supabase
      const passwordMatches = await bcrypt.compare(password, user.password);

      if (passwordMatches) {
        res.json({ success: true, message: 'Login successful', user });
      } else {
        res.status(400).json({ success: false, message: 'Invalid email or password' });
      }
    } catch (error) {
      res.status(500).json({ success: false, message: 'An error occurred' });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
};