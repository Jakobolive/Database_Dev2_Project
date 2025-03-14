// require('dotenv').config(); // Load environment variables
// const express = require('express');
// const bcrypt = require('bcryptjs');
// const { createClient } = require('@supabase/supabase-js');
// const bodyParser = require('body-parser');
// const path = require('path');

// const app = express();
// const port = 3000;

// // Supabase configuration
// const SUPABASE_URL = process.env.SUPABASE_URL;
// const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;
// const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// // Middleware
// app.use(bodyParser.json());
// app.use(express.urlencoded({ extended: true })); // Support form submissions

// // **Serve Eleventy Frontend**
// app.use(express.static(path.join(__dirname, '_site')));  

// // **Login Route**
// app.post('/submit-login', async (req, res) => {
//     console.log('Login request received:', req.body);
//     const { email, password } = req.body;

//     // Fetch user from Supabase
//     const { data: user, error: fetchError } = await supabase
//         .from('employees_table')
//         .select('id, email, password, name')
//         .eq('email', email)
//         .single();

//     console.log('User retrieved:', user);
//     console.log('Fetch error:', fetchError);

//     if (fetchError || !user) {
//         console.error('Error fetching user:', fetchError);
//         return res.status(400).json({ success: false, message: 'Invalid email or password' });
//     }

//     // Compare hashed password
//     const passwordMatches = await bcrypt.compare(password, user.password);
//     console.log('Password matches:', passwordMatches);

//     if (passwordMatches) {
//         console.log('Login successful:', user);
//         res.json({ success: true, message: 'Login successful', user });
//     } else {
//         console.error('Invalid email or password');
//         res.status(400).json({ success: false, message: 'Invalid email or password' });
//     }
// });

// // **New Post Route**
// app.post('/submit-post', async (req, res) => {
//     console.log('Blog post submission received:', req.body);

//     const { message, blog_title } = req.body;  // Get form data
//     const user = JSON.parse(req.headers['x-user']); // Extract logged-in user from request header

//     if (!user || !user.id || !user.name) {
//         return res.status(400).json({ success: false, message: "User not logged in" });
//     }

//     try {
//         const { data, error } = await supabase
//             .from('blog_table')  // Replace with your table name
//             .insert([
//                 {
//                     blog_title,
//                     message,
//                     author: user.name,
//                     employee_id: user.id,
//                     published_date: new Date().toISOString(), // Server-generated timestamp
//                 }
//             ]);

//         if (error) {
//             console.error("Supabase Insert Error:", error);
//             return res.status(500).json({ success: false, message: "Failed to save blog post" });
//         }

//         console.log("Blog post saved:", data);
//         res.json({ success: true, message: "Blog post submitted successfully" });

//     } catch (error) {
//         console.error("Unexpected Error:", error);
//         res.status(500).json({ success: false, message: "Server error" });
//     }
// });

// // **Catch-all Route: Redirect to Eleventy Frontend**
// app.get('*', (req, res) => {
//     res.sendFile(path.join(__dirname, '_site', 'index.html'));
// });

// // **Start Server**
// app.listen(port, () => {
//     console.log(`Server is running on http://localhost:${port}`);
// });
