---
toc: false
---
```js
import {plotLevels, plotBar, plotTrend, plotFreq, filterSe, wrapsvg, choose, the } from "../components/charts.js";
import JSONstat from "npm:jsonstat-toolkit";
```
```js
const jraw = FileAttachment("source/json/D1_secondary_education.json").json();
```
```js
const collection = JSONstat(jraw);
const ds1 = collection.Dataset(0).toTable({ type: 'arrobj', meta: true });
const ds2 = collection.Dataset(1).toTable({ type: 'arrobj', meta: true });
const ds3 = collection.Dataset(2).toTable({ type: 'arrobj', meta: true });
const ds4 = collection.Dataset(3).toTable({ type: 'arrobj', meta: true });
const ds8 = collection.Dataset(7).toTable({ type: 'arrobj', meta: true });
/* ESCS */
const ds13 = collection.Dataset(12).toTable({ type: 'arrobj', meta: true });
const ds11 = collection.Dataset(10).toTable({ type: 'arrobj' });
/* HISCED */
const ds14 = collection.Dataset(13).toTable({ type: 'arrobj', meta: true });
const ds12 = collection.Dataset(11).toTable({ type: 'arrobj' });
```
```js
const countries = ds1.meta.dimensions.area.categories.label;
const color = [
"#0F52BA", "#4682B4", "#A7C7E7", "#9FE2BF", "#40B5AD", "#097969",
"#0EA37D", "#438F4C", "#93C572", "#8CA348", "#CCCA3C", "#FAD92B",
"#F5DEB3", "#FF8F0B", "#CC7722", "#C19A6B", "#6F4E37", "#A0522D",
"#A42A04", "#722F37", "#A85A69", "#FAA0A0", "#FCACCC", "#D47BA1",
"#9F5691", "#A57EDA", "#735DAD", "currentColor"
];
```
```js
const selectCountry = Inputs.select(countries, {value: "European Union (28 countries)", label: "Country:"});
const country = Generators.input(selectCountry);
```
```js
const selectTest = Inputs.radio(["Math", "Reading"], {value: "Math", label: "Sort by:"});
const test = Generators.input(selectTest);
```
```js
const years = ds1.meta.dimensions.year.categories.label;
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
    ${wrapsvg(resize((width) => plotBar({ width, mdata: ds1, year: selectedYear, test})), `${ds1.meta.label} ${selectedYear}`)}
  </div>
  <div class="grid-colspan-2">
    ${Inputs.bind(Inputs.radio(["Math", "Reading"], {value: "Math", label: "Show:"}), selectTest)}
  </div>
  <div class="card grid-colspan-2">
    ${wrapsvg(resize((width) => plotTrend({ width, mdata: ds1, test})), `Trend in ${test} Skills`)}
  </div>
</div>


## Variation in math and reading skills by socio-economic status

The **PISA Index of Economic, Social, and Cultural Status (ESCS)** is a composite measure derived from three key indicators: **parents' employment status**, their **level of education**, and **possession of specific household resources**—such as a room of one's own, classical literature, and a computer—intended as proxies for an economic environment conducive to learning. These indicators are constructed separately based on students' responses to background questions, then a **principal component analysis (PCA)** is performed to combine them into a single socio-economic index, weighting each component based on its contribution to overall variance.

To study the relationship between socio-economic background and academic performance, students were grouped into **quartiles** based on the EU-wide ESCS index for that year. Each quartile represents 25% of students, from the least affluent (first quartile) to the most privileged (fourth quartile). This classification allows us to compare the range of average scores across different socio-economic brackets.

Our analysis reveals that while average scores differ across countries, **the gap between the least affluent and most privileged students remains remarkably stable**. This underscores the persistent impact of socio-economic status on academic performance, which can only be partially mitigated by national education policies.

In some countries, such as Romania and Bulgaria, the performance distribution skews downward, with students in the third socio-economic quartile achieving scores comparable to those in the second quartile at the EU level. This highlights the **role of personal privilege** in shaping academic outcomes, suggesting that individual socio-economic advantage can partially offset broader geopolitical disadvantages.
<div>
  ${selectCountry}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds2, test: "Math", group: "escs", country })), `${choose(ds2.meta.label, "Math")} in ${the(country)}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds2, test: "Reading", group: "escs", country })), `${choose(ds2.meta.label, "Reading")} in ${the(country)}`)}
