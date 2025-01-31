import * as Plot from "npm:@observablehq/plot";
import * as d3 from "npm:d3";

const maps = {
  escs: {
    "Lower ESCS quartile": "quart1_escs",
    "Second ESCS quartile": "quart2_escs",
    "Third ESCS quartile": "quart3_escs",
    "Upper ESCS quartile": "quart4_escs"
  },
  isced: {
    "Low education parents": "low_ed_parent",
    "Medium education par.": "medium_ed_parent",
    "High education parents": "high_ed_parent"
  },
  books: {
    "0–10 books": "books_0_10",
    "11–25 books": "books_11_25",
    "26–100 books": "books_26_100",
    "101–200 books": "books_101_200",
    "201–500 books": "books_201_500",
    "500+ books": "books_500_more",
  },
  cultural: {
    "No classical literature": "classics_no",
    "No artworks": "artworks_no",
    "Some artworks": "artworks_yes",
    "Some classical literature": "classics_yes",
  },
  computer: {
    "Never": "computer_never",
    "Few times a year": "computer_few_times_year",
    "Once a month": "computer_once_month",
    "Few times a week": "computer_few_times_week",
    "Every day": "computer_every_day",
    "Several times a day": "computer_several_times_day",
    "Not available": "computer_not_available"
  },
  lonely: {
    "Strongly agree": "lonely_strongly_agree",
    "Agree": "lonely_agree",
    "Disagree": "lonely_disagree",
    "Strongly disagree": "lonely_strongly_disagree"
  },
};

const mathLevels = [
  { x1: 2000, x2: 2022, y1: 358, y2: 420, level: "Level 1" },
  { x1: 2000, x2: 2022, y1: 420, y2: 482, level: "Level 2" },
  { x1: 2000, x2: 2022, y1: 482, y2: 545, level: "Level 3" },
  { x1: 2000, x2: 2022, y1: 545, y2: 607, level: "Level 4" },
  { x1: 2000, x2: 2022, y1: 607, y2: 669, level: "Level 5" },
  { x1: 2000, x2: 2022, y1: 669, y2: 1000, level: "Level 6" }
];

const readLevels = [
  { x1: 2000, x2: 2022, y1: 335, y2: 407, level: "Level 1a" },
  { x1: 2000, x2: 2022, y1: 407, y2: 480, level: "Level 2" },
  { x1: 2000, x2: 2022, y1: 480, y2: 553, level: "Level 3" },
  { x1: 2000, x2: 2022, y1: 553, y2: 626, level: "Level 4" },
  { x1: 2000, x2: 2022, y1: 626, y2: 698, level: "Level 5" },
  { x1: 2000, x2: 2022, y1: 698, y2: 1000, level: "Level 6" }
];

const color = [
  "#0F52BA", "#4682B4", "#A7C7E7", "#9FE2BF", "#40B5AD", "#097969",
  "#0EA37D", "#438F4C", "#93C572", "#8CA348", "#CCCA3C", "#EFB118",
  "#E2C48A", "#FF8F0B", "#CC7722", "#C19A6B", "#6F4E37", "#A0522D",
  "#A42A04", "#722F37", "#A85A69", "#FAA0A0", "#FCACCC", "#D47BA1",
  "#9F5691", "#A57EDA", "#735DAD", "currentColor"
];

function caption() {
  const span = document.createElement("span");
  span.className = "caption";
  span.innerHTML = `
    <span>© Programme for International Student Assessment (PISA), OECD</span><span><a href="https://webfs.oecd.org/pisa2022/index.html" target="_blank">Get the data</a></span>
  `;
  return span;
}

export function serialize (svg) {
  const xmlns = "http://www.w3.org/2000/xmlns/";
  const xlinkns = "http://www.w3.org/1999/xlink";
  const svgns = "http://www.w3.org/2000/svg";

  svg = svg.cloneNode(true);
  svg.setAttributeNS(xmlns, "xmlns", svgns);
  svg.setAttributeNS(xmlns, "xmlns:xlink", xlinkns);
  const serializer = new window.XMLSerializer;
  const string = serializer.serializeToString(svg);
  return new Blob([string], {type: "image/svg+xml"});
};

