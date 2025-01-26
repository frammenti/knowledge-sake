---
toc: false
---

```js
// Load and join the files
const data = Promise.all([
  FileAttachment("source/D1.1_PISA_scores_vs_escs_00_09.csv").csv({typed: true}),
  FileAttachment("source/D1.2_PISA_scores_vs_escs_12_22.csv").csv({typed: true})
])
  .then(([data1, data2]) => [...data1, ...data2]);
```
```js
// Compute min and max for consistent axes ranges
const yMin = d3.min(data, d => d["ESCS Index"]);
const yMax = d3.max(data, d => d["ESCS Index"]);

const xMin = -100;
const xMax = 1100;
```
```js
// Consistent coloring for each country
const color = [
"#0F52BA", "#4682B4", "#A7C7E7", "#9FE2BF", "#40B5AD", "#097969",
"#0EA37D", "#438F4C", "#93C572", "#8CA348", "#CCCA3C", "#FAD92B",
"#F5DEB3", "#FF8F0B", "#CC7722", "#C19A6B", "#6F4E37", "#A0522D",
"#A42A04", "#722F37", "#A85A69", "#FAA0A0", "#FCACCC", "#D47BA1",
"#9F5691", "#A57EDA", "#735DAD"
]

const countries = Array.from(new Set(data.map(d => d.Country))).sort();
const colorScale = new Map(countries.map((country, i) => [country, color[i]]));
```
```js
const checkboxes = selectCountry.querySelectorAll("input[name='input']");
```
```js
// Colored country legend
requestAnimationFrame(() => {
  const range = selectYear.querySelector("input[type='range']");
  range.setAttribute("list", "pisa-years");

  // Create and append the datalist
  const dataList = document.createElement("datalist");
  dataList.id = "pisa-years";
  dataList.innerHTML = `
    <option value="0" label="2000"></option>
    <option value="1" label="2003"></option>
    <option value="2" label="2006"></option>
    <option value="3" label="2009"></option>
    <option value="4" label="2012"></option>
    <option value="5" label="2015"></option>
    <option value="6" label="2018"></option>
    <option value="7" label="2022"></option>
  `;
  range.insertAdjacentElement("afterend", dataList);

  checkboxes.forEach((checkbox, index) => {
    checkbox.style.setProperty("--checkbox-color", color[index]);
    checkbox.addEventListener("change", updateCheckAllState);
  });
});
```
```js
// Check/uncheck all checkboxes
const checkAll = document.getElementById("check-all");

// Update check-all state
function updateCheckAllState() {
  const checkedCount = Array.from(checkboxes).filter(checkbox => checkbox.checked).length;

  if (checkedCount === checkboxes.length) {
    checkAll.indeterminate = false;
    checkAll.checked = true;
  } else if (checkedCount === 0) {
    checkAll.indeterminate = false;
    checkAll.checked = false;
  } else {
    checkAll.indeterminate = true;
  }
}

checkAll.addEventListener("change", () => {
  const checkAllState = checkAll.checked;
  checkboxes.forEach(checkbox => {
    checkbox.checked = checkAllState;
  });
  selectCountry.dispatchEvent(new CustomEvent("input"));
});
```
```js
// Input score selection
const selectScore = Inputs.radio(["Math", "Reading"], {value: "Math Score", valueof: x => x + " Score", label: "Score:"});
const facet = Generators.input(selectScore);
```
```js
// Input year selection
const years = Array.from(new Set(data.map(d => d.Year))).sort();
const selectYear = Inputs.range([0, years.length - 1], {
  step: 1,
  value: 0,
  format: x => years[x],
  width: "inherit",
  label: "Year:"
});
const yearIndex = Generators.input(selectYear);
```
```js
const selectedYear = years[yearIndex];
``` 
```js
// Input country selection
const selectCountry = Inputs.checkbox(countries, {value: countries, label: "Countries:"});
const selectedCountries = Generators.input(selectCountry);
```
```js
// Stat of live update section
const filteredData = data.filter(d => !isNaN(Number(d[facet])) && d[facet] !== null && d[facet] !== undefined);
```
```js
// Group first by year, then by country
const groupedData = d3.group(filteredData, d => d.Year, d => d.Country);
```
```js
// Filter the dataset by year
const filteredYearData = groupedData.get(selectedYear)
```
```js
// Disable unavailable countries for the selected year
countries.forEach((country, index) => {
  const checkbox = selectCountry.querySelector(`input[value="${index}"]`);
  const countryData = filteredYearData.get(country);
  if (countryData) {
    checkbox.removeAttribute("disabled");
  } else {
    checkbox.setAttribute("disabled", "");
  }
});

// Filter the dataset by countries
const plotData = selectedCountries.flatMap(country => filteredYearData.get(country) || []);
```
```js
import fullpage from "fullpage.js";

requestAnimationFrame(() => {
  new fullpage('#fullpage', {
    anchors: ['viz-tit', 'viz'],
    autoScrolling: true,
    navigation: true,
    navigationPosition: 'right',
    controlArrows: false,
    verticalCentered: true,
    animateAnchor: false,
  });

});
```

# Secondary Education: OECD PISA Questionnaires

