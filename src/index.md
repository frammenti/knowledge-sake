---
toc: false
sidebar: false
---

```js
import fullpage from "fullpage.js";

requestAnimationFrame(() => {
  new fullpage('#fullpage', {
    anchors: ['knowledge-for-knowledge-s-sake', 'introduction', 'navigation'],
    autoScrolling: true,
    navigation: true,
    navigationPosition: 'right',
    controlArrows: false,
    verticalCentered: true,
    animateAnchor: false,
  });

});
```

<div id="fullpage">
  <div class="section">
    <div class="hero">
      <h1>Knowledge For Knowledge’s Sake</h1>
      <h2>What limits our opportunities for learning?</h2>
      <a href="#introduction" class="scroll-arrow">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="6 8 12 8">
        <defs>
          <linearGradient id="gradient">
            <stop offset="0%" stop-color="currentColor" />
            <stop offset="50%" stop-color="currentColor" />
            <stop offset="100%" stop-color="currentColor" />
          </linearGradient>
        </defs>
        <polyline points="6 9 12 15 18 9" stroke="url(#gradient)" />
      </svg>
      </a>
    </div>
  </div>
  <div class="section" markdown>

  <h1>Data-driven insights into achieving self-realization in education and work</h1>

  The project examines how socio-cultural and economic inequalities affect access to knowledge and opportunities for personal growth. Our aim is to provide an unbiased perspective on the challenges young Europeans face in reconciling their economic status with their aspirations and in finding their place in society.

  In this context, we critically engage with the [European Skills Index](https://www.cedefop.europa.eu/en/tools/european-skills-index) (ESI), a composite indicator developed by the European Centre for the Development of Vocational Training (Cedefop) to assess EU countries' performance in developing, activating, and matching their citizens' skills. While the ESI provides a valuable standpoint, its reliance on aggregated data may obscure important differences across specific fields, such as STEM and Humanities. By analyzing the index's underlying data sources, we seek to uncover a more nuanced understanding of the interrelation between academic paths and employment opportunities.

  Our perspective thus aims to “follow” the academic and professional trajectories of young Europeans in relation to the economic context, country by country. The analysis focuses on four key areas: **high school education**, **college and career choices**, **early adulthood employment situation**, and **national investment in research**, differentiated by field.

  Our project is rooted in the vision of the [fourth Sustainable Development Goal](https://www.globalgoals.org/goals/4-quality-education/) (SDG 4), which strives for inclusive, equitable, and quality education that empowers individuals throughout their lives. We address barriers to learning by focusing on target 4.3, advocating for equal access to higher education, and target 4.4, aspiring for everyone to gain the skills necessary for meaningful professional and economic participation.


  </div>
  <div class="section fp-auto-height-responsive">
    <div class="grid-nav">
      <a class="card" href="datasets/secondary-education/index">
        <h2>Source datasets</h2>
        <p>Exploratory visualization and preprocessing of the original datasets.</p>
      </a>
      <a class="card" href="mashups/education-career-fulfillment-atlas">
        <h2>Mash-up datasets</h2>
        <p>All stages of data curation, from aims to outcomes.</p>
      </a>
      <hr>
      <a class="card" href="documentation">
        <h2>Documentation</h2>
        <p>Overview of the datasets, including legal, ethical, and technical aspects, as well as their sustainability.</p>
      </a>
      <a class="card" href="metadata/index">
        <h2>Metadata</h2>
        <p>Development of a DCAT_AP schema to describe the datasets and publish them as Linked Open Data.</p>
      </a>
      <a class="card" href="license">
        <h2>License</h2>
        <p>Description of the tools we used and the conditions for reusing our work.</p>
      </a>
    </div>
  </div>
  <div class="fp-watermark">
   Made with <a href="https://observablehq.com/framework/" rel="nofollow noopener" target="_blank">Observable</a> and
  <a href="https://alvarotrigo.com/fullPage/" rel="nofollow noopener" target="_blank">
   fullPage.js
  </a>
</div>
</div>


<style>

#observablehq-header ~ #observablehq-main {
  margin-top: 0;
}

#observablehq-center {
  margin-top: 0;
}

.fp-overflow {
  outline:none;
  margin-top: calc(var(--observablehq-header-height) + 1.5rem);
  padding: 2rem 0;
  box-sizing: border-box;
}

.section:first-child .fp-overflow {
  display: flex;
}

.section:nth-child(3) {
  justify-content: center;
}

nav {
  display: none !important;
}

.hero {
  display: flex;
  min-height: 85vh;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-family: var(--sans-serif);
  text-wrap: balance;
  text-align: center;
  box-sizing: border-box;
  justify-self: center;
}

@property --grad1 {
  syntax: '<color>';
  initial-value: var(--theme-foreground-focus);
  inherits: false;
}

@property --grad2 {
  syntax: '<color>';
  initial-value: currentColor;
  inherits: false;
}

