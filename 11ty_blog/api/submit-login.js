const { createClient } = require('@supabase/supabase-js');
const bcrypt = require('bcryptjs');

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

export default async function handler(req, res) {
  if (req.method === 'POST') {
    const { email, password } = req.body;

    const { data: user, error } = await supabase
      .from('employees_table')
      .select('id, email, password, name')
      .eq('email', email)
      .single();

    if (error || !user) {
      return res.status(400).json({ success: false, message: 'Invalid email or password' });
    }

    const passwordMatches = await bcrypt.compare(password, user.password);

    if (passwordMatches) {
      res.json({ success: true, message: 'Login successful', user });
    } else {
      res.status(400).json({ success: false, message: 'Invalid email or password' });
    }
  } else {
    res.status(405).json({ success: false, message: 'Method not allowed' });
  }
};
