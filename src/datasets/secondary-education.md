---
toc: false
---
```js
import {plotLevels, plotTrend, plotGrid, reshape, distribution, serialize } from "../components/pisaCharts.js";
```
```js
const data = FileAttachment("source/D1_secondary_education.csv").csv({typed:true});
```
```js
const yearMin = d3.min(data, d => d.year);
const yearMax = d3.max(data, d => d.year);
const scoreMin = d3.min(data, d => Math.min(d.quant10_math, d.quant10_read));
const scoreMax = d3.max(data, d => Math.max(d.quant90_math, d.quant90_read));
const countries = Array.from(new Set(data.map(d => d.country))).sort();
const color = [
"#0F52BA", "#4682B4", "#A7C7E7", "#9FE2BF", "#40B5AD", "#097969",
"#0EA37D", "#438F4C", "#93C572", "#8CA348", "#CCCA3C", "#FAD92B",
"#F5DEB3", "#FF8F0B", "#CC7722", "#C19A6B", "#6F4E37", "#A0522D",
"#A42A04", "#722F37", "#A85A69", "#FAA0A0", "#FCACCC", "#D47BA1",
"#9F5691", "#A57EDA", "#735DAD", "currentColor"
];
const orderedCountries = countries.filter(c => c !== "European Union (28)").concat("European Union (28)");
const colorScale = d3.scaleOrdinal(orderedCountries, color);
```
```js
const selectCountry = Inputs.select(countries, {value: "European Union (28)", label: "Country:", sort: true});
const country = Generators.input(selectCountry);
```
```js
const selectTest = Inputs.radio(["Math", "Reading"], {value: "Math", label: "Sort by:"});
const test = Generators.input(selectTest);
```
```js
const years = Array.from(new Set(data.map(d => d.year))).sort();
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
function addDatalist() {
  const ranges = document.querySelectorAll("input[type='range']");

  ranges.forEach((range, index) => {
    const dataListId = `pisa-years-${index}`;

    if (!range.hasAttribute("list")) {
      range.setAttribute("list", dataListId);
    }

    const container = range.parentNode;
    container.style.display = "flex";
    container.style.flexFlow = "column";
    container.style.alignItems = "flex-start";
    container.style.paddingRight = "1rem";
    container.style.boxSizing = "border-box";

    if (!document.getElementById(dataListId)) {
      const dataList = document.createElement("datalist");
      dataList.id = dataListId;
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
    }
  });
}

requestAnimationFrame(addDatalist);

const observer = new MutationObserver(() => {
  requestAnimationFrame(addDatalist);
});

observer.observe(selectYear, { childList: true, subtree: true });
```
```js
const yearData = scores.get(selectedYear);
```
```js
const escs = d3.group(reshape(data, "escs"), d => d.country);
const isced = d3.group(reshape(data, "isced"), d => d.country);
const books = d3.group(reshape(data, "books"), d => d.country);
const computer = d3.group(reshape(data, "computer"), d => d.country);
const lonely = d3.group(reshape(data, "lonely"), d => d.country);
const escsDistribution = distribution(data, "escs");
const iscedDistribution = distribution(data, "isced");
const scores = d3.group(data.flatMap(d => [
  {
    year: d.year,
    country: d.country,
    test: "Math",
    mean_score: d.mean_math,
    quant10: d.quant10_math,
    quant90: d.quant90_math,
    diff: (d.mean_math - d.mean_read) > 0 ? (d.mean_math - d.mean_read) : null
  },
  {
    year: d.year,
    country: d.country,
    test: "Reading",
    mean_score: d.mean_read,
    quant10: d.quant10_read,
    quant90: d.quant90_read,
    diff: (d.mean_read - d.mean_math) > 0 ? (d.mean_read - d.mean_math) : null
  }
]),
(d) => d.year);
```
```js
const barchart = resize((width) => {
  const chart = Plot.plot({
    width,
    height: 700,
    marginLeft: 85,
    marginTop: 15,
    title: html`<h2>Average scores in ${test === "Math" 
      ? html`<span class="math underlined">math</span> and <span class="read underlined">reading</span>` 
      : html`<span class="read underlined">reading</span> and <span class="math underlined">math</span>`} 
      by education system: ${selectedYear}</h2>`,
    subtitle: "Average scores and 10th and 90th percentile scores of 15-year-old students on the PISA math and reading literacy scale, by education system.\nThe difference between the average in the two disciplines in the same country is emphasized by a fainter color.",
    caption: html`<span class="caption"><span>© Programme for International Student Assessment (PISA), OECD</span><span><a href="https://webfs.oecd.org/pisa2022/index.html" target="_blank">Get the data</a></span></span>`,
    className: "averages",
    x: {axis: "top", domain: [240, scoreMax], line: true, label: "Score", insetRight: 60},
    y: {axis: null, domain: test == "Math" ? ["Math", "Reading"] : ["Reading", "Math"]},
    fy: {
      padding: 0,
      label: null,
      tickFormat: x => x === "European Union (28)" ? "European Union" : `${x}`,
      domain: d3.groupSort(
        yearData.filter(d => d.test === test),
        (D) => d3.mean(D, d => d.mean_score),
        d => d.country
      ).reverse()
    },
    symbol: {
      domain: ["10th percentile", "Average score", "90th percentile"],
      range: ["circle","diamond", "cross"],
      legend: true,
      fill: "currentColor",
      className: "symbols"
    },
    marks: [
      Plot.barX(yearData, {
        x1: 240,
        x2: "mean_score",
        y: "test",
        fy: "country",
        fill: "test"
      }),
      Plot.barX(yearData, {
        x1: "mean_score",
        x2: d => d.mean_score - d.diff,
        y: "test",
        fy: "country",
        fill: "var(--theme-background)",
        fillOpacity: 0.4
      }),
      Plot.barX(yearData, Plot.pointerY({
        x1: 0,
        x2: 1000,
        fy: "country",
        fill: "currentColor",
        fillOpacity: 0.1,
        maxRadius: 40,
        clip: true
      })),
      Plot.gridX({strokeOpacity: 0.2}),
      Plot.dot(yearData, {
        x: "mean_score",
        y: "test",
        fy: "country",
        symbol: "diamond",
        fill: "currentColor"
      }),
      Plot.dot(yearData, {
        x: "quant10",
        y: "test",
        fy: "country",
        symbol: "circle",
        fill: "currentColor"
      }),
      Plot.dot(yearData, {
        x: "quant90",
        y: "test",
        fy: "country",
        symbol: "cross",
        fill: "test"
      }),
      Plot.text(yearData, Plot.pointerY({
        x1: 240,
        x2: 800,
        dx: -4,
        fy: "country",
        frameAnchor: "right",
        textAnchor: "end",
        fill: "currentColor",
        maxRadius: 40,
        text: (d, i, data) => {
          const math = data.find(e => e.test === "Math" && e.country === d.country);
          const reading = data.find(e => e.test === "Reading" && e.country === d.country);
          return test === "Math"
            ? `${math ? `Math: ${Math.round(math.mean_score)}` : ""}\n${reading ? `Reading: ${Math.round(reading.mean_score)}` : ""}`
            : `${reading ? `Reading: ${Math.round(reading.mean_score)}` : ""}\n${math ? `Math: ${Math.round(math.mean_score)}` : ""}`;
        }
      }))
    ]
  });

  d3
  .select(chart)
  .selectAll("text")
  .filter(function() { return this.textContent.includes("European Union"); })
  .style("font-weight", "bold");

  return chart
});
```
```js
const trendChart =  resize((width) => plotTrend({width, data, test, countries}));
```
```js
const mathEscsChart = resize((width) => plotLevels({
    width,
    country,
    data: escs,
    test: "Math",
    group: "escs",
    title: `Math proficiency by socioeconomic status in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA math literacy scale, by quartiles of the PISA index of economic, social, and cultural status (ESCS)."
  }));

