const searchInput = document.getElementById("search-input");
const chapterFilter = document.getElementById("chapter-filter");
const cards = Array.from(document.querySelectorAll(".lecture-card"));
const resultCount = document.getElementById("result-count");

function normalize(text) {
  return (text || "").toLowerCase().trim();
}

function applyFilters() {
  const q = normalize(searchInput.value);
  const chapter = normalize(chapterFilter.value);
  let visible = 0;

  for (const card of cards) {
    const cardText = normalize(card.innerText);
    const kws = normalize(card.dataset.keywords);
    const cardChapter = normalize(card.dataset.chapter);

    const matchesSearch = q === "" || cardText.includes(q) || kws.includes(q);
    const matchesChapter = chapter === "" || cardChapter === chapter;
    const show = matchesSearch && matchesChapter;

    card.style.display = show ? "" : "none";
    if (show) visible += 1;
  }

  resultCount.textContent = `共 ${visible} 讲`;
}

searchInput.addEventListener("input", applyFilters);
chapterFilter.addEventListener("change", applyFilters);
