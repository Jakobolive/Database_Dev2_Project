const dotenv = require('dotenv');

// Load the environment variables from the .env file
dotenv.config();

module.exports = function(eleventyConfig) {
    // Copy Bootstrap CSS and JS files to the output folder
    eleventyConfig.addPassthroughCopy({
        "node_modules/bootstrap/dist/css/bootstrap.min.css": "css/bootstrap.min.css",
        "node_modules/bootstrap/dist/js/bootstrap.bundle.min.js": "js/bootstrap.bundle.min.js"
    });

    eleventyConfig.addGlobalData("SUPABASE_URL", process.env.SUPABASE_URL);
    eleventyConfig.addGlobalData("SUPABASE_ANON_KEY", process.env.SUPABASE_ANON_KEY);

    eleventyConfig.addCollection('posts', async function() {
        const postsData = await require('./_data/posts.js')();
        return postsData;
    });

    return {
        dir: {
            input: "11ty_blog",
            includes: "_includes",
            data: "_data",
            output: "_site"
        }
    };
};
