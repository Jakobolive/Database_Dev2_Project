const dotenv = require('dotenv');
dotenv.config(); // Ensure .env is loaded early

const supabase = require('./_data/supabase'); // Import once

module.exports = function(eleventyConfig) {
    // Passthrough Bootstrap CSS and JS
    eleventyConfig.addPassthroughCopy({
        "node_modules/bootstrap/dist/css/bootstrap.min.css": "css/bootstrap.min.css",
        "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js": "js/bootstrap.bundle.min.js"
    });

    // Make Bootstrap and custom styles accessible
    eleventyConfig.addPassthroughCopy("css/bootstrap.min.css");
    eleventyConfig.addPassthroughCopy("_includes/styles.css");

    // Ensure the css/ directory is passed through as well
    eleventyConfig.addPassthroughCopy("css");

    // Add environment variables globally
    eleventyConfig.addGlobalData("SUPABASE_URL", process.env.SUPABASE_URL);
    eleventyConfig.addGlobalData("SUPABASE_ANON_KEY", process.env.SUPABASE_ANON_KEY);

    // Collections for posts and employees
    eleventyConfig.addCollection('posts', async function() {
        return await require('./_data/posts.js')();
    });

    eleventyConfig.addCollection('employees', async function() {
        return await require('./_data/employees.js')();
    });

    // Directories for input and output
    return {
        dir: {
            input: ".",
            includes: "_includes",
            data: "_data",
            output: "_site"
        }
    };
};