const readEscsChart = resize((width) => plotLevels({
    width,
    country,
    data: escs,
    test: "Reading",
    group: "escs",
    title: `Reading proficiency by socioeconomic status in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA reading literacy scale, by quartiles of the PISA index of economic, social, and cultural status (ESCS)."
  }));

const mathIscedChart = resize((width) => plotLevels({
    width,
    country,
    data: isced,
    test: "Math",
    group: "isced",
    title: `Math proficiency by parents' education in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA math literacy scale, by aggregated levels of the International Standard Classification of Education (ISCED)."
  }));

const readIscedChart = resize((width) => plotLevels({
    width,
    country,
    data: isced,
    test: "Reading",
    group: "isced",
    title: `Reading proficiency by parents' education in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA reading literacy scale, by aggregated levels of the International Standard Classification of Education (ISCED)."
  }));

const mathBooksChart = resize((width) => plotLevels({
    width,
    country,
    data: books,
    test: "Math",
    group: "books",
    title: `Math proficiency by number of books owned in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA math literacy scale, by the number of books in the student's home."
  }));

const readBooksChart = resize((width) => plotLevels({
    width,
    country,
    data: books,
    test: "Reading",
    group: "books",
    title: `Reading proficiency by number of books owned in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA reading literacy scale, by the number of books in the student's home."
  }));

const mathComputerChart = resize((width) => plotLevels({
    width,
    country,
    data: computer,
    test: "Math",
    group: "computer",
    title: `Math proficiency by computer use in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA math literacy scale, by frequency of computer use."
  }));

