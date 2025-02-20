import { useEffect, useState } from "react";
import "./App.css";
import axios from "axios";

function App() {
  const [articles, setArticles] = useState([]);

  useEffect(() => {
    fetchArticles();
  }, []);

  const fetchArticles = async () => {
    try {
      const res = await axios.get("http://localhost:3000/scrape");
      setArticles(res.data.articles);
    } catch (error) {
      console.error("Error fetching data", error);
    }
  };

  console.log(articles);
  return (
    <>
      <h1>SCRAPED DATA</h1>
      <div className="articles-container">
        {articles.length !== 0 ? (
          articles.map((article, index) => (
            <Article article={article} key={index} />
          ))
        ) : (
          <div className="loading">LOADING</div>
        )}
      </div>
      <button onClick={fetchArticles}>Load More</button>
    </>
  );
}

export default App;

function Article({ article }) {
  return (
    <div className="article-card">
      <h1>Title: {article.title}</h1>
      <a href={article.url} target="_blank" rel="noopener noreferrer">
        Read Article
      </a>
      <h1>Date: {article.date}</h1>
    </div>
  );
}
