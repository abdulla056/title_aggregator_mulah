import express from "express";
import puppeteer from "puppeteer";
import cors from "cors";

const app = express();
const PORT = 3000;

app.use(cors());

let browser, page;

// Initialize Puppeteer when the server starts
const initBrowser = async () => {
  browser = await puppeteer.launch({ headless: "new" });
  page = await browser.newPage();
  const url = "https://sea.mashable.com/article";
  await page.goto(url, { waitUntil: "domcontentloaded" });
};

app.get("/scrape", async (req, res) => {
  try {
    if (!browser || !page) {
      await initBrowser();
    }

    // Click "Show More" if the button exists
    const loadMoreButton = await page.$("#showmore");
    if (loadMoreButton) {
      await loadMoreButton.click();
      await page.waitForSelector(".ARTICLE", { timeout: 5000 }).catch(() => {});
      await new Promise((r) => setTimeout(r, 2000));
    }

    // Scrape articles after clicking
    const allArticles = await page.evaluate(() => {
      const articles = document.querySelectorAll(".ARTICLE");
      return Array.from(articles).map((article) => {
        const url = article.querySelector("a")?.href || "#";
        const title = article.querySelector(".caption")?.innerText || "No title";
        const date = article.querySelector("time")?.innerText || "No Date";
        return { title, url, date };
      });
    });

    res.json({ articles: allArticles });
  } catch (error) {
    console.error("Scraping failed:", error);
    res.status(500).json({ message: "Error scraping data" });
  }
});

// Graceful shutdown to close Puppeteer
process.on("exit", async () => {
  if (browser) await browser.close();
});

// Start the Express server
app.listen(PORT, async () => {
  console.log(`Server running at http://localhost:${PORT}`);
  await initBrowser(); // Start Puppeteer when server starts
});