const readComputerChart = resize((width) => plotLevels({
    width,
    country,
    data: computer,
    test: "Reading",
    group: "computer",
    title: `Reading proficiency by computer use in ${["European Union (28)", "Netherlands", "United Kingdom"].includes(country) ? "the " : ""}${country}: ${yearMin}–${yearMax}`,
    subtitle: "Average scores on the PISA reading literacy scale, by frequency of computer use."
  }));

const mathEscsDistributionChart = resize((width) => plotGrid({
    width,
    year: selectedYear,
    country,
    data: escsDistribution,
    test: "Math",
    group: "escs"
 }));

const readEscsDistributionChart = resize((width) => plotGrid({
    width,
    year: selectedYear,
    country,
    data: escsDistribution,
    test: "Reading",
    group: "escs"
 }));

const mathIscedDistributionChart = resize((width) => plotGrid({
    width,
    year: selectedYear,
    country,
    data: iscedDistribution,
    test: "Math",
    group: "isced" 
 }));

const readIscedDistributionChart = resize((width) => plotGrid({
    width,
    year: selectedYear,
    country,
    data: iscedDistribution,
    test: "Reading",
    group: "isced"
 }));
```
```js
function wrapsvg (svgnode, filename = 'chart.svg') {

  const root = html`<div style="display: inline-block; position: relative;" class="download-button-wrapper">
      ${svgnode}
      <a class="download" download="${filename}" href="#" style="position: absolute; top: 0; right: 0; width: 20px; height: 20px;">
        <svg width="20px" height="20px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g>
            <path d="M12.5 4V17M12.5 17L7 12.2105M12.5 17L18 12.2105" stroke="var(--theme-foreground-alt)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
            <path d="M6 21H19" stroke="var(--theme-foreground-muted)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path>
          </g>
        </svg>
      </a>
    </div>`

  const downloadButton = root.querySelector('a.download');
  downloadButton.onclick = function (e) {
    var url = downloadButton.href = URL.createObjectURL(serialize(svgnode));
    setTimeout(function() { URL.revokeObjectURL(url); }, 50);
  }
  
  return root;
};
```

# Secondary Education: OECD PISA Questionnaires

<h2>Influence of socio-cultural-economic factors in 15-year-olds' aptitude for math and reading</h2>

The PISA questionnaires provide a vantage point on the educational situation of European adolescents over a period of more than two decades. Our analysis focuses on both cross-country comparisons and the role of social stratification within each country.

<div class="note">

For convenience, the EU average is considered fixed at 28 countries (pre-Brexit). This means that the analysis collects data from all countries for which PISA results are available, even though they were not yet or no longer part of the EU.

</div>

## Variation of math and reading skills among school systems of EU countries

A comparison of math and reading scores on the PISA literacy scale reveals some relevant patterns across EU countries:

  - **Flattening to the mean:** Average scores in math and reading have been decreasing over the years for the top-performing countries, while they tended to increase for the countries with the lowest scores. However, with COVID-19 there was a general regression and a sharp decline in scores in the last survey of 2022.

  - **Subject-based differences:** Although math and reading scores are tightly correlated, there exist some local differences. In countries such as the Netherlands, students tend to perform better in math than in reading, whereas in others—such as Ireland and most Southern European countries—the opposite is true.

  - **Educational disparities:** In Nordic and Baltic countries like Finland and Estonia the education system appears more equitable, as the gap between the lowest- and highest-performing students remains narrower. In contrast, this disparity has widened in many Central and especially Eastern European countries.

  - **Widening literacy gap:** Notably, the gap between the strongest and weakest readers has widened over time, surpassing the variation in math scores in almost all countries.


${Inputs.form({test: selectTest, year: selectYear})}
<div class="grid grid-cols-3" style="grid-auto-rows: auto auto auto;">
  <div class="card grid-colspan-2">
    ${wrapsvg(barchart, "Average math and reading scores.svg")}
  </div>
  <div class="grid-colspan-2">
    ${Inputs.bind(Inputs.radio(["Math", "Reading"], {value: "Math", label: "Show:"}), selectTest)}
  </div>
  <div class="card grid-colspan-2">
    ${wrapsvg(trendChart, `Trend in ${test.toLowerCase()} scores.svg`)}
  </div>
</div>


## Variation in math and reading skills by socioeconomic status

The **PISA Index of Economic, Social, and Cultural Status (ESCS)** is a composite measure derived from three key indicators: **parents' employment status**, their **level of education**, and **possession of specific household resources**—such as a room of one's own, classical literature, and a computer—intended as proxies for an economic environment conducive to learning. These indicators are constructed separately based on students' responses to background questions, then a **principal component analysis (PCA)** is performed to combine them into a single socioeconomic index, weighting each component based on its contribution to overall variance.

To study the relationship between socioeconomic background and academic performance, students were grouped into **quartiles** based on the EU-wide ESCS index for that year. Each quartile represents 25% of students, from the least affluent (first quartile) to the most privileged (fourth quartile). This classification allows us to compare the range of average scores across different socioeconomic brackets.

Our analysis reveals that while average scores differ across countries, **the gap between the least affluent and most privileged students remains remarkably stable**. This underscores the persistent impact of socioeconomic status on academic performance, which can only be partially mitigated by national education policies.

In some countries, such as Romania and Bulgaria, the performance distribution skews downward, with students in the third socioeconomic quartile achieving scores comparable to those in the second quartile at the EU level. This highlights the **role of personal privilege** in shaping academic outcomes, suggesting that individual socioeconomic advantage can partially offset broader geopolitical disadvantages.

<div>
  ${selectCountry}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(mathEscsChart, `Math over ESCS ${country}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readEscsChart, `Reading over ESCS ${country}.svg`)}
