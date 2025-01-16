---
toc: false
sidebar: false
---


<div class="hero">
  <h1>Knowledge For Knowledge’s Sake</h1>
  <h2>What limits our opportunities for learning?</h2>
  <button class="find-out-btn" data-scroll-to="#data-driven-insights-into-achieving-self-realization-in-education-and-work">Find Out !</button>
</div>

# Data-driven insights into achieving self-realization in education and work

The project examines the impact of socio-cultural and economic inequalities on access to knowledge and personal growth.


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
  <a class="card" href="documentation">
    <h2>Documentation</h2>
    <p>Overview of the datasets, including legal, ethical, and technical aspects, as well as their sustainability.</p>
  </a>
</div>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('[data-scroll-to]').forEach(button => {
      button.addEventListener('click', (event) => {
        const targetSelector = button.getAttribute('data-scroll-to');
        const targetElement = document.querySelector(targetSelector);
        if (targetElement) {
          // Scroll to the target element
          targetElement.scrollIntoView({ behavior: 'smooth' });
          // Update the URL hash
          window.history.pushState(null, '', targetSelector);
        }
      });
    });
  });
</script>

<style>

nav {
  display: none !important;
}

.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-family: var(--sans-serif);
  text-wrap: balance;
  text-align: center;
  padding-bottom: 10rem;
  box-sizing: border-box;
  height: calc(100vh - calc(var(--observablehq-header-height) + 1.5rem + 2rem));
}

.hero h1 {
  margin: 1rem 0;
  padding: 1rem 0;
  max-width: none;
  font-size: 14vw;
  font-weight: 900;
  line-height: 1;
  background: linear-gradient(30deg, var(--theme-foreground-focus), currentColor);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero h2 {
  max-width: 34em;
  font-size: 20px;
  font-style: initial;
  font-weight: 500;
  line-height: 1.5;
  color: var(--theme-foreground-muted);
}

.find-out-btn {
  margin-top: 1rem;
  padding: 1rem 1.5rem;
  font-size: 16px;
  font-weight: 600;
  color: white;
  background-color: var(--theme-foreground-focus);
  border: none;
  border-radius: 30px;
  cursor: pointer;
}

.find-out-btn:hover {
  background-color: var(--theme-foreground);
}

@media (min-width: 640px) {
  .hero h1 {
    font-size: 90px;
  }
}

.grid-nav {
  margin: 20rem auto 5rem;
  grid-auto-rows: auto;
  gap: 40px;
  display: grid;
}

@container (min-width: 900px) {
  .grid-nav {
    gap: 70px;
    max-width: 800px;
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
}

.grid-nav a h2 {
  font: 24px/1.5 var(--serif);
  font-weight: 700;
  line-height: 1.5;
}

.grid-nav a {
  font: 17px/1.5 var(--serif);
  color: var(--theme-foreground);
  line-height: 1.5;
}

.grid-nav a:hover {
  border-color: var(--theme-foreground-focus);
  text-decoration: none;
}

.grid-nav a:hover h2 {
  color: var(--theme-foreground-focus);
}

</style>
