```js
const data = FileAttachment("MD1_education_outcome.csv").csv({typed:true})
```
```js
Inputs.table(data)
```
```js
const xMin = d3.min(data, d => d.Year);
const xMax = d3.max(data, d => d.Year);
```
```js
const selectOffset = Inputs.range([0, 10], {label: "Offset", step: 1, value: 4})
const offset = Generators.input(selectOffset);
```
```js
// Input country selection
const selectCountry = Inputs.select(d3.group(data, d => d.Country), {label: "Country"})
const countryData = Generators.input(selectCountry);
```
```js
const offsetData = countryData.map(d => ({
  ...d,
  offsetYear: d.Year - offset
}));
```

# Student Trajectories


<div class="grid grid-cols-1">
  <div class="card">
    ${selectOffset}
    ${selectCountry}
    ${
    resize((width) => Plot.plot({
    width,
    height: 500,
    x: {domain: [xMin, xMax]},
    y: {grid: true},
    marks: [
      Plot.ruleY([0]),
      Plot.lineY(offsetData, {x: "offsetYear", y: "Undergraduate enrollment (%)", stroke: "green", tip: true}),
      Plot.lineY(countryData, {x: "Year", y: "Over-qualification (%)", stroke: "red", tip: true})
    ]
    }))
    }
  </div>
</div>