</div>
<div class="grid-colspan-1">
  ${Inputs.form({
    country: Inputs.bind(Inputs.select(countries, {label: "Country:", sort: true}), selectCountry),
    year: Inputs.bind(Inputs.range([0, years.length - 1], {label: "Year:", step: 1, value: 0, format: x => years[x], width: "inherit"}), selectYear)
  })}
</div>
<div class="grid-colspan-1"></div>
<div class="card grid-colspan-1">
  ${wrapsvg(mathEscsDistributionChart, `Math levels over ESCS ${country} ${selectedYear}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readEscsDistributionChart, `Reading levels over ESCS ${country} ${selectedYear}.svg`)}
</div>
</div>

## Variation in math and reading skills by parents' education

Because the ESCS index is a highly aggregate measure, we explored how its individual components contribute to variations in student performance. Among the available indicators, we considered **parental education**, **book ownership**, **classical literature**, and **artworks** in the household. Here, we present the results for the first two, as they provided layered rather than binary answers, making them more informative for analysis.

In the PISA dataset, students' responses on the education level of both parents are converted into a single value, the **higher education level of the two** according to the **International Standard Classification of Education (ISCED)**. To ensure comparability between 2000 and 2022 despite the 2011 ISCED revision, we grouped education levels into three broader categories, following [Eurostat guidelines](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=International_Standard_Classification_of_Education_(ISCED)):

  - **Low education (ISCED 0-2):** Completed primary education or lower secondary education (middle school)
  - **Medium education (ISCED 3-4):** Completed upper secondary education (high school or vocational training)
  - **High education (ISCED 5-8):** Tertiary education ranging from a bachelor's degree to a PhD

The diagrams highlight that **having low-educated parents is an even stronger predictor of poor academic performance than a low socioeconomic index**, with this effect often being more pronounced in math than in reading. This is because it captures a more extreme situation of disadvantage, with only a handful of parents not having completed upper secondary education in all European countries.

However, at higher education levels, this pattern is less clear, suggesting that while low parental education is a strong disadvantage, additional academic benefits from higher parental education do not always scale proportionally. Indeed, in some countries such as Italy, the performance gap between students with middle- and highly educated parents was not statistically significant for years, suggesting that **tertiary education does not always yield additional advantages over secondary education**.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:", sort: true}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(mathIscedChart, `Math over parents' education ${country}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readIscedChart, `Reading over parents' education ${country}.svg`)}
</div>
<div class="grid-colspan-1">
  ${Inputs.form({
    country: Inputs.bind(Inputs.select(countries, {label: "Country:", sort: true}), selectCountry),
    year: Inputs.bind(Inputs.range([0, years.length - 1], {label: "Year:", step: 1, value: 0, format: x => years[x], width: "inherit"}), selectYear)
  })}
</div>
<div class="grid-colspan-1"></div>
<div class="card grid-colspan-1">
  ${wrapsvg(mathIscedDistributionChart, `Math levels over ISCED ${country} ${selectedYear}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readIscedDistributionChart, `Reading levels over ISCED ${country} ${selectedYear}.svg`)}