.hero h1 {
  margin: 1rem 0;
  padding: 1rem 0;
  max-width: none;
  font-size: 13vw;
  font-weight: 900;
  line-height: 1;
  background: linear-gradient(30deg, var(--grad1), var(--grad2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: --grad1 1s, --grad2 1s;
  --grad1: var(--theme-foreground-focus);
  --grad2: var(--theme-foreground-alt);
}

.hero h1:hover {
  --grad1: var(--theme-foreground-focus);
  --grad2: var(--theme-foreground-focus);
}

stop {
    transition: 0.4s ease;
}

svg:hover stop:nth-child(2) {
    stop-color: var(--theme-foreground-focus);
}

.hero h2 {
  max-width: 34em;
  font-size: 20px;
  font-style: initial;
  font-weight: 500;
  line-height: 1.5;
  color: var(--theme-foreground-muted);
}

.scroll-arrow {
  margin-top: 5rem;
  width: 3rem;
  height: 3rem;
  text-decoration: none;
  color: currentColor !important;
  cursor: pointer;
  transition: transform 0.4s ease;
}

.scroll-arrow:hover {
  transform: translateY(5px);
}

.scroll-arrow svg {
  width: 100%;
  height: 100%;
  fill: none;
  stroke-width: 0.3;
}

.grid-nav {
  grid-auto-rows: auto;
  gap: 40px;
  display: grid;
  margin-bottom: 3rem;
}

@container (min-width: 900px) {
  .grid-nav {
    gap: 70px;
    max-width: 800px;
    max-height: 700px;
  }

  .section:nth-child(3) .fp-overflow {
  display: flex;
  align-items: center;
  }
}

@container (min-width: 720px) {
  .grid-nav {
    grid-template-columns: repeat(6, 1fr);
    grid-template-rows: 1fr auto 1fr;
  }

  .grid-nav hr {
    grid-column: 1 / 7;
  }

  .grid-nav a:nth-child(1) {
    grid-column: 2 / 4;
  }

  .grid-nav a:nth-child(2) {
    grid-column: 4 / 6;
  }

  .grid-nav a:nth-child(4) {
    grid-column: 1 / 3;
  }

  .grid-nav a:nth-child(5) {
    grid-column: 3 / 5;
  }

  .grid-nav a:nth-child(6) {
    grid-column: 5 / 7;
  }
}

.grid-nav hr {
  padding: 0;
  margin: 0;
}

.grid-nav a {
  display: flex;
  flex-direction: column;
  border: 1px solid var(--theme-foreground-fainter);
  border-radius: 8px;
  padding: 1.5rem 1.5rem 3rem;
  line-height: 1rem;
  text-decoration: none !important;
  align-items: start;
  margin: 0;
  font: 17px/1.5 var(--serif);
  color: var(--theme-foreground);
  line-height: 1.5;
  transition: color 0.3s ease, border-color 0.3s ease;
}

.grid-nav a h2 {
  font: 24px/1.5 var(--serif);
  font-weight: 700;
  line-height: 1.5;
  transition: color 0.3s ease;
}

.grid-nav a:hover {
  border-color: var(--theme-foreground-focus);
  text-decoration: none;
}

.grid-nav a:hover h2 {
  color: var(--theme-foreground-focus);
}

.fp-section {
    position: relative;
    box-sizing: border-box;
    height: 100%;
    display: flex;
}

#fp-nav {
    position: fixed;
    z-index: 100;
    top: 50%;
    opacity: 1;
    transform: translateY(-50%);
    -ms-transform: translateY(-50%);
    -webkit-transform: translate3d(0,-50%,0);
    pointer-events: none;
}

#fp-nav.fp-right {
    right: 17px;
}

#fp-nav.fp-left {
    left: 17px;
}

#fp-nav ul {
  margin: 0;
  padding: 0;
}

#fp-nav ul li {
  display: block;
  width: 14px;
  height: 13px;
  margin: 7px;
  position: relative;
}

#fp-nav ul li a {
    display: block;
    position: relative;
    z-index: 1;
    width: 100%;
    height: 100%;
    cursor: pointer;
    text-decoration: none;
    pointer-events: all;
}

#fp-nav ul li a.active span,
#fp-nav ul li:hover a.active span {
  height: 12px;
  width: 12px;
  margin: -6px 0 0 -6px;
  border-radius: 100%;
 }

#fp-nav ul li a span {
  border-radius: 50%;
  position: absolute;
  z-index: 1;
  height: 4px;
  width: 4px;
  border: 0;
  background: #333;
  left: 50%;
  top: 50%;
  margin: -2px 0 0 -2px;
  transition: all 0.1s ease-in-out;
}

#fp-nav ul li:hover a span {
  width: 10px;
  height: 10px;
  margin: -5px 0px 0px -5px;
}

.fp-auto-height.fp-section,
.fp-auto-height {
    height: auto !important;
}

.fp-responsive .fp-is-overflow.fp-section{
    height: auto !important;
}

.fp-is-overflow > .fp-overflow {
  overflow: visible;
}

.fp-is-overflow .fp-overflow.fp-auto-height-responsive,
.fp-auto-height-responsive > .fp-overflow {
    overflow-y: auto;
}

.fp-auto-height-responsive > .fp-overflow::-webkit-scrollbar {
  display: none;
}

.fp-auto-height-responsive > .fp-overflow {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.fp-responsive .fp-auto-height-responsive.fp-section,
.fp-responsive .fp-auto-height-responsive .fp-overflow {
    height: auto !important;
}

.fp-sr-only{
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

html.fp-enabled,
.fp-enabled body {
    overflow:hidden;
    -webkit-tap-highlight-color: rgba(0,0,0,0);
}

body:not(.fp-responsive) .fp-overflow{
    max-height: 100vh;
}

.fp-watermark {
  z-index: 9999999;
  position: relative;
  bottom: 3.5rem;
  color: var(--theme-foreground-fainter);
  font-family: var(--sans-serif);
  font-size: 14px;
  background-color: white;
  width: 100%;
  padding: 1.25rem 0 1.25rem;
}

.fp-watermark a {
  color: currentColor;
}


@media (min-width: 640px) {
  .hero h1 {
    font-size: 90px;
  }

  .scroll-arrow {
  width: 4rem;
  height: 4rem;
}

.fp-watermark {
  background-color: transparent;
  }

}

</style>