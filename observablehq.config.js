import MarkdownItFootnote from "markdown-it-footnote";

export default {
  markdownIt: (md) => md.use(MarkdownItFootnote),
  // The app’s title; used in the sidebar and webpage titles.
  title: "Introduction",

  // The pages and sections in the sidebar. If you don’t specify this option,
  // all pages will be listed in alphabetical order. Listing pages explicitly
  // lets you organize them into sections and have unlisted pages.
  pages: [
    {
      name: "Datasets",
      pages: [
        {name: "Secondary Education", path: "datasets/secondary-education/index"},
        {name: "University", path: "datasets/university/index"},
        {name: "Employment", path: "datasets/employment/index"},
        {name: "Research", path: "datasets/research/index"},
      ]
    },
    {
      name: "Mashups",
      pages: [
        {name: "Education and Career Fulfillment Atlas", path: "mashups/education-career-fulfillment-atlas"},
        {name: "Student Trajectories", path: "mashups/student-trajectories"},
        {name: "The STEM-Humanities Divide", path: "mashups/stem-humanities-divide"}
      ]
    },
    {
      name: "Documentation",
      path: "documentation",
      pages: [
      ]
    },
    {
      name: "Metadata",
      path: "metadata/index",
      pages: [
      ]
    },
    {
      name: "License",
      path: "license",
      pages: [
      ]
    }
  ],

  // Content to add to the head of the page, e.g. for a favicon:
  head: '<link rel="icon" href="sake.png" type="image/png" sizes="32x32">',

  // The path to the source root.
  root: "src",

  // Some additional configuration options and their defaults:
  theme: ["cotton", "near-midnight"],
  style: "css/custom-style.css",
  header: 
  `<style>
    #observablehq-header a[href] {
      color: inherit;
    }

    #observablehq-header a[target="_blank"] {
      display: flex;
      align-items: center;
      gap: 0.25rem;
      text-decoration: none;
    }

    #observablehq-header a[target="_blank"]:hover span {
      text-decoration: underline;
    }

    #observablehq-header a[target="_blank"]::after {
      content: "\\2197";
    }

    #observablehq-header a[target="_blank"]:not(:hover, :focus)::after {
      color: var(--theme-foreground-muted);
    }

    @media not (min-width: 768px) {
      .hide-if-small {
        display: none;
      }
    }
    </style>
      <a href="./" target="_self" rel="" style="display: flex; align-items: center;">
        <svg width="22" height="22" viewBox="0 0 581.75 813.84" fill="currentColor">
          <path d="M581.1,496.21c-12.06-127.38-74.02-190.97-136.92-261-49.79-55.03-70.65-76.16-70.65-112.45,0-22.88,12.46-40.42,31.92-65.54,13.96-16.73,25.77-27.85,37.55-41.58,5.82-6.7,1.54-15.64-6.76-15.64H145.5c-8.31,0-12.59,8.94-6.76,15.64,11.79,13.73,23.6,24.85,37.55,41.58,19.46,25.12,31.92,42.66,31.92,65.54,0,36.28-20.85,57.41-70.65,112.45C74.67,305.23,12.71,368.83.65,496.21c0,0-5.88,65.9,17.84,141.13,9.67,30.67,27.67,67,61.96,108.72,29.32,32.32,66.05,65.43,130.3,67.78h80.13s80.13,0,80.13,0c64.25-2.35,100.98-35.47,130.3-67.78,34.29-41.73,52.29-78.05,61.96-108.72,23.72-75.22,17.84-141.13,17.84-141.13Z"/>
        </svg>
      </a>
      <div style="display: flex; flex-grow: 1; justify-content: space-between; align-items: baseline;">
        <a href="./" target="_self" rel="">
          Knowledge<span class="hide-if-small"> for Knowledge</span>’s Sake
        </a>
        <span style="display: flex; align-items: baseline; gap: 0.5rem; font-size: 14px;">
          <a target="_blank" href="https://github.com/frammenti/knowledge-sake"><span>View source</span></a>
        </span>
    </div>`,
  footer: false,
  sidebar: true, // whether to show the sidebar
  // toc: true, // whether to show the table of contents
  // pager: true, // whether to show previous & next links in the footer
  // output: "dist", // path to the output root for build
  // search: true, // activate search
  // linkify: true, // convert URLs in Markdown to links
  typographer: true, // smart quotes and other typographic improvements
  // preserveExtension: false, // drop .html from URLs
  // preserveIndex: false, // drop /index from URLs
};