</div>
</div>

## Variation in math and reading skills by number of books owned

The number of books in a household appears to have a **similar influence on both math and reading scores**, reinforcing the close relationship between these two skill sets. However, owning a large number of books is often **not as strong a predictor of excellent academic performance** as belonging to the highest socioeconomic quartile. In contrast, **having only up to a dozen books** at home is one of the strongest factors we identified in our dataset for **major learning struggles** in school.

Interestingly, having more than 500 books does not provide an advantage over having between 200 and 500—and in some cases, it even correlates with slightly lower performance. This may be due to **estimation difficulties** among respondents, leading to inconsistencies in reporting.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:", sort: true}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(mathBooksChart, `Math over book ownership ${country}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readBooksChart, `Reading over book ownership ${country}.svg`)}
</div>
</div>

## Variation in math and reading skills by frequency of computer use

Finally, we included in our analysis a factor not part of the ESCS index: not just the presence of a **computer**—whether a desktop or laptop—in the home, but also its availability for use and the **frequency with which students actively engage with it**.

Over the course of the survey period, we observe that what began as a tool for democratizing access to knowledge gradually evolved into a new source of inequality: daily access to a personal computer has increasingly become a **prerequisite for maintaining average academic performance**. Once again, this holds for **both math and reading skills**.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:", sort: true}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(mathComputerChart, `Math over computer use ${country}.svg`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(readComputerChart, `Reading over computer use ${country}.svg`)}
</div>
</div>


---

## About the dataset