export function reshape(data, group) {
  const categories = maps[group];
  if (!categories) {
    throw new Error(`Unknown parameter: ${group}`);
  }

  return data.flatMap(d => 
    Object.entries(categories).flatMap(([category, suffix]) => [
      {
        year: d.year,
        country: d.country,
        category,
        test: "Math",
        mean_score: d[`mean_math_${suffix}`],
        se: d[`se_mean_math_${suffix}`],
      },
      {
        year: d.year,
        country: d.country,
        category,
        test: "Reading",
        mean_score: d[`mean_read_${suffix}`],
        se: d[`se_mean_read_${suffix}`],
      },
    ])
  );
};

export function plotLevels({
  width,
  country,
  data,
  test,
  group,
  xDomain = [2000, 2022],
  title = "Proficiency Levels",
  subtitle = ""
}) {
  const countryData = data.get(country) || [];
  const plotData = countryData.filter(d => d.test === test && !isNaN(d.mean_score));

  const scoreRange = Array.from(data.values())
    .flat()
    .filter(d => !isNaN(d.mean_score))
    .map(d => d.mean_score);

  const minY = d3.min(scoreRange);
  const maxY = d3.max(scoreRange);

  const levels = test === "Math" ? mathLevels : readLevels;
  const labels = Object.keys(maps[group])
  const colors = d3.schemeObservable10.slice(0, 6);

  const createTooltip = (label) =>
    Plot.tip(
      plotData.filter(d => d.category === label),
      Plot.pointerX({
        x: "year",
        y: "mean_score",
        fill: "var(--theme-background-alt)",
        title: d => Math.round(d.mean_score),
        maxRadius: 20
      })
    );

  // Append tooltips in reverse order for readability
  const tooltips = [...labels].reverse().map(createTooltip);

  return Plot.plot({
    width,
    title,
    subtitle,
    caption: caption(),
    x: { line: true, domain: xDomain, label: "Year", tickFormat: d => `${d}`, insetRight: 95 },
    y: { line: true, domain: [minY, maxY], label: `Average ${test} Score` },
    color: { type: "categorical", domain: [...levels.map(d => d.level), ...labels], range: colors },
    marks: [
      Plot.rectY(levels, {
        x1: "x1",
        x2: "x2",
        y1: "y1",
        y2: "y2",
        fill: "level",
        fillOpacity: 0.07,
        clip: true,
        imageFilter: "blur(5px)",
      }),
      Plot.text(levels, {
        x: d => d.x1 + 0.5,
        y: d => (d.y1 + d.y2) / 2,
        text: "level",
        textAnchor: "start",
        fill: "currentColor",
        fillOpacity: 0.4,
        clip: true,
      }),
      Plot.lineY(data.get("European Union (28)").filter(d => d.test === test && !isNaN(d.mean_score)), {
        x: "year",
        y: "mean_score",
        stroke: "category",
        strokeOpacity: 0.2,
        imageFilter: "grayscale(0.7)",
      }),
      Plot.ruleX(plotData, Plot.pointerX({
        x: "year",
        y: "mean_score",
        strokeDasharray: [2, 2],
        clip: true,
        maxRadius: 20
      })),
      Plot.link(plotData, {
        x: "year",
        y1: d => d.mean_score - d.se,
        y2: d => d.mean_score + d.se,
        stroke: "category",
        strokeOpacity: 0.3,
        clip: true,
      }),
      Plot.lineY(plotData, {
        x: "year",
        y: "mean_score",
        z: "category",
        stroke: "category",
        marker: true
      }),
      Plot.text(plotData, Plot.selectLast({
        x: "year",
        y: "mean_score",
        z: "category",
        text: "category",
        textAnchor: "start",
        dx: 7,
        fill: "currentColor",
        stroke: "var(--theme-background-alt)",
        strokeWidth: 5
      })),
      ...tooltips,
    ],
  });
};