</div>
<div class="grid-colspan-1">
  ${Inputs.form({
    country: Inputs.bind(Inputs.select(countries, {label: "Country:"}), selectCountry),
    year: Inputs.bind(Inputs.range([0, years.length - 1], {label: "Year:", step: 1, value: 0, format: x => years[x], width: "inherit"}), selectYear)
  })}
</div>
<div class="grid-colspan-1"></div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotFreq({ width, mdata: ds13, groupdata: ds11, year: selectedYear, test: "Math", country })), `${choose(ds13.meta.label, "Math")} in ${the(country)} ${selectedYear}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotFreq({ width, mdata: ds13, groupdata: ds11, year: selectedYear, test: "Reading", country })), `${choose(ds13.meta.label, "Reading")} in ${the(country)} ${selectedYear}`)}
</div>
</div>

## Variation in math and reading skills by parents' education

Because the ESCS index is a highly aggregate measure, we explored how its individual components contribute to variations in student performance. Among the available indicators, we considered **parental education**, as well as **number of books**, **classical literature**, and **artworks** in the household. Here, we present the results for the first two, as they provided layered rather than binary answers, making them more informative for analysis.

In the PISA dataset, students' responses on the education level of both parents are converted into a single value, the **higher education level of the two** according to the **International Standard Classification of Education (ISCED)**. To ensure comparability between 2000 and 2022 despite the 2011 ISCED revision, we grouped education levels into three broader categories, following [Eurostat guidelines](https://ec.europa.eu/eurostat/statistics-explained/index.php?title=International_Standard_Classification_of_Education_(ISCED)):

  - **Low education (ISCED 0-2):** Completed primary education or lower secondary education (middle school)
  - **Medium education (ISCED 3-4):** Completed upper secondary education (high school or vocational training)
  - **High education (ISCED 5-8):** Tertiary education ranging from a bachelor's degree to a PhD

The diagrams highlight that **having low-educated parents is an even stronger predictor of poor academic performance than a low socio-economic index**. This is because it captures a more extreme situation of disadvantage, with only a handful of parents not having completed upper secondary education in all of European countries.

However, at higher education levels, this pattern is less clear, suggesting that while low parental education is a strong disadvantage, additional academic benefits from higher parental education do not always scale proportionally. Indeed, in some countries such as Italy, the performance gap between students with middle- and highly educated parents was not statistically significant for years, suggesting that **tertiary education does not always yield additional advantages over secondary education**.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:"}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds3, test: "Math", group: "hisced", country })), `${choose(ds3.meta.label, "Math")} in ${the(country)}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds3, test: "Reading", group: "hisced", country })), `${choose(ds3.meta.label, "Reading")} in ${the(country)}`)}
</div>
<div class="grid-colspan-1">
  ${Inputs.form({
    country: Inputs.bind(Inputs.select(countries, {label: "Country:"}), selectCountry),
    year: Inputs.bind(Inputs.range([0, years.length - 1], {label: "Year:", step: 1, value: 0, format: x => years[x], width: "inherit"}), selectYear)
  })}
</div>
<div class="grid-colspan-1"></div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotFreq({ width, mdata: ds14, groupdata: ds12, year: selectedYear, test: "Math", country })), `${choose(ds14.meta.label, "Math")} in ${the(country)} ${selectedYear}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotFreq({ width, mdata: ds14, groupdata: ds12, year: selectedYear, test: "Reading", country })), `${choose(ds14.meta.label, "Reading")} in ${the(country)} ${selectedYear}`)}
</div>
</div>

## Variation in math and reading skills by number of books at home

The number of books in a household appears to have a **similar influence on both math and reading scores**, reinforcing the close relationship between these two skill sets. However, while book possession correlates with academic performance, it is **not as strong a predictor as belonging to the highest socio-economic quartile**. In contrast, **having only up to a dozen books** at home emerges as one of the strongest indicators of **major learning struggles** in school.

Interestingly, having more than 500 books does not provide an advantage over having between 200 and 500. In some cases, it even correlates with slightly lower performance. This could be due to **estimation inaccuracies** among respondents or **response biases**, leading to inconsistencies in reporting.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:"}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds4, test: "Math", group: "books", country })), `${choose(ds4.meta.label, "Math")} in ${the(country)}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds4, test: "Reading", group: "books", country })), `${choose(ds4.meta.label, "Reading")} in ${the(country)}`)}
</div>
</div>

## Variation in math and reading skills by frequency of computer use

Finally, we included in our analysis a factor not part of the ESCS index: not just the presence of a **computer**—whether a desktop or laptop—in the home, but also its availability for use and the **frequency with which students actively engage with it**.