## Influence of socio-cultural-economic factors in 15-year-olds' aptitude for math and reading


### Distribution of PISA Scores vs. ESCS Index

<div class="card">
    <h2>Correlation between PISA ${facet}s and ESCS Index in ${selectedYear}</h2>
    <div id="options">
      ${selectScore}${selectYear}
    </div>
    ${selectCountry}
    <label>
      <input type="checkbox" id="check-all" checked="">
      All countries
    </label>
    ${
    resize((width) => Plot.plot({
      width,
      height: 500,
      grid: true,
      r: {range: [0, 25]},
      x: {domain: [xMin, xMax], axis: null, grid: true},
      y: {domain: [yMin, yMax]},
      color: {domain: countries, range: countries.map(x => colorScale.get(x))},
      marks: [
        Plot.ruleY([0]),
        Plot.ruleX([500]),
        Plot.dot(plotData, {x: facet, y: "ESCS Index", fill: d => colorScale.get(d.Country), r: 1.5}),
        Plot.linearRegressionY(plotData, {x: facet, y: "ESCS Index"}),
        Plot.dot(plotData, Plot.pointer({x: facet, y: "ESCS Index", r: 8})),
        Plot.tip(plotData, Plot.pointer({x: {value: d => Math.floor(d[facet])}, y: "ESCS Index", fill: "Country"})),
        Plot.dot(plotData, Plot.binX({ r: "count" }, { x: facet , y: -8, tip: true, thresholds: d3.range(xMin, xMax, 20)})),
        Plot.dot(plotData, Plot.binY({ r: "count" }, { x: 1000, y: "ESCS Index", tip: true, thresholds: d3.range(Math.floor(yMin), Math.ceil(yMax), 0.25)})),
      ],
  }))
  }
  © Programme for International Student Assessment (PISA) Organisation for Economic Co-operation and Development (OECD), Paris
</div>
    <div class="card">
    ${
    resize((width) => Plot.plot({
  grid: true,
  round: true,
  r: {
    range: [0, 10]
  },
  marks: [
    Plot.dot(plotData, Plot.bin({r: "count"}, {x: facet, y: "ESCS Index", tip: true, stroke: d => colorScale.get(d.Country)}))
  ]
  }))
  }
    </div>
    <div class="card">
    ${
    resize((width) => Plot.plot({
  marginLeft: 100,
  padding: 0,
  x: {
    round: true,
    grid: true
  },
  fy: {
    label: null,
    domain: d3.groupSort(filteredData, g => d3.median(g, d => d[facet]), d => d.Country)
  },
  color: {
    scheme: "YlGnBu"
  },
  facet: {
    data: filteredData,
    marginLeft: 100,
    y: "Country"
  },
  marks: [
    Plot.barX(filteredData, Plot.binX({fill: "proportion-facet"}, {x: facet, inset: 0.5}))
  ]
  }))
  }
    </div>

---

https://www.oecd.org/en/about/programmes/pisa/how-to-prepare-and-analyse-the-pisa-database.html


<style>

.card input[name="input"][type="checkbox"] {
  appearance: none;
  width: 15px;
  height: 15px;
  border: 2px solid;
  border-radius: 2.5px;
  margin: 2px;
  flex-shrink: 0;
  cursor: pointer;
  display: inline-block;
  border-color: var(--checkbox-color, gray);
}

.card input[name="input"][type="checkbox"]:checked {
  background-color: var(--checkbox-color, gray);
}

.card input[disabled] {
  background-color: var(--theme-foreground-fainter) !important;
  border-color: var(--theme-foreground-faint) !important;
}

#options {
  display: flex;
  flex-flow: nowrap;
}

#options form:nth-child(2) .inputs-3a86ea-input {
  flex: 1 1;
  width: 100%;
  display: flex;
  flex-flow: column;
}

.card input[type="range"] {
  margin-right: 6.5px !important;
}

datalist {
  width: 100%;
}

.inputs-3a86ea-checkbox {
  width: auto;
  max-width: 100% !important;
}

.inputs-3a86ea-checkbox > div label, .card > label {
  max-width: inherit !important;
  font-family: system-ui, sans-serif;
  margin-bottom: 0px;
}

.card > form div {
  width: 100%;
  display: grid;
  grid-auto-flow: column;
  grid-template-rows: repeat(3, 1fr);
  align-items: center;
  justify-items: left;
}

@container (max-width: 950px) {
  .inputs-3a86ea-checkbox > div label, .card > label {
    font-size: 10px;
  }
}

@container (max-width: 740px) {

  .card > form div {
    grid-template-rows: repeat(9, 1fr) !important;
  }

  #options {
    flex-flow: column;
  }

  form {
    margin: 0.1rem 0 !important;
  }
}

@container (min-width: 740px) {
  .card > label {
    margin-left: 126.5px;
  }
}

  #options form:nth-child(2) {
    width: 100%;
  }

.card > form {
  margin: 0 !important;
}


#check-all {
  margin-top: 2px;
  margin-left: 2px;
  margin-right: 2px;
  margin-bottom: 10px;
  width: 15px;
  height: 15px;
  flex-shrink: 0;
  cursor: pointer;
  display: inline-block;
}


</style>