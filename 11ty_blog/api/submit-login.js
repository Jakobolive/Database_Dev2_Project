const { createClient } = require('@supabase/supabase-js');
const bcrypt = require('bcryptjs');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

export default async function handler(req, res) {
  if (req.method === 'POST') {
    try {
      const { email, password } = req.body;
      
      const { data: user, error } = await supabase
        .from('employees_table')
        .select('id, email, password, name')
        .eq('email', email)
        .single();
      
      if (error || !user) {
        console.error("Error retrieving user:", error);
        return res.status(400).json({ success: false, message: 'Invalid email or password' });
      }

      const passwordMatches = await bcrypt.compare(password, user.password);

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