Over the course of the survey period, we observe that what began as a tool for democratizing access to knowledge gradually evolved into a **new source of inequality**: daily access to a personal computer has increasingly become a **prerequisite for maintaining average academic performance**. Once again, this holds for **both math and reading skills**.

<div>
  ${Inputs.bind(Inputs.select(countries, {label: "Country:"}), selectCountry)}
</div>
<div class="grid grid-cols-2" style="grid-auto-rows: auto auto;">
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds8, test: "Math", group: "computer", country })), `${choose(ds8.meta.label, "Math")} in ${the(country)}`)}
</div>
<div class="card grid-colspan-1">
  ${wrapsvg(resize((width) => plotLevels({ width, mdata: ds8, test: "Reading", group: "computer", country })), `${choose(ds8.meta.label, "Reading")} in ${the(country)}`)}
</div>
</div>

---

## About the dataset

The [dataset](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html) includes estimated mathematics, science and reading comprehension skills of 15-year-old students, derived from a progressively difficult test, along with responses to a general questionnaire on family and school background. The students were drawn from schools selected for statistical significance within the target country, and both students and schools were **anonymized** and assigned unique IDs. Since 2000, the survey has been repeated every three years—except for the gap between 2018 and 2022 due to COVID-19—and includes an increasing number of countries, also non-members of the Organization for Economic Cooperation and Development (OECD), which conducts the study.

### Sampling and methodology

Our initial instinct was to visualize the data in a scatter plot to examine the relationship between mathematics performance, reading comprehension, and socio-economic status—a step we initially took. However, as we gained a deeper understanding of the structure of PISA questionnaires and their complex sampling methodology, we realized that this approach was fundamentally flawed.

Since schools are selected through a stratified sampling approach but may choose to opt out, **sampling weights** are assigned to each ID to correct for this variability. When applied, these weights ensure that each ID accurately represents its proportion within the total population of 15-year-olds in the reference country. Without them, students from oversampled schools would be overrepresented.[^1]

Moreover, students do not take a full test covering all subjects, which would take up to 10 hours. Instead, they are randomly assigned different test booklets, each containing only a subset of questions, and some students may not have answered any questions on mathematics or reading comprehension at all. To address this, the survey relies on **multiple imputation**, using responses from the background questionnaire to infer missing information and estimate proficiency levels.

Consequently, rather than reporting a single skill score per student, the dataset provides multiple **plausible values**—statistical estimates that account for the uncertainty of missing data. These values are not meant to measure an individual’s ability precisely but to approximate the performance of students with similar characteristics: **they provide a statistical estimate of the skills of the _stratum_ that student represents**.

