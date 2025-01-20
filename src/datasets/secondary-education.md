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

  checkboxes.forEach((checkbox, index) => {
    checkbox.style.setProperty("--checkbox-color", color[index]);
    checkbox.addEventListener("change", updateCheckAllState)
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
const selectScore = Inputs.radio(["Math", "Reading"], {value: "Math Score", valueof: x => x + " Score"});
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
});
const yearIndex = Generators.input(selectYear);
```
```js
const selectedYear = years[yearIndex];
``` 
```js
// Input country selection
const selectCountry = Inputs.checkbox(countries, {value: countries});
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

# Secondary Education: OECD PISA Questionnaires

## Influence of socio-cultural-economic factors in 15-year-olds' aptitude for math and reading

...

### Distribution of PISA Scores vs. ESCS Index

<div class="grid grid-cols-2-3">
  <div class="card grid-rowspan-2" id="card-pisa-score">
    <label>Score</label>
    ${selectScore}
  </div>
  <div class="card grid-colspan-2 grid-rowspan-2" id="card-pisa-years">
    <label>Year</label>
    ${selectYear}
    <datalist id="pisa-years">
      <option value="0" label="2000"></option>
      <option value="1" label="2003"></option>
      <option value="2" label="2006"></option>
      <option value="3" label="2009"></option>
      <option value="4" label="2012"></option>
      <option value="5" label="2015"></option>
      <option value="6" label="2018"></option>
      <option value="7" label="2022"></option>
    </datalist>
  </div>
  <div class="card grid-wide" id="card-pisa1">
    <h2>Correlation between PISA ${facet}s and ESCS Index in ${selectedYear}</h2>
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
      x: {domain: [xMin, xMax]},
      y: {domain: [yMin, yMax]},
      color: {domain: countries, range: countries.map(x => colorScale.get(x))},
      marks: [
        Plot.ruleY([0]),
        Plot.ruleX([500]),
        Plot.dot(plotData, {x: facet, y: "ESCS Index", fill: d => colorScale.get(d.Country), r: 1.5}),
        Plot.linearRegressionY(plotData, {x: facet, y: "ESCS Index"}),
        Plot.dot(plotData, Plot.pointer({x: facet, y: "ESCS Index", r: 8})),
        Plot.tip(plotData, Plot.pointer({x: {value: d => Math.floor(d[facet])}, y: "ESCS Index", fill: "Country"}))
      ],
  }))
  }
  ${
  resize((width) => Plot.plot({
  width,
  height: 100,
  y: { grid: true, label: "Frequency" },
  x: { domain: [xMin, xMax], axis: null },
  marks: [
    Plot.areaY(
      plotData, 
      Plot.binX({ y: "count" }, { x: facet, fillOpacity: 0.2 })
    ),
    Plot.lineY(
      plotData, 
      Plot.binX({ y: "count" }, { x: facet })
    ),
    Plot.ruleY([0])
  ]
  }))
  }</div>
</div>




---
<style>

#card-pisa-score form {
  flex: 1;
  align-content: center;
}

#card-pisa1 input[name="input"] {
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

#card-pisa1 input[name="input"]:checked {
  background-color: var(--checkbox-color, gray);
}

#card-pisa1 input[disabled] {
  background-color: var(--theme-foreground-fainter) !important;
  border-color: var(--theme-foreground-faint) !important;
}

#card-pisa1 form, #card-pisa1 label {
  max-width: inherit !important;
  font-family: system-ui, sans-serif;
  font-size: 10px;
  margin-bottom: 0px;
}

#card-pisa1 form div {
  width: 100%;
  display: grid;
  grid-auto-flow: column;
  grid-template-rows: repeat(3, 1fr);
  align-items: center;
  justify-items: left;
  margin-top: 5px;
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

@media (max-width: 640px) {
  #card-pisa1 form div {
    grid-template-rows: repeat(9, 1fr) !important;
  }
}

.grid-cols-2-3 {
  grid-template-rows: auto auto auto auto;
}

@container (min-width: 560px) {
  .grid-cols-2-3 {
    grid-template-columns: 1fr 3fr;
    grid-auto-flow: column;
  }

  .grid-cols-2-3 .grid-colspan-2 {
    grid-column: span 2;
  }

.grid-wide {
  grid-column: 1 / 4;
  grid-row: 3;
  height: auto;
  }
}

</style>