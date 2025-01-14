# Documentation

## Introduction

In this page you can find all the documentation about the project Knowledge for Knowledge's Sake. The aim of the project is to investigate how socio-cultural and economic inequalities influence individual access to knowledge and shape avenues for personal growth in STEM and Humanities fields. 

You can find all the scripts of our data in the [GitHub](https://github.com/frammenti/knowledge-sake) page of the project.



## Scenario

In order to accomplish our research case, we collected data from different sources and re-used it to create our own dataset. We aimed at re-using datasets free of cognitive biases, prejudices and discriminations, fair and reliable, legally valid, relevant, consistent and accurate. Due to the variety of institutional sources we used, this was not easy task. The findings of our investigation explore how socio-cultural and economic inequalities influence individual access to knowledge and shape opportunities for personal growth in STEM and Humanities fields, offering insights that we hope will contribute to public discourse.

## Tools

1. Website: Observable Framework, [ISC](https://github.com/observablehq/framework/blob/HEAD/LICENSE)

1. R libraries:
    1. EDSurvey[^1], GPL-2
    2. dplyr[^2], MIT
    3. sas7bdat[^3], GPL-3 [expanded from: GPL (≥ 2)]
    4. countrycode[^4], GPL-3

2. JavaScript libraries:
    1. d3.js, [ISC](https://github.com/d3/d3/blob/main/LICENSE)
    2. Observable Plot, [ISC](https://github.com/observablehq/plot/blob/main/LICENSE)


[^1]: Bailey P, Emad A, Huo H, Lee M, Liao Y, Lishinski A, Nguyen T, Xie Q, Yu J, Zhang T, Buehler E, Lee S, Webb B, Fink T (2024). _EdSurvey: Analysis of NCES Education Survey and Assessment Data_. R package version 4.0.7, <https://CRAN.R-project.org/package=EdSurvey>.

[^2]: Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_. R package version 1.1.4, <https://CRAN.R-project.org/package=dplyr>.

[^3]: Shotwell M (2024). _sas7bdat: sas7bdat Reverse Engineering Documentation_. R package version 0.8, <https://CRAN.R-project.org/package=sas7bdat>.

[^4]: Arel-Bundock V, Enevoldsen N, Yetman C (2018). “countrycode: An R package to convert country names and country codes.” _Journal of Open Source Software_, *3*(28), 848. <https://doi.org/10.21105/joss.00848>.

## Datasets

### Original Datasets

The datasets used to cover the economic and political aspects affecting emigration include the following data from the respective sources:

| Name | Source | Metadata | Privacy | Licence | Format |
| -------- | ------- | ------- | ------- | ------- | ------- |
| OECD PISA 2000-2022 Reports | [OECD](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html) | [Provided](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html#methodology) | [OECD Privacy Guidelines](https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188) | OECD, CC BY 4.0 | .sav |
| 2024 European Skills Index | [Cedefop](https://www.cedefop.europa.eu/en/projects/european-skills-index-esi) | | [Regulation (EU) 2018/1725](https://www.cedefop.europa.eu/en/content/personal-data-protection) | [CC BY 4.0](https://www.cedefop.europa.eu/en/news/cedefop-adopts-open-access-research-output-policy) | .xlsx |
| GERD by sector of performance and fields of R&D | [Eurostat](https://ec.europa.eu/eurostat/databrowser/product/page/RD_E_GERDSC) | [Provided](https://ec.europa.eu/eurostat/cache/metadata/en/rd_esms.htm) | [Regulation (EU) 2018/1725](https://commission.europa.eu/privacy-policy-websites-managed-european-commission_en) | CC BY 4.0 | .tsv |
| Distribution of male and female graduates in different fields of education, by education level and programme orientation | [Eurostat](https://ec.europa.eu/eurostat/databrowser/product/page/EDUC_UOE_GRAD10) | [Provided](https://ec.europa.eu/eurostat/cache/metadata/en/educ_uoe_enr_esms.htm) | [Regulation (EU) 2018/1725](https://commission.europa.eu/privacy-policy-websites-managed-european-commission_en) | CC BY 4.0 | .tsv |


### Mashed-up Dataset

## Preliminary Analysis

### Quality Analysis

### Legal Analysis

#### Legal issues

#### GDPR

Considering that the GDPR applies to both organisations which process personal data as part of the activities of one of their branches established in the EU and to organisations established outside the EU which offer goods/services (paid or for free) or monitor the behaviour of individuals in the EU, all the sources we used for collecting our dataset are concerned.
* OECD: https://www.oecd.org/content/dam/oecd/en/about/programmes/edu/pisa/publications/technical-standards/PISA_2025_Technical_Standards.pdf, https://www.oecd.org/en/about/data-protection.html, https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188
* Cedefop: Cedefop follows the provisions of Regulation (EU) 2018/1725 https://www.cedefop.europa.eu/en/content/personal-data-protection, which is equivalent to GDPR (Regulation (EU) 2016/679) for EU instutions themselves
* Eurostat: Similar to Cedefop, Eurostat follows the Regulation (EU) 2018/1725 as their privacy notice redirects to the [Privacy policy for websites managed by the European Commission](https://commission.europa.eu/privacy-policy-websites-managed-european-commission_en)

### Ethical Analysis

### Technical Analysis

## Sustainability

## Visualisations

## RDF Metadata

## Final Conclusions