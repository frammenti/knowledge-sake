---
toc: false
---

```js
const loadData = FileAttachment("D2.1_undergraduate_enrollment.csv").csv({typed:true});
const color = d3.scaleOrdinal(d3.schemeObservable10);
```
```js
const xMin = d3.min(loadData, d => d.Year);
const xMax = d3.max(loadData, d => d.Year);
const countries = Array.from(new Set(loadData.map(d => d.Country)));
const fields = Array.from(new Set(loadData.map(d => d["Field (ISCED-F 2013)"])));
```
```js
// Input country selection
const selectCountry = Inputs.select(countries, {label: "Country:", value: "European Union"});
const selectedCountry = Generators.input(selectCountry);
```
```js
// Input fields selection
const selectFields = Inputs.checkbox(fields, {label: "Compare fields:", multiple: true, value: fields});
const selectedFields = Generators.input(selectFields);
```
```js
const selectMetric = Inputs.radio(["Enrollment Count", "Weighted Enrollment Growth Rate (%)", "Enrollment Growth Rate (%)"], {label: "Metric:", value: "Enrollment Count"});
const metric = Generators.input(selectMetric);
```
```js
// Input year selection
const selectYear = Inputs.range([xMin, xMax], {
  step: 1,
  value: xMax,
  width: "inherit"
});
const selectedYear = Generators.input(selectYear);
```
```js
function selectYearDatalist() {
  const datalistId = "year-list";
  const datalist = html`<datalist id="${datalistId}">
    ${Array.from({ length: xMax - xMin + 1 }, (_, i) => 
      html`<option value="${xMin + i}" label="${xMin + i}">`
    )}
  </datalist>`;

  const container = html`<div style="display: flex; flex-direction: column;">
    <label>Year:</label>
    ${selectYear}
    ${datalist}
  </div>`;

  return container;
};
```
```js
requestAnimationFrame(() => {
  const range = selectYear.querySelector("input[type='range']");
  range.setAttribute("list", "year-list");
  const chart = document.querySelector("#the-chart");
  chart.update(plotData.filter(d => d.Year === selectedYear));

  const checkboxes = selectFields.querySelectorAll("input[type='checkbox']");
  checkboxes.forEach((checkbox, index) => {
    checkbox.style.setProperty("--checkbox-color", color(index));
});
});
```
```js
// Group first by country, then by fields
const groupedData = d3.group(loadData, d => d.Country, d => d["Field (ISCED-F 2013)"]);
```
```js
// Filter the dataset by country
const filteredCountryData = groupedData.get(selectedCountry)
```
```js
const plotData = selectedFields.flatMap(field => filteredCountryData.get(field) || []);
```
```js
function chart(width) {
  const height = width * 0.6;
  const svg = d3.create("svg")
      .attr("viewBox", [0, 0, width, height * 1.05])
      .attr("id", "the-chart");

  const g = svg.append("g");

  g.append("g").attr("class", "slices");
  g.append("g").attr("class", "labels");
  g.append("g").attr("class", "lines");

  const radius = Math.min(width, height) / 2;

  const pie = d3
    .pie()
    .sort(null)
    .value(function(d) {
      return d['Distribution (%)'];
    });

  const arc = d3
    .arc()
    .outerRadius(radius * 0.9)
    .innerRadius(radius * 0.45);

  const outerArc = d3
    .arc()
    .innerRadius(radius)
    .outerRadius(radius);

  g.attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  const key = function(d) {
    return d.data['Field (ISCED-F 2013)'];
  };

  function change(data) {

    /* ------- PIE SLICES -------*/

    const pieData = pie(data);
    const slice = g
      .select(".slices")
      .selectAll("path.slice")
      .data(pieData, key);

    slice
      .enter()
      .insert("path")
      .style("fill", function(d) {
        return color(d.data['Field (ISCED-F 2013)']);
      })
      .style("stroke", "currentColor")
      .style("stroke-width", 1.5)
      .style("fill-opacity", 0.3)
      .attr("class", "slice")
      .merge(slice)
      .transition()
      .duration(500)
      .attrTween("d", function(d) {
        console.log("i");
        this._current = this._current || d;
        const interpolate = d3.interpolate(this._current, d);
        this._current = interpolate(0);
        return function(t) {
          return arc(interpolate(t));
        };
      });

    slice.exit().remove();

    /* ------- TEXT LABELS -------*/

    function wrapText(text, maxWidth) {
      text.each(function() {
        const text = d3.select(this);
        const words = text.text().split(/\s+/).reverse();
        let word,
          line = [],
          lineNumber = 0,
          lineHeight = 1.1, // ems
          y = text.attr("y") || 0,
          x = text.attr("x") || 0,
          dy = parseFloat(text.attr("dy")) || 0,
          tspan = text.text(null) // Clear existing text
            .append("tspan")
            .attr("x", x)
            .attr("y", y)
            .attr("dy", `${dy}em`);
        
        while ((word = words.pop())) {
          line.push(word);
          tspan.text(line.join(" "));
          if (tspan.node().getComputedTextLength() > maxWidth) {
            line.pop();
            tspan.text(line.join(" "));
            line = [word];
            tspan = text.append("tspan")
              .attr("x", x)
              .attr("y", y)
              .attr("dy", `${++lineNumber * lineHeight + dy}em`)
              .text(word);
          }
        }
      });
    }

    const text = g
      .select(".labels")
      .selectAll("text")
      .data(pie(data), key);

    function midAngle(d) {
      return d.startAngle + (d.endAngle - d.startAngle) / 2;
    }

    text
      .enter()
      .append("text")
      .attr("dy", ".35em")
      .text(function(d) {
        return d.data['Field (ISCED-F 2013)'];
      })
      .style("font-family", "system-ui")
      .style("font-size", "10px")
      .style("fill", "currentColor")
      .call(wrapText, radius * 0.75)
      .merge(text)
      .transition()
      .duration(1000)
      .attrTween("transform", function(d) {
        this._current = this._current || d;
        const interpolate = d3.interpolate(this._current, d);
        this._current = interpolate(0);
        return function(t) {
          const d2 = interpolate(t);
          const pos = outerArc.centroid(d2);
          pos[0] = radius * (midAngle(d2) < Math.PI ? 1 : -1);
          return "translate(" + pos + ")";
        };
      })
      .styleTween("text-anchor", function(d) {
        this._current = this._current || d;
        const interpolate = d3.interpolate(this._current, d);
        this._current = interpolate(0);
        return function(t) {
          const d2 = interpolate(t);
          return midAngle(d2) < Math.PI ? "start" : "end";
        };
      });

    text.exit().remove();

     /* ------- PERCENTAGES -------*/

      const percentageText = g
        .selectAll(".percentage-text")
        .data(pieData, key);

      percentageText.join(
        enter => enter.append("text")
          .attr("class", "percentage-text")
          .attr("dy", ".35em")
          .style("font-family", "system-ui")
          .style("font-size", "13px")
          .style("text-anchor", "middle")
          .style("fill", "currentColor")
          .text(d => `${d.data['Distribution (%)'].toFixed(0)}%`)
          .attr("transform", d => {
            const pos = arc.centroid(d);
            return `translate(${pos})`;
          }),
        update => update
          .text(d => `${d.data['Distribution (%)'].toFixed(0)}%`)
          .attr("transform", d => {
            const pos = arc.centroid(d);
            return `translate(${pos})`;
          }),
        exit => exit.remove()
      );


     /* ------- TOTAL GROWTH PERCENTAGE -------*/

      if (pieData && pieData.length > 0) {
        const totalGrowthRate = data[0]['Total Growth Rate (%)'];

        const totalGrowth = g
          .selectAll(".total-growth")
          .data(totalGrowthRate != null ? [1] : []);

        totalGrowth.join(
          enter => enter.append("text")
            .attr("class", "total-growth")
            .attr("dy", "0")
            .style("font-family", "var(--sans-serif)")
            .style("text-anchor", "middle")
            .style("fill", "currentColor")
            .call(text => {
            text.append("tspan")
              .attr("x", 0)
              .attr("dy", "-0.6em")
              .style("font-size", "10px")
              .style("font-weight", 500)
              .text("Total Growth Rate");
            text.append("tspan")
              .attr("x", 0)
              .attr("dy", "1.2em")
              .style("font-size", "18px")
              .style("font-weight", 500)
              .text(`${formatValue(totalGrowthRate)}`);
          }),
        update => update.call(text => {
          text.select("tspan:first-child")
            .text("Total Growth Rate");

          text.select("tspan:last-child")
            .text(`${formatValue(totalGrowthRate)}`);
        }),
        exit => exit.remove()
      );
    } else {
      g.selectAll(".total-growth").remove();
    }


    /* ------- SLICE TO TEXT POLYLINES -------*/

    const polyline = g
      .select(".lines")
      .selectAll("polyline")
      .data(pie(data), key);

      polyline.join(
        enter => enter.append("polyline")
          .style("stroke", "currentColor")
          .style("stroke-width", 1)
          .style("opacity", 1)
          .style("fill", "none"),
        update => update,
        exit => exit.remove()
      )
      .transition()
      .duration(1000)
      .attrTween("points", function(d) {
        this._current = this._current || d;
        const interpolate = d3.interpolate(this._current, d);
        this._current = interpolate(0);
        return function(t) {
          const d2 = interpolate(t);
          const innerPoint = d3.arc()
            .outerRadius(radius * 0.9)
            .innerRadius(radius * 0.9)
            .centroid(d2);
          const pos = outerArc.centroid(d2);
          pos[0] = radius * (midAngle(d2) < Math.PI ? 1 : -1) * 0.99;
          return [innerPoint, outerArc.centroid(d2), pos];
        };
      });

    polyline.exit().remove();
  }

  return Object.assign(svg.node(), {
    update(data) {
      change(data); // Pass data to change function
    }
  });
}
```
```js
const fillColors = {
  "Enrollment Count": (d) => color(d["Field (ISCED-F 2013)"]),
  default: "#1a9641"
};
```
```js
function formatValue(value) {
  if (value == null) {
    return ""; // Return an empty string for null or undefined
  } else if (Number.isInteger(value)) {
    return `${value}`; // Print as integer
  } else if (value > 0) {
    return `+${(Math.ceil(value * 100) / 100).toFixed(2)} %`; // Print with "+" and 2 decimal spaces
  } else {
    return `${(Math.ceil(value * 100) / 100).toFixed(2)} %`; // Print with 2 decimal spaces
  }
}
```