export function plotTrend({width, data, test, countries}) {
  let orderedCountries = countries.filter(c => c !== "European Union (28)").concat("European Union (28)");
  let colorScale = d3.scaleOrdinal(orderedCountries, color);
  let y = test == "Math" ? "mean_math" : "mean_read";

  let plot = Plot.plot({
    width,
    title: `Trends in ${test.toLowerCase()} skills in the European Union (28): 2000-2022`,
    subtitle:`Average scores on the PISA ${test.toLowerCase()} literacy scale over the survey period, by education system.`,
    caption: caption(),
    x: { grid: true, domain: [2000, 2022], label: "Year", tickFormat: d => `${d}` },
    y: { axis: "both", domain: [390, 570], label: `Average ${test} Score`, inset: 10 },
    color: { domain: orderedCountries, range: color },
    marks: [
      Plot.frame(),
      Plot.line(data, { x: "year", y: y, stroke: "country", curve: "step" }),
      Plot.dot(data, { x: "year", y: y, symbol: "diamond2", stroke: "country" }),
      Plot.text(data, { x: "year", y: y, text: d => Math.round(d[y]), fill: "country", dy: -10 }),
      Plot.text(data, { fill: "country", text: "country", fontSize: 13, textAnchor: "end", frameAnchor: "top-right", dx: -15, dy: 15 })
    ]
  });

  const svg = d3.select(plot);
  let mouseInside = false;

function showEU() {
    svg.selectAll("g[aria-label='line'] path")
      .attr("opacity", function () {
        return d3.select(this).attr("stroke") === colorScale("European Union (28)") ? 1 : 0.15;
      })
      .attr("filter", function () {
        return d3.select(this).attr("stroke") === colorScale("European Union (28)") ? "grayscale(0)" : "grayscale(1)";
      });

    svg.selectAll("g[aria-label='dot'] path")
      .attr("opacity", function () {
        return d3.select(this).attr("stroke") === colorScale("European Union (28)") ? 1 : 0;
      });

    svg.selectAll("text[fill]")
      .attr("opacity", function () {
        return d3.select(this).attr("fill") === colorScale("European Union (28)") ? 1 : 0;
      });
  }

  function hideEU() {
    if (!mouseInside) {
      mouseInside = true;
      svg.selectAll(`g[aria-label='line'] path[stroke='${colorScale("European Union (28)")}']`).attr("opacity", 0.15);
      svg.selectAll(`g[aria-label='line'] path[stroke='${colorScale("European Union (28)")}']`).attr("filter", "grayscale(1)");
      svg.selectAll(`g[aria-label='dot'] path[stroke='${colorScale("European Union (28)")}']`).attr("opacity", 0);
      svg.selectAll(`text[fill='${colorScale("European Union (28)")}']`).attr("opacity", 0);
    }
  }

  showEU();

  svg.selectAll("g[aria-label='line'] path")
    .on("pointerenter", function (event) {
      hideEU();

      const hoveredColor = d3.select(this).attr("stroke");

      svg.selectAll("g[aria-label='line'] path").attr("opacity", 0.15);
      svg.selectAll("g[aria-label='line'] path").attr("filter", "grayscale(1)");
      svg.selectAll("g[aria-label='dot'] path").attr("opacity", 0);
      svg.selectAll("text[fill]").attr("opacity", 0);

      svg.selectAll(`g[aria-label='line'] path[stroke='${hoveredColor}'],
                     g[aria-label='dot'] path[stroke='${hoveredColor}'], 
                     text[fill='${hoveredColor}']`)
        .attr("opacity", 1);

      svg.selectAll(`g[aria-label='line'] path[stroke='${hoveredColor}']`).attr("filter", "grayscale(0)");
    });

  svg.on("pointerleave", function () {
    mouseInside = false;
    showEU();
  });

  return plot;
};