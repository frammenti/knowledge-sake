# Documentation
<span></span>
## Introduction

In this page you can find all the documentation about the project Knowledge for Knowledge's Sake. The aim of the project is to investigate how socio-cultural and economic inequalities influence individual access to knowledge and shape avenues for personal growth in STEM and Humanities fields. 

You can find all the scripts of our data in the [GitHub](https://github.com/frammenti/knowledge-sake) page of the project.


## Scenario

In order to accomplish our research case, we collected data from different sources and re-used it to create our own dataset. We aimed at re-using datasets free of cognitive biases, prejudices and discriminations, fair and reliable, legally valid, relevant, consistent and accurate. Due to the variety of institutional sources we used, this was not easy task. The findings of our investigation explore how socio-cultural and economic inequalities influence individual access to knowledge and shape opportunities for personal growth in STEM and Humanities fields, offering insights that we hope will contribute to public discourse.

## Datasets

### Original Datasets

The datasets used to investigate how socio-cultural and economic inequalities influence individual access to knowledge include the following data from the respective sources:

| Name | Source | URI | Metadata | Privacy | Licence | Format |
| -------- | ------- | ------- | ------- | ------- | ------- | ------- |
| OECD PISA 2000-2022 Reports | [OECD](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html) | | [Provided](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html#methodology) | [OECD Privacy Guidelines](https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188) | [OECD, CC BY 4.0](https://www.oecd.org/en/about/terms-conditions.html) | .sav |
| World Bank Development Indicators | [WBG](https://datacatalog.worldbank.org/search/dataset/0037712/World-Development-Indicators) | [WDI_EXCEL.xlsx](https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045574/WDI_EXCEL_2024_12_16.zip?versionId=2025-01-15T18:08:40.1137708Z) | [Provided](https://datacatalogapi.worldbank.org/ddhxext/DatasetDownload?dataset_unique_id=0037712) |  [Data Privacy](https://www.worldbank.org/en/programs/accountability/data-privacy) | [CC BY 4.0](https://datacatalog.worldbank.org/public-licenses) | .csv .xlsx |
| New entrants by education level, programme orientation, sex and field of education | [Eurostat](https://ec.europa.eu/eurostat/web/products-datasets/-/educ_uoe_ent02) | [estat_educ_uoe_ent02_filtered_en.csv](https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/educ_uoe_ent02/A.NR.TOTAL+F01+F02+F03+F04+F05+F06+F07+F08+F09+F10.ED6.T.EU27_2020+EU28+BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+UK?format=SDMX-CSV&lang=en&label=label_only&startPeriod=2013) | [Provided](https://ec.europa.eu/eurostat/cache/metadata/en/rd_esms.htm) | [Regulation (EU) 2018/1725](https://commission.europa.eu/privacy-policy-websites-managed-european-commission_en) | [CC BY 4.0](https://ec.europa.eu/eurostat/help/copyright-notice) | .tsv .csv |



### Mashed-up Dataset

To effectively manage the integration of multiple datasets with varying licensing conditions, we strictly adhered to the **EU Open Data Guidelines**, ensuring legal, ethical, and technical compliance. Following these guidelines, we aimed to make our research data **Findable, Accessible, Interoperable, and Reusable (FAIR)** through a structured approach to **selection, curation, and publication**.

Each dataset was meticulously evaluated for **provenance, licensing, quality, and accuracy**, ensuring freedom from **cognitive biases** and full legal validity. All of the datasets used were already anonymized so we didn't have to to apply privacy-preserving techniques in order to mitigate re-identification risks. To enhance interoperability, we structured datasets according to **Linked Open Data (LOD)** principles, incorporating **DCAT_AP metadata, RDF assertions**, and released them under an open license.

Ethical considerations were a key focus, with proactive measures taken to eliminate **discrimination, cognitive bias, and unintended prejudices** in the dataset selection and processing stages. Additionally, to maximize transparency and accessibility, results were visualized in a human-readable format and published on a one-page website.

As such you can check out the [output.xml](link) file we created out of the mash-up.

## Quality Analysis

* **OECD**: The OECD ensures the quality of its PISA data through rigorous methodologies and robust sampling techniques. The data is collected, validated, and analyzed following the [OECD Privacy Guidelines](https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188). Content published from 1 July 2024 is released under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en) license, while content published before this date follows the [the OECD terms and conditions](https://www.oecd.org/en/about/terms-conditions.html). The credibility of PISA data is reinforced by its widespread use in education policy and research.
* **WBG**: The quality and integrity of the data produced by the World Bank Group is guaranteed by its **Development Data Group**, which adopts professional standards in the collection, compilation and dissemination of data. It should be noticed the World Bank’s effort in helping developing countries improving the efficiency of their national statistical systems, since most of the data come from the member countries’ systems. According to the [Data Access And Licensing](https://datacatalog.worldbank.org/public-licenses) page, the dataset is provided under a [CC BY 4.0](https://creativecommons.org/licenses/by/4.0) license, ensuring open access to reliable economic and development data.
* **Eurostat**: Eurostat maintains high-quality control over this dataset, ensuring compliance with **Regulation (EU) 2018/1725** to safeguard data privacy and integrity. The data is collected from national statistical agencies and undergoes Eurostat’s rigorous validation procedures. According to the [Copyright notice and free re-use of data](https://ec.europa.eu/eurostat/help/copyright-notice) the datasets provided by eurostat are licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0) which enables accessibility while maintaining transparency and methodological rigor.


## Legal Analysis

The data we collected for the purposes of our research derive from different sources and therefore are subject to different types of license, when specified. The datasets we used were either released under the [Creative Common License CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) or under the [the OECD terms and conditions](https://www.oecd.org/en/about/terms-conditions.html). These licences allows the user to share and adapt the material, as long as he/she gives appropriate credit, provides a link to the license, and indicates if changes were made. Moreover, the user cannot add additional restrictions.

* **OECD**:
    * Privacy: [OECD Privacy Guidelines](https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188).
    * License: According to the [terms and conditions](https://www.oecd.org/en/about/terms-conditions.html) datasets provided by OECD are licensed under OECD before 1 July 2024 and under CC BY 4.0 after 1 July 2024.
    * Purpose: The PISA database contains the full set of responses from individual students, school principals and parents. These files will be of use to statisticians and professional researchers who would like to undertake their own analysis of the PISA data.
* **WBG**:
    * Privacy: [Data Privacy](https://www.worldbank.org/en/programs/accountability/data-privacy)
    * License: [CC BY 4.0](https://datacatalog.worldbank.org/public-licenses)
    * Purpose: The World Development Indicators (WDI) is the primary World Bank collection of development indicators, compiled from officially-recognized international sources. It presents the most current and accurate global development data available, and includes national, regional and global estimates.
* **Eurostat**:
    * Privacy: Eurostat follows the [Regulation (EU) 2018/1725](https://commission.europa.eu/privacy-policy-websites-managed-european-commission_en)
    * License: [CC BY 4.0](https://ec.europa.eu/eurostat/help/copyright-notice)
    * Purpose: The dataset educ_uoe_ent02 holds the number of new entrants by education level, programme orientation, sex and field of education

## Ethical Analysis

How sustainable and bias-free are our data providers?

* **OECD**: The [OECD Privacy Guidelines](https://legalinstruments.oecd.org/en/instruments/OECD-LEGAL-0188) govern the ethical handling of data, ensuring privacy protection, transparency, and responsible data use. While the OECD provides open access to data, its [Terms and Conditions](https://www.oecd.org/en/about/terms-conditions.html) specify that some datasets may have third-party ownership or additional restrictions. Users must verify metadata for such limitations. The organization maintains high standards in data collection and dissemination, ensuring accuracy and neutrality in its reporting.
* **WBG**: The World Bank Group ensures ethical standards, overseen by the **Ethics and Business Conduct Department (EBC)**, in its data practices through the [Creative Common License CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). According to their [Terms of Use for Datasets](https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets), datasets are made publicly accessible with proper attribution, though some third-party data may have additional restrictions. The organization promotes transparency, but disclaims any warranty regarding the accuracy or utility of the data. Users are responsible for verifying data ownership and must not misrepresent the World Bank’s endorsement. Disputes over data use are handled through a defined mediation and arbitration process.
* **Eurostat**: Eurostat follows rigorous ethical and professional standards, ensuring that its statistical processes align with the [European Statistics Code of Practice](https://ec.europa.eu/eurostat/web/quality/european-quality-standards/european-statistics-code-of-practice). The organization prioritizes transparency, impartiality, and accuracy, carefully assessing the potential biases in national data sources. Additionally, Eurostat adheres to **Regulation (EU) 2018/1725**, ensuring data privacy and sustainability while maintaining high-quality, bias-free statistical reporting.

## Technical Analysis

* **OECD**:
    * Format: sav.
    * Metadata: OECD provide metadata that can be found using the following [link](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html#methodology).
    * URI: EdSurvey used to download the datasets.
    * Provenance: [PISA data and methodology](https://www.oecd.org/en/about/programmes/pisa/pisa-data.html)
* **WBG**:
    * Format: csv and xlsx.
    * Metadata: WBG provide a JSON file containing all the information from the dataset, the file can be downloaded using this [link](https://datacatalogapi.worldbank.org/ddhxext/DatasetDownload?dataset_unique_id=0037712), there is also metadata relative to Data Source and Last Updated Date directly inside the xlsx file.
    * URI: [WDI_EXCEL_2024_12_16.zip](https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045574/WDI_EXCEL_2024_12_16.zip?versionId=2025-01-15T18:08:40.1137708Z), [WDI_CSV_2024_12_16.zip](https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045575/WDI_CSV_2024_12_16.zip?versionId=2025-01-15T18:08:41.7545645Z)
    * Provenance: [World Development Indicators](https://datacatalog.worldbank.org/search/dataset/0037712/World-Development-Indicators)
* **Eurostat**:
    * Format: csv and xlsx
    * Metadata: [estat_educ_uoe_ent02](https://ec.europa.eu/eurostat/cache/metadata/en/educ_uoe_enr_esms.htm)
    * URI: [estat_educ_uoe_ent02](https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/educ_uoe_ent02/A.NR.TOTAL+F01+F02+F03+F04+F05+F06+F07+F08+F09+F10.ED6.T.EU27_2020+EU28+BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+UK?format=SDMX-CSV&lang=en&label=label_only&startPeriod=2013)
    * Provenance: [estat_educ_uoe_ent02](https://ec.europa.eu/eurostat/web/products-datasets/-/educ_uoe_ent02)

## Sustainability of the project

The source datasets used for this project are provided by Eurostat, OECD and The World Bank Group, which maintains them in their various respective databases. While the URIs in this project may eventually become obsolete, the data remains accessible through these institutions.

**Knowledge for Knowledge's Sake** is the **final project** developed for the *Open Access and Digital Ethics* course (a.y. 2024/2025) within the Digital Humanities and Digital Knowledge Master's Degree (University of Bologna). As such, it is **not actively maintained** and **will not be updated** in the future. However, the scripts used to process the data are available under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en) license and can be rerun with updated versions of the datasets.

## Visualisations

The visualizations for the source datasets are available on the [secondary-education](datasets/secondary-education), [university](datasets/university) and [employment](datasets/employment) pages. Additionally, the map visualization for the mashup can be found on the [education-career-fulfillment-atlas](datasets/education-career-fulfillment-atlas) page.

## RDF Metadata

We used [RDF Diagram Framework](https://gitlab.com/infai/rdf-diagram-framework) from The Institute for Applied Informatics (InfAI) to encode the metadata about all our data, including the original datasets and our mashed-up dataset. Click [here](link) to see the code on our GitHub project.