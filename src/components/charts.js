import * as Plot from "npm:@observablehq/plot";
import * as d3 from "npm:d3";
import * as htmlToImage from 'npm:html-to-image';
import download from "npm:downloadjs";

const mathLevels = [
  { x1: 2000, x2: 2022, y1: 358, y2: 420, level: "Level 1a" },
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

function lower(str) {
  return str.replace(/\b[A-Z][a-z]*\b/g, word => word.toLowerCase())
};

function short(label) {
  return label.replace(/\s\([\d\w\s]+\)$/, "")
};

function cumdiff(numbers) {
  return numbers.reduce((acc, curr) => acc - curr)
};

export function the(country) {
  return `${["European Union (28 countries)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${short(country)}`
};

export function choose(str, test) {
  return test == "Math" ? str.replace(/(\sand\sReading)/, "") : str.replace(/(Math\sand\s)/, "")
};

export function caption() {
  const span = document.createElement("span");
  span.className = "caption";
  span.innerHTML = `
    <span>© Programme for International Student Assessment (PISA), OECD</span><span><a href="https://webfs.oecd.org/pisa2022/index.html" target="_blank">Get the data</a></span>
  `;
  return span
};

export function filterSe(data, se) {
  return se
    ? data[0]
    : data[0].filter(d => !d.metric.includes("standard error"));
};

export function wrapsvg(svgnode, filename = 'chart.svg') {
  const root = document.createElement('div');
  root.className = "download-button-wrapper";
  root.style.cssText = "display: inline-block; position: relative;";

  root.innerHTML = `
    <a class="download" download="${filename}" href="#" style="position: absolute; top: 0; right: 0; width: 20px; height: 20px;">
      <svg width="20px" height="20px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <g>
          <path d="M12.5 4V17M12.5 17L7 12.2105M12.5 17L18 12.2105" stroke="var(--theme-foreground-alt)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M6 21H19" stroke="var(--theme-foreground-muted)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </g>
      </svg>
    </a>
  `;

  root.prepend(svgnode);

  const downloadButton = root.querySelector('a.download');

  downloadButton.onclick = function (e) {
      e.preventDefault(); 

      htmlToImage.toPng(svgnode)
        .then(function (url) {
          download(url, filename);
        });
    };

  return root;
};

export function plotBar({ width, mdata, year, test }) {
  let data = mdata.data.filter(d => d.value > 0 && !d.metric.includes('standard error'));
  let scoreMin = d3.min(data, d => d.value) - 10;
  let scoreMax = d3.max(data, d => d.value) + 10;
  let ds = data.filter(d => d.year == year);
  let mn = ds.filter(d => d.metric == "Mean");
  let plot = Plot.plot({
    width,
    height: 700,
    marginLeft: 85,
    marginTop: 15,
    marginBottom: 10,
    title: `${mdata.meta.label} by Education System: ${year}`,
    subtitle: "Average, 10th percentile, and 90th percentile scores of 15-year-old students on the PISA math and reading literacy scale. The difference between scores for each country is shown in a muted color.",
    caption: caption(),
    className: "averages",
    x: {axis: "top", domain: [scoreMin, scoreMax], line: true, label: "Score", insetRight: 50},
    y: {axis: null, domain: test == "Math" ? ["Math Score", "Reading Score"] : ["Reading Score", "Math Score"]},
    fy: {
      padding: 0,
      label: null,
      tickFormat: s => short(s),
      domain: d3.groupSort(
        mn.filter(d => d.concept.startsWith(test)),
        (D) => d3.mean(D, d => d.value),
        d => d.area
      ).reverse()
    },
    color: {
      domain: ["Math Score", "Reading Score", "currentColor"],
      range: ["#4269d0", "#efb118", "currentColor"]
    },
    symbol: {
      domain: ["10th Percentile", "Mean", "90th Percentile"],
      range: ["circle", "diamond", "cross"],
      legend: true,
      fill: "currentColor",
      className: "symbols"
    },
    marks: [
      Plot.barX(mn, {
        x1: scoreMin,
        x2: "value",
        y: "concept",
        fy: "area",
        fill: "concept"
      }),
      Plot.barX(mn, {
        x1: d => d3.min(mn.filter(e => e.area == d.area && e.year == d.year), e => e.value),
        x2: "value",
        y: "concept",
        fy: "area",
        fill: "var(--theme-background)",
        fillOpacity: 0.4
      }),
      Plot.barX(ds, Plot.pointerY({
        x1: 0,
        x2: 1000,
        fy: "area",
        fill: "currentColor",
        fillOpacity: 0.1,
        clip: true
      })),
      Plot.gridX({ strokeOpacity: 0.2 }),
      Plot.dot(ds, {
        x: "value",
        y: "concept",
        fy: "area",
        symbol: "metric",
        r: 3,
        fill: d => d.metric == "90th Percentile" ? d.concept : "currentColor"
      }),
      Plot.text(mn, Plot.pointerY({
        x1: 240,
        x2: 800,
        dx: -4,
        fy: "area",
        frameAnchor: "right",
        textAnchor: "end",
        fill: "currentColor",
        text: (d, i, data) => {
          let math = data.find(e => e.concept == "Math Score" && e.area == d.area);
          let reading = data.find(e => e.concept == "Reading Score" && e.area == d.area);
          return test == "Math"
            ? `Math: ${Math.round(math.value)}\nReading: ${Math.round(reading.value)}`
            : `Reading: ${Math.round(reading.value)}\nMath: ${Math.round(math.value)}`;
        }
      }))
    ]
  });

  d3
  .select(plot)
  .selectAll("text")
  .filter(function() { return this.textContent.includes("European Union"); })
  .style("font-weight", "bold");

  d3.select(plot)
    .select("h2")
    .html(function() {
      return this.textContent
        .replace(/\b(math)\b/gi, '<span class="underlined u-blue">$1</span>')
        .replace(/\b(reading)\b/gi, '<span class="underlined u-yellow">$1</span>');
    });

  return plot
};

export function plotTrend({width, mdata, test}) {
  let data = mdata.data.filter(d => d.value > 0 && d.metric == "Mean");
  let scoreMin = d3.min(data, d => d.value) - 10;
  let scoreMax = d3.max(data, d => d.value) + 10;
  let ds = data.filter(d => d.concept.startsWith(test));
  let countries = mdata.meta.dimensions.area.categories.label;
  let colorScale = d3.scaleOrdinal(countries, color);
  let plot = Plot.plot({
    width,
    title: `Trend in ${test} Skills in the European Union (28 countries): 2000-2022`,
    subtitle:`Average scores on the PISA ${test.toLowerCase()} literacy scale over the survey period, by education system.`,
    caption: caption(),
    x: { type: "linear", grid: true , label: mdata.meta.dimensions.year.label, tickFormat: "" },
    y: { axis: "both", domain: [scoreMin, scoreMax], label: `Average ${test} Score`, inset: 10 },
    color: { domain: countries, range: color },
    marks: [
      Plot.frame(),
      Plot.line(ds, { x: "year", y: "value", stroke: "area", curve: "step" }),
      Plot.dot(ds, { x: "year", y: "value", symbol: "diamond2", stroke: "area" }),
      Plot.text(ds, { x: "year", y: "value", text: d => Math.round(d.value), fill: "area", dy: -10 }),
      Plot.text(ds, { fill: "area", text: "area", fontSize: 13, textAnchor: "end", frameAnchor: "top-right", dx: -15, dy: 15 })
    ]
  });

  let svg = d3.select(plot);
  let mouseInside = false;

function showEU() {
    svg.selectAll("g[aria-label='line'] path")
      .attr("opacity", function () {
        return d3.select(this).attr("stroke") === "currentColor" ? 1 : 0.15;
      })
      .attr("filter", function () {
        return d3.select(this).attr("stroke") === "currentColor" ? "grayscale(0)" : "grayscale(1)";
      });

    svg.selectAll("g[aria-label='dot'] path")
      .attr("opacity", function () {
        return d3.select(this).attr("stroke") === "currentColor" ? 1 : 0;
      });

    svg.selectAll("text[fill]")
      .attr("opacity", function () {
        return d3.select(this).attr("fill") === "currentColor" ? 1 : 0;
      });
  }

  function hideEU() {
    if (!mouseInside) {
      mouseInside = true;
      svg.selectAll(`g[aria-label='line'] path[stroke='currentColor']`).attr("opacity", 0.15);
      svg.selectAll(`g[aria-label='line'] path[stroke='currentColor']`).attr("filter", "grayscale(1)");
      svg.selectAll(`g[aria-label='dot'] path[stroke='currentColor']`).attr("opacity", 0);
      svg.selectAll(`text[fill='currentColor']`).attr("opacity", 0);
    }
  }

  showEU();

  svg.selectAll("g[aria-label='line'] path")
    .on("pointerenter", function (event) {
      hideEU();

      let active = d3.select(this).attr("stroke");

      svg.selectAll("g[aria-label='line'] path").attr("opacity", 0.15);
      svg.selectAll("g[aria-label='line'] path").attr("filter", "grayscale(1)");
      svg.selectAll("g[aria-label='dot'] path").attr("opacity", 0);
      svg.selectAll("text[fill]").attr("opacity", 0);

      svg.selectAll(`g[aria-label='line'] path[stroke='${active}'],
                     g[aria-label='dot'] path[stroke='${active}'], 
                     text[fill='${active}']`)
        .attr("opacity", 1);

      svg.selectAll(`g[aria-label='line'] path[stroke='${active}']`).attr("filter", "grayscale(0)");
    });

  svg.on("pointerleave", function () {
    mouseInside = false;
    showEU();
  });

  return plot;
};

export function plotLevels({ width, mdata, test, group, country }) {
  let data = mdata.data.filter(d => d.value > 0 && !d.metric.includes("standard error"));
  let scoreMin = d3.min(data, d => d.value) - 10;
  let scoreMax = d3.max(data, d => d.value) + 10;
  let years = mdata.meta.dimensions.year.categories.label;
  let yearMin = d3.min(years);
  let yearMax = d3.max(years);
  let ds = data.filter(d => d.area == country && d.concept.startsWith(test));
  let se = mdata.data.filter(d => d.area == country && d.concept.startsWith(test));
  let levels = test == "Math" ? mathLevels : readLevels;
  let labels = mdata.meta.dimensions[group].categories.label;
  let colors = d3.schemeObservable10.slice(0, 6);

  const createTooltip = (label) =>
    Plot.tip(
      ds.filter(d => d[group] === label),
      Plot.pointerX({
        x: "year",
        y: "value",
        fill: "var(--theme-background-alt)",
        title: d => Math.round(d.value),
        maxRadius: 20
      })
    );

  // Append tooltips in reverse order for readability
  const tooltips = [...labels].reverse().map(createTooltip);

  return Plot.plot({
    width,
    title: `${choose(mdata.meta.label, test)} in ${the(country)}: ${yearMin}–${yearMax}`,
    subtitle: `Average scores on the PISA ${test.toLowerCase()} literacy scale, by ${group == "escs" ? "quartiles of the" : ""} ${lower(mdata.meta.dimensions[group].label)}.`,
    caption: caption(),
    x: { type: "linear", line: true, domain: [yearMin, yearMax], label: mdata.meta.dimensions.year.label, tickFormat: "", insetRight: 50 },
    y: { line: true, domain: [scoreMin, scoreMax], label: `Average ${test} Score` },
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
      Plot.lineY(data, {
        filter: d => d.area == "European Union (28 countries)" && d.concept.startsWith(test) && !d.metric.includes("standard error"),
        x: "year",
        y: "value",
        stroke: group,
        strokeOpacity: 0.2,
        imageFilter: "grayscale(0.7)",
      }),
      Plot.ruleX(ds, Plot.pointerX({
        x: "year",
        y: "value",
        strokeDasharray: [2, 2],
        clip: true,
        maxRadius: 20
      })),
      Plot.link(se, Plot.groupX({ y1: n => cumdiff(n), y2: "sum"}, {
        x: "year",
        y: "value",
        stroke: group,
        strokeOpacity: 0.3,
        clip: true,
      })),
      Plot.lineY(ds, {
        x: "year",
        y: "value",
        z: group,
        stroke: group,
        marker: true
      }),
      Plot.text(ds, Plot.selectLast({
        x: "year",
        y: "value",
        z: group,
        text: group,
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

export function plotFreq({ width, mdata, groupdata, year, test, country }) {
  let data = mdata.data.filter(d => d.year == year && d.area == country && d.concept.startsWith(test) && !d.metric.includes("standard error"));
  let ds2 = groupdata.filter(d => d.year == year && d.area == country && !d.metric.includes("standard error"));
  let group = Object.keys(mdata.meta.dimensions)[3];

  let tot = ds2.reduce((acc, curr) => {
    acc[curr[group]] = curr.value;
    return acc;
  }, {});

  let ds = data.map(item => ({
        ...item,
        value: ((item.value * tot[item[group]]) / 100) ?? 0
    }));

  /* let label = mdata.meta.dimensions[group].label; */
  let label = group == "escs" ? "Socio-Economic Status" : "Parents' Education";
  let levels = mdata.meta.dimensions.level.categories.label;

  return Plot.plot({
    width,
    height: 500,
    marginLeft: 60,
    marginBottom: 50,
    title: `${choose(mdata.meta.label, test)} in ${the(country)}: ${year}`,
    subtitle: `Percentage of students at each PISA ${test.toLowerCase()} proficiency level across ${group == "escs" ? "ESCS quartiles" : "aggregated ISCED levels"}, with dot size representing category frequency.`,
    caption: caption(),
    grid: true,
    x: { label: label, domain: mdata.meta.dimensions[group].categories.label },
    y: { label: `${test} Proficiency`, domain: levels, reverse: true },
    r: {range: [0.5, 20]},
    color: {
      domain: [...levels.slice(1), levels[0]]
    },
    marks: [
      Plot.dot(ds, {
        x: group,
        y: "level",
        fill: "level",
        r: "value",
        stroke: "currentColor",
        strokeWidth: 0.5,
        channels: {
          test: {
            value: "level",
            label: test,
            scale: "color"
          },
          group: {
            value: group,
            label: group.toUpperCase()
          },
          value: {
            value: "value",
            label: "Frequency (%)"
          },
        },
        tip: {
          format: {
            test: true,
            group: true,
            value: ".2r",
            x: false,
            y: false,
            r: false,
            fill: false
          }
        }
      }),
      Plot.axisY({lineWidth: 5}),
      Plot.axisX({lineWidth: 5}),
    ]
  });
};