For this reason, linking questionnaire responses directly to a student’s plausible values in mathematics or reading leads to misleading conclusions: for meaningful analysis, plausible values cannot be treated as fixed individual scores. Instead, as recommended by the [OECD guidelines](https://www.oecd.org/en/about/programmes/pisa/how-to-prepare-and-analyse-the-pisa-database.html), the correct approach involves:
  1. Grouping students based on the variable of interest (e.g., socio-economic status).
  2. Applying weights to account for sampling design.
  3. Averaging each plausible value within the group.
  4. Computing the final group-level estimate by taking the mean across all plausible values (five or ten, depending on the survey year).

To ensure that these steps were performed correctly, we used the R library [Rrepest](https://cran.r-project.org/web/packages/Rrepest/index.html), also developed by OECD, which provides [example analyses](https://gitlab.algobank.oecd.org/edu_data/rrepest/-/blob/main/Development/Examples.R) as well. The code for producing our dataset can be reviewed [here](https://github.com/frammenti/knowledge-sake/blob/main/src/scripts/PISA.R).

<div class="tip" label>

<b>Intrigued? [Take the test](https://www.oecd.org/en/about/programmes/pisa/pisa-test.html)</b>

</div>

[^1]: Jerrim, J., Lopez-Agudo, L. A., Marcenaro-Gutierrez, O. D., Shure, N. (2017). “To weight or not to weight?: The case of PISA data.” In _Proceedings of the XXVI Meeting of the Economics of Education Association_, Murcia, Spain (pp. 29-30). <https://2017.economicsofeducation.com/user/pdfsesiones/025.pdf>

___

## Dataset Overview

```js
const t1 = collection.Dataset(0).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t2 = collection.Dataset(1).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t3 = collection.Dataset(2).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t4 = collection.Dataset(3).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t8 = collection.Dataset(7).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t13 = collection.Dataset(12).toTable({ type: 'arrobj', field: "label" , by: "concept" });
const t14 = collection.Dataset(13).toTable({ type: 'arrobj', field: "label" , by: "concept" });
```
```js
const toggleSe = Inputs.toggle({ label: "Standard errors", value: false });
```
```js
const se = Generators.input(toggleSe);
```
```js
const tableInputs1 = Inputs.form([Inputs.search(t1), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs2 = Inputs.form([Inputs.search(t2), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs3 = Inputs.form([Inputs.search(t3), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs4 = Inputs.form([Inputs.search(t4), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs8 = Inputs.form([Inputs.search(t8), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs13 = Inputs.form([Inputs.search(t13), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
const tableInputs14 = Inputs.form([Inputs.search(t14), Inputs.bind(Inputs.toggle({ label: "Standard errors" }), toggleSe)]);
```
```js
const data1 = Generators.input(tableInputs1);
const data2 = Generators.input(tableInputs2);
const data3 = Generators.input(tableInputs3);
const data4 = Generators.input(tableInputs4);
const data8 = Generators.input(tableInputs8);
const data13 = Generators.input(tableInputs13);
const data14 = Generators.input(tableInputs14);
```
```js
const table1 = Inputs.table(filterSe(data1, se), {
  select: false,
  format: { MS: x => d3.format(".3r")(x), RS: x => d3.format(".3r")(x) },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    MS: "Math Score",
    RS: "Reading Score"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table2 = Inputs.table(filterSe(data2, se), {
  select: false,
  format: { MS: x => d3.format(".3r")(x), RS: x => d3.format(".3r")(x) },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    escs: "ESCS Index",
    MS: "Math Score",
    RS: "Reading Score"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table13 = Inputs.table(filterSe(data13, se), {
  select: false,
  format: { metric: x => x.replace(" (%)", ""), MS: x => `${d3.format(".3r")(x)}%`, RS: x => `${d3.format(".3r")(x)}%` },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    escs: "ESCS Index",
    level: "Proficiency Level",
    MS: "Math",
    RS: "Reading"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table3 = Inputs.table(filterSe(data3, se), {
  select: false,
  format: { MS: x => d3.format(".3r")(x), RS: x => d3.format(".3r")(x) },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    hisced: "Parents' Education",
    MS: "Math Score",
    RS: "Reading Score"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table14 = Inputs.table(filterSe(data14, se), {
  select: false,
  format: { metric: x => x.replace(" (%)", ""), MS: x => `${d3.format(".3r")(x)}%`, RS: x => `${d3.format(".3r")(x)}%` },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    hisced: "Parents' Education",
    level: "Proficiency Level",
    MS: "Math",
    RS: "Reading"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table4 = Inputs.table(filterSe(data4, se), {
  select: false,
  format: { MS: x => d3.format(".3r")(x), RS: x => d3.format(".3r")(x) },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    books: "No. of Books",
    MS: "Math Score",
    RS: "Reading Score"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
const table8 = Inputs.table(filterSe(data8, se), {
  select: false,
  format: { MS: x => d3.format(".3r")(x), RS: x => d3.format(".3r")(x) },
  header: {
    year: "Year",
    area: "Country",
    metric: "Measure",
    computer: "Computer Use",
    MS: "Math Score",
    RS: "Reading Score"
  },
  width: { area: 180 },
  layout: "auto",
  rows: 12
});
```
```js
function tableCaption() {
  let datasets = [ds1, ds2, ds13, ds3, ds14, ds4, ds8];

  document.querySelectorAll("table").forEach((table, index) => {
    if (table.firstElementChild?.tagName != "CAPTION") {
      let caption = document.createElement("caption");

      caption.textContent = datasets[index]?.meta?.label || "";
      table.prepend(caption);
    }
  });
  requestAnimationFrame(tableCaption);
};
```
```js
tableCaption();
```

<div class="card table-card">
    ${tableInputs1}
    ${table1}
</div>
<div class="card table-card">
    ${tableInputs2}
    ${table2}
</div>
<div class="card table-card">
    ${tableInputs13}
    ${table13}
</div>
<div class="card table-card">
    ${tableInputs3}
    ${table3}
</div>
<div class="card table-card">
    ${tableInputs14}
    ${table14}
</div>
<div class="card table-card">
    ${tableInputs4}
    ${table4}
</div>
<div class="card table-card">
    ${tableInputs8}
    ${table8}
</div>
