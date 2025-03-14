# 📝 Blog Website with Supabase Authentication

## 📌 Description
This is a simple blog website that allows users to:
✅ View blog posts on the **index page** 📄  
✅ Learn more on the **about page** ℹ️  
✅ **Login & authentication** via Supabase 🔐  
✅ **Create new blog posts** ✍️  

The project is built using **Eleventy (11ty)** for static site generation, **Nunjucks (njk)** templates for rendering, and **Supabase** as the backend for authentication and storing blog posts.  

---

## 🚀 Live Demo
🔗 **[View the Website on Vercel](https://your-vercel-url.vercel.app/)**  

---

## 📂 Features
- **Homepage (`index.njk`)** → Displays all blog posts.  
- **About Page (`about.njk`)** → Basic information about the site.  
- **Login Page (`login.njk`)** → Users log in with email & password (via Supabase).  
- **Create Post (`new-post.njk`)** → Logged-in users can add new blog posts.  

---

## 🛠 Tech Stack
- **Frontend:** Eleventy (11ty), Nunjucks, HTML, CSS, Bootstrap  
- **Backend:** Supabase (PostgreSQL, Auth, API)  
- **Hosting:** Vercel  

---

## 📥 Installation & Setup  

### 1️⃣ Clone the Repository  
```sh
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 2️⃣ Install Dependencies  
```sh
npm install
```

### 3️⃣ Create a `.env` File  
Inside your project folder, create a `.env` file and add your Supabase credentials:  

```sh
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### 4️⃣ Run Locally  
Start the development server:  
```sh
npm run dev
```
The project will be available at:  
🔗 **http://localhost:3000**

---

## 📤 Deployment on Vercel  
1. Push the project to **GitHub**.  
2. Go to **Vercel Dashboard** → New Project.  
3. Import your repository and set the environment variables (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).  
4. Click **Deploy**.  
5. Your site will be live at `https://your-project.vercel.app` 🎉  

---

## 📝 How to Use  
1. **Login** using your email & password (stored in Supabase).  
2. **Create new blog posts** (only logged-in users).  
3. View **all blog posts** on the homepage.  
4. **Logout** anytime.  

---

## 🐞 Troubleshooting & Common Issues  
🔹 **Login not working?** Ensure Supabase credentials are correct in `.env`.  
🔹 **"Internal Server Error (500)"?** Check if Supabase tables are set up properly.  
🔹 **Styling missing?** Verify that Bootstrap is included in your Eleventy config.  

---

## 📜 License  
This project is licensed under the **MIT License**.  