The [dataset](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html) includes estimated mathematics, science and reading comprehension skills of 15-year-old students, derived from a progressively difficult test, along with responses to a general questionnaire on family and school background. The students were drawn from schools selected for statistical significance within the target country, and both students and schools were **anonymized** and assigned unique IDs. Since 2000, the survey has been repeated every three years—except for the gap between 2018 and 2022 due to COVID-19—and includes an increasing number of countries, also non-members of the Organization for Economic Cooperation and Development (OECD), which conducts the study.

### Sampling and methodology

Our initial instinct was to visualize the data in a scatter plot to examine the relationship between mathematics performance, reading comprehension, and socioeconomic status—a step we initially took. However, as we gained a deeper understanding of the structure of PISA questionnaires and their complex sampling methodology, we realized that this approach was fundamentally flawed.

Since schools are selected through a stratified sampling approach but may choose to opt out, **sampling weights** are assigned to each ID to correct for this variability. When applied, these weights ensure that each ID accurately represents its proportion within the total population of 15-year-olds in the reference country. Without them, students from oversampled schools would be overrepresented.[^1]

Moreover, students do not take a full test covering all subjects, which would take up to 10 hours. Instead, they are randomly assigned different test booklets, each containing only a subset of questions, and some students may not have answered any questions on mathematics or reading comprehension at all. To address this, the survey relies on **multiple imputation**, using responses from the background questionnaire to infer missing information and estimate proficiency levels.

Consequently, rather than reporting a single skill score per student, the dataset provides multiple **plausible values**—statistical estimates that account for the uncertainty of missing data. These values are not meant to measure an individual’s ability precisely but to approximate the performance of students with similar characteristics: **they provide a statistical estimate of the skills of the _stratum_ that student represents**.

For this reason, linking questionnaire responses directly to a student’s plausible values in mathematics or reading leads to misleading conclusions: for meaningful analysis, plausible values cannot be treated as fixed individual scores. Instead, as recommended by the [OECD guidelines](https://www.oecd.org/en/about/programmes/pisa/how-to-prepare-and-analyse-the-pisa-database.html), the correct approach involves:
  1. Grouping students based on the variable of interest (e.g., socioeconomic status).
  2. Applying weights to account for sampling design.
  3. Averaging each plausible value within the group.
  4. Computing the final group-level estimate by taking the mean across all plausible values (five or ten, depending on the survey year).

To ensure that these steps were performed correctly, we used the R library [Rrepest](https://cran.r-project.org/web/packages/Rrepest/index.html), also developed by OECD, which provides [example analyses](https://gitlab.algobank.oecd.org/edu_data/rrepest/-/blob/main/Development/Examples.R) as well. The code for producing our dataset can be reviewed [here](https://github.com/frammenti/knowledge-sake/blob/main/src/scripts/PISA.R).

<div class="tip" label>

<b>Intrigued? [Take the test](https://www.oecd.org/en/about/programmes/pisa/pisa-test.html)</b>

</div>

[^1]: Jerrim, J., Lopez-Agudo, L. A., Marcenaro-Gutierrez, O. D., Shure, N. (2017). “To weight or not to weight?: The case of PISA data.” In _Proceedings of the XXVI Meeting of the Economics of Education Association_, Murcia, Spain (pp. 29-30). <https://2017.economicsofeducation.com/user/pdfsesiones/025.pdf>

```js
const searchField = Inputs.search(data);
const search = Generators.input(searchField);
const toggleSe = Inputs.toggle({label: "Standard errors", value: false});
const se = Generators.input(toggleSe);
```
<div class="card" style="padding: 0;">
  <div style="padding: 1rem; display: flex; gap: 1.5rem;">
    ${searchField}${toggleSe}
  </div>
  ${Inputs.table(search, {
    columns: se ? search.columns : search.columns.filter(column => !column.startsWith("se_")),
    rows: 22,
    select: false,
    format: { year: (d) => `${d}` }
  })}
</div>


<style>

  @media (min-width: 640px) {
    .symbols-swatches {
      margin: 0 0 0 5rem;
    }
  }

</style>