# University: Enrollment by field of study


<div class="grid grid-cols-2" style="grid-auto-rows: auto;">
  <div class="card grid-rowspan-3">
    <h2>Undergraduate ${metric} in ${plotData[0].Country === "European Union" ? "the " : ""}${plotData[0].Country}, ${xMin}-${xMax}</h2>
    ${
    resize((width) => Plot.plot({
    width,
    height: (70 * selectedFields.length) + 20,
    marginRight: 35,
    axis: null,
    color: color,
    x: {domain: [xMin, xMax], axis: "bottom", tickFormat: (d) => `${d}`},
    y: {inset: 5},
    marks: [
      Plot.frame(),
      Plot.differenceY(plotData, {height: 20, x: "Year", y: metric, fy: "Field (ISCED-F 2013)", curve: "monotone-x", positiveFill: fillColors[metric],
      negativeFill: "#d7191c", fillOpacity: 0.3, z: null}),
      Plot.text(plotData, Plot.selectFirst({text: "Field (ISCED-F 2013)", fy: "Field (ISCED-F 2013)", frameAnchor: "top-left", dx: 6, dy: 6})),
      Plot.text(plotData, Plot.selectLast({x: "Year", y: metric, fy: "Field (ISCED-F 2013)", text: (d) => formatValue(d[metric]), textAnchor: "start", dx: 5})),
      Plot.tip(plotData, Plot.pointer({x: "Year", y: metric, fy: "Field (ISCED-F 2013)", title: (d) => formatValue(d[metric])}))
    ]
    }))
    }
  </div>
  <div class="card">
    ${selectMetric}
    ${selectCountry}
    ${selectFields}
  </div>
  <div class="card">
    ${selectYearDatalist()}
  </div>
  <div class="card">
    <h2>Distribution of new bachelor students in ${plotData[0].Country === "European Union" ? "the " : ""}${plotData[0].Country}, ${selectedYear}</h2>
    ${resize((width) => chart(width))}
  </div>
</div>

<style>
  input[type="number"] {
    display: none;
  }

  input[type="range"]:input {
    scroll-behavior: auto;
  }

  datalist {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  writing-mode: vertical-lr;
  margin: 0 5px;
  font-family: system-ui, sans-serif;
  font-size: 10px;
}

datalist option {
  rotate: -90deg;
  transform: translate(4px, 3px);
}

.card > form {
  margin: 0.5rem 0;
}

.card h2 {
  margin: 1rem 0;
}

.card label {
  font: 13px/1.2 var(--sans-serif);
}

.inputs-3a86ea select{
  width: inherit !important;
  max-width: 40em !important;
}

.card input[type="checkbox"] {
  appearance: none;
  width: 15px;
  height: 15px;
  border: 2px solid;
  border-radius: 2.5px;
  flex-shrink: 0;
  cursor: pointer;
  display: inline-block;
  border-color: var(--checkbox-color, gray);
  opacity: 0.5;
}

.card input[type="checkbox"]:checked {
  background-color: var(--checkbox-color, gray);
}

form div label {
  font-family: system-ui !important;
}

</style>