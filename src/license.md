# License
<span></span>
## Website

The source code and content of the website (excluding the datasets) are licensed under the **GNU General Public License v3.0 (GPL-3.0)**. 

You are free to:
- Use, modify, and distribute the website code as long as any derivative work is also licensed under GPL v3.

For more information, see the [LICENSE](https://github.com/frammenti/knowledge-sake/blob/main/LICENSE) file or visit the [GPL v3 License page](https://www.gnu.org/licenses/gpl-3.0.html).

## Datasets

The datasets located in the [`datasets/source/`](https://github.com/frammenti/knowledge-sake/tree/main/src/datasets/source) and [`datsets/mashup/`](https://github.com/frammenti/knowledge-sake/tree/main/src/datasets/mashup) directories are licensed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

You are free to:
- Share, copy, and redistribute the datasets in any medium or format.
- Adapt, remix, transform, and build upon the datasets for any purpose, even commercially, as long as you give appropriate credit to the creator.

For more details, see the [LICENSE](https://github.com/frammenti/knowledge-sake/blob/main/src/datasets/source/LICENSE) file or visit the [CC BY 4.0 License page](https://creativecommons.org/licenses/by/4.0/).

<div class="note" label="Note on GISCO Geographical Data" style="padding-bottom: 1.5rem;" markdown>

GISCO geographical data of administrative units, found in the <span style="white-space: nowrap;">[`datasets/map/`](https://github.com/frammenti/knowledge-sake/tree/main/src/datasets/map)</span> directory, are subject to additional terms. Specifically, these datasets may only be used for non-commercial purposes.

For more details, refer to the [GISCO licensing terms](https://ec.europa.eu/eurostat/web/gisco/geodata/administrative-units).

</div>

## Attribution

For attribution of the original datasets, please refer to the [metadata](../metadata/) page.

Knowledge for Knowledge's Sake is an informal research initiative. If you use our mashup datasets, please acknowledge the data source with the following copyright notice:

```
© Knowledge for Knowledge's Sake, CC BY 4.0.
```

## Tools

We would like to thank the creators of these tools, which were instrumental to the implementation of our project, for sharing the fruits of their efforts for free reuse. Each tool is used in compliance with its license.

- Website:
    - Observable Framework ([ISC](https://github.com/observablehq/framework/blob/HEAD/LICENSE))
    - fullPage ([GPL-v3](https://github.com/alvarotrigo/fullPage.js?tab=readme-ov-file#license))

- R libraries:
    - EDSurvey[^1] ([GPL-v2](https://cran.r-project.org/web/licenses/GPL-2))
    - dplyr[^2] ([MIT](https://cran.r-project.org/web/licenses/MIT))
    - sas7bdat[^3] ([GPL-v3](https://cran.r-project.org/web/licenses/GPL-3))
    - countrycode[^4] ([GPL-v3](https://github.com/vincentarelbundock/countrycode/blob/main/LICENSE))

- JavaScript libraries:
    - d3 ([ISC](https://github.com/d3/d3/blob/main/LICENSE))
    - Observable Plot ([ISC](https://github.com/observablehq/plot/blob/main/LICENSE))
    - topojson ([BSD-3-Clause](https://github.com/topojson/topojson/blob/master/LICENSE.md))

- Python libraries:
    - Pandas ([BSD 3-Clause](https://github.com/pandas-dev/pandas/blob/main/LICENSE))
    - requests ([Apache License 2.0](https://github.com/psf/requests/blob/main/LICENSE))

- RDF Diagram ([MIT](https://gitlab.com/infai/rdf-diagram-framework/-/blob/main/LICENSE))
- mapshaper ([MPL 2.0](https://github.com/mbloch/mapshaper/blob/master/LICENSE))


[^1]: Bailey P, Emad A, Huo H, Lee M, Liao Y, Lishinski A, Nguyen T, Xie Q, Yu J, Zhang T, Buehler E, Lee S, Webb B, Fink T (2024). _EdSurvey: Analysis of NCES Education Survey and Assessment Data_. R package version 4.0.7, <https://CRAN.R-project.org/package=EdSurvey>.

[^2]: Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_. R package version 1.1.4, <https://CRAN.R-project.org/package=dplyr>.

[^3]: Shotwell M (2024). _sas7bdat: sas7bdat Reverse Engineering Documentation_. R package version 0.8, <https://CRAN.R-project.org/package=sas7bdat>.

[^4]: Arel-Bundock V, Enevoldsen N, Yetman C (2018). “countrycode: An R package to convert country names and country codes.” _Journal of Open Source Software_, *3*(28), 848. <https://doi.org/10.21105/joss.00848>.


<style>
    ul p {
        margin-bottom: 0;
    }
</style>