```js
// const rawData = FileAttachment("esi_dataset_2024_formatted.xlsx").xlsx()
```
```js
const data = rawData.sheet("RawData", {headers: true})
```

# Employment: Overqualification of young workers by sector

```js
Inputs.table(data)
```
```js
const selectedCol = view(Inputs.select(data.columns), {label: "Country"});
```

<div class="grid grid-cols-1">
  <div class="card">
    ${
    resize((width) => Plot.plot({
    width,
    height: 500,
    style: "overflow: visible;",
    y: {grid: true},
    marks: [
      Plot.ruleY([0]),
      Plot.lineY(data, {x: "Data year", y: selectedCol, stroke: "Country Name", marker: true, tip: true})
    ]
    }))
    }
  </div>
</div>