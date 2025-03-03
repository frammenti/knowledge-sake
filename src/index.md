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
        <polyline points="6 9 12 15 18 9" />
      </svg>
      </a>
    </div>
  </div>
  <div class="section fp-auto-height-responsive">

  <h1>Data-driven insights into achieving self-realization in education and work</h1>

  The project examines how socio-cultural and economic inequalities affect access to knowledge and opportunities for personal growth. Our aim is to provide an unbiased perspective on the challenges young Europeans face in reconciling their economic status with their aspirations and in finding their place in society.

  In this context, we critically engage with the [European Skills Index](https://www.cedefop.europa.eu/en/tools/european-skills-index) (ESI), a composite indicator developed by the European Centre for the Development of Vocational Training (Cedefop) to assess EU countries' performance in developing, activating, and matching their citizens' skills. While the ESI provides a valuable standpoint, its reliance on aggregated data may obscure important differences across specific fields, such as STEM and Humanities. By analyzing the index's underlying data sources, we seek to uncover a more nuanced understanding of the interrelation between academic paths and employment opportunities.

  Our perspective thus aims to “follow” the academic and professional trajectories of young Europeans in relation to the economic context, country by country. The analysis focuses on four key areas: **high school education**, **college and career choices**, **early adulthood employment situation**, and **national investment in research**, differentiated by field.

  Our project is rooted in the vision of the [fourth Sustainable Development Goal](https://www.globalgoals.org/goals/4-quality-education/) (SDG 4), which strives for inclusive, equitable, and quality education that empowers individuals throughout their lives. We address barriers to learning by focusing on target 4.3, advocating for equal access to higher education, and target 4.4, aspiring for everyone to gain the skills necessary for meaningful professional and economic participation.


  </div>
  <div class="section fp-auto-height-responsive">
    <div class="grid-nav">
      <a class="card" href="datasets/secondary-education">
        <h2>Source datasets</h2>
        <p>Exploratory visualization and preprocessing of the original datasets.</p>
      </a>
      <a class="card" href="datasets/education-career-fulfillment-atlas">
        <h2>Mash-up datasets</h2>
        <p>All stages of data curation, from aims to outcomes.</p>
      </a>
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

@property --gradTop {
  syntax: '<percentage>';
  inherits: false;
  initial-value: 50%;
}

@property --gradSize {
  syntax: '<length>';
  inherits: false;
  initial-value: 2800px;
}

@property --gradBack {
  syntax: '<percentage>';
  inherits: false;
  initial-value: 45%;
}

body {
  max-width: unset;
  background: linear-gradient(to bottom, var(--theme-background) var(--gradBack), transparent calc(var(--gradBack) + 10%)),
              radial-gradient(ellipse var(--gradSize) 100% at left 50% top var(--gradTop) in hsl longer hue, var(--theme-background) 15%, var(--theme-foreground-focus-alt));
  transition: --gradTop 1s, --gradSize 1s, --gradBack 1s;
}

#observablehq-center {
  max-width: var(--observablehq-max-width);
  margin: 0 auto;
  padding: 0 2rem;
  box-sizing: border-box;
}

.fp-viewing-introduction {
  --gradTop: 30%;
}

.fp-viewing-navigation {
  --gradTop: 0%;
  --gradBack: 7%;
  --gradSize: calc(max(1400px, 100%));
}

#observablehq-header ~ #observablehq-main {
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

.section:nth-child(2) {
  display: flex;
  align-items: start;
  justify-items: center;
  justify-content: space-around;
  flex-flow: column;
}

.section:nth-child(2) .fp-overflow {
  padding: 4rem 0;
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

@property --gradTitle {
  syntax: '<length>';
  inherits: false;
  initial-value: 500px;
}


.hero h1 {
  margin: 1rem 0;
  padding: 1rem 0;
  max-width: none;
  font-size: 13vw;
  font-weight: 900;
  line-height: 1;
  background: radial-gradient(var(--gradTitle) var(--gradTitle) ellipse at left 50% bottom -200% in oklab, var(--theme-foreground-focus), var(--theme-title-focus));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: --gradTitle ease 1s;
}

.hero h1:hover, .hero h1:focus {
  --gradTitle: 1500px;
}

stop {
    transition: all 3s ease;
}

svg:hover stop:nth-child(1) {
  offset: 100%;
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
  cursor: pointer;
  transition: transform 0.5s ease-in-out;
}

.scroll-arrow:hover {
  transform: translateY(5px);
}

.scroll-arrow svg {
  width: 100%;
  height: 100%;
  fill: none;
  stroke: var(--theme-foreground-muted);
  stroke-width: 0.3;
  transition: stroke 0.3s ease-in-out;
}

.scroll-arrow:hover svg {
  stroke: var(--theme-foreground-alt);
}



.grid-nav {
  grid-auto-rows: auto;
  gap: 40px;
  display: grid;
  margin-bottom: 3rem;
}

@container (min-width: 900px) {
  .grid-nav {
    gap: 20px;
    max-width: 800px;
    max-height: 400px;
  }

  .section:nth-child(3) .fp-overflow {
  display: flex;
  align-items: center;
  }
}

@container (min-width: 720px) {
  .grid-nav {
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: 1fr 1fr;
  }
}


.grid-nav a {
  display: flex;
  flex-direction: column;
  border: 1px solid var(--theme-foreground-fainter);
  border-radius: 12px;
  padding: 24px;
  line-height: 1rem;
  text-decoration: none !important;
  align-items: start;
  margin: 0;
  font: 16px/1.5 var(--sans-serif);
  color: var(--theme-foreground-alt);
  border-radius: 20px;
  transition: all 0.3s ease, border-color 0.3s ease;
  background-color: var(--theme-background-tra1);
  backdrop-filter: blur(10px);
  overflow-wrap: break-word;
  text-wrap: balance;
}

.grid-nav a h2 {
  font: 16px/24px var(--sans-serif);
  font-weight: 600;
  transition: color 0.3s ease;
}

.grid-nav p {
  padding-top: 8px;
  line-height: 24px;
  font-size: 14px;
  margin: 0 !important;
}

.grid-nav a:hover {
  border-color: var(--theme-foreground-focus);
  text-decoration: none;
  background-color: var(--theme-background-tra2);
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
  background: var(--theme-foreground-alt);
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
  bottom: 3rem;
  left: -20%;
  color: var(--theme-foreground-alt);
  font: 14px/1.25 var(--sans-serif);
  background-color: var(--theme-background-tra2);
  box-sizing: content-box;
  backdrop-filter: blur(10px);
  width: 100%;
  padding: 1rem 5rem 1rem;
}

.fp-watermark a {
  color: var(--theme-foreground-alt);
}

.fp-watermark a:hover {
  color: var(--theme-foreground);
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
  left: 0;
  right: 0;
  box-sizing: border-box;
 text-align: end;

  }

}

</style>