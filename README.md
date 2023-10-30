# markdown-cv

Markdown CV or resumé template with pandoc. Edit `main.md` with your CV content. Edit `meta.yaml` to configure personal details.

To compile, run the `Makefile`,

```bash
make clean; make
```

This uses pandoc to produce `main.pdf` and `main.html` with default pandoc options configured in `defaults.yaml`.

## Document Metadata

Use the `meta.yaml` file to configure your CV and personal details. Here we list the defaults.

### Personal Information

Here are some example personal details. As with all personal information, consider what you are comfortable sharing online if your CV is public.

```yaml
title: Firstname M. Lastname, PhD
subtitle: Postdoctoral Research Fellow
author: Firstname Lastname
date: '2023-06-05'
location: City, Country
phone: '+44 1234 567 890'
email: local@domain.com
website: domain.com
lang: en-GB
```

### Publications

Default options for the bibliography using the `filters/multibib.lua` filter. You can specify as many `.bib` files as you like. These can then be printed by putting in your markdown file, e.g.

```markdown
::: {#refs-refereed}
:::
```

Then, you must specify the corresponding `.bib` file in the metadata.

```yaml
bibliography:
  refereed: publications/refereed.bib
  conference: publications/conference.bib
csl: cv.csl  # citation style language file
link-citations: true
nocite: |
  @*
```

The `nocite` option lists citation keys for papers you wish to print in the bibliography without citing in text. To cite all entries, use `@*`. Otherwise, list the citation keys for the entries you want to appear in the bibliography.

If you do not want to split bibliographies, you can just pass one file. For example,

```yaml
bibliography: publications/refereed.bib
```

Then, place the bibliography in `main.md` like so:

```markdown
::: {#refs}
:::
```

### Highlight Authors

The `filters/highlight-authors.lua` filter lets you specify author names to highlight as they appear in the bibliography. You can list the authors with the `highlightauthors` option. By default, the authors listed are made bold. You can change this with the `highlighttype` option.

For example, we want to highlight Celia Payne-Gaposchkin. We list all ways we expect this name to appear in the bibliography.

```yaml
# Highlight the following authors in the bibliography
highlightauthors:
  - Payne, C.
  - Payne, C. H.
  - Payne-Gaposchkin, C.
  - Payne-Gaposchkin, C. H.
# highlighttype: bold  # choose from bold (default), italic, underline, or smallcaps
```

### Publication Metrics

The `filters/ads-metrics.lua` filter lets you specify a `json` file from the NASA ADS Metrics API. You can request this file using the `update_pubs.py` script (see [below](#update-publications)). Then, you can use the following placeholders in `main.md` to reference particular metrics.

Specify the path to the `json` file using the `metrics` option. For example,

```yaml
# ADS metrics
metrics: data/metrics.json
```

Here is an example of referencing the metrics in text:

```markdown
Total papers: {{papers}}; total citations {{citations}}; total citing papers: {{citing_papers}}; h-index: {{h_index}}; reads: {{reads}}; downloads {{downloads}}.
```

It will render something like this:

> Total papers: 25; total citations 823; total citing papers: 781; h-index: 17; reads: 12874; downloads 6086.

The numbers are pulled from `data/metrics.json`.

For each metric, you can add `_ref` to get the corresponding metric considering only refereed sources. For example:

```markdown
Total refereed papers: {{papers_ref}}
```

Renders as:

> Total refereed papers: 15

### HTML

Default options specific to HTML and CSS.

```yaml
html:
  fontsize: 12pt
  mainfont: \'Noto Sans\', sans-serif
  maxwidth: 45em                       # max width of body text
  fontcolor: '#1a1a1a'
  backgroundcolor: '#fdfdfd'
  linkcolor: '#0000ff'
  margin-left: 50px
  margin-right: 50px
  margin-top: 50px
  margin-bottom: 50px
  monofont: \'Noto Sans Mono\', monospace
  monobackgroundcolor:
  headingcolor: '#1a1a1a'
```

### LaTeX

Default options specific to LaTeX for compiling the PDF.

```yaml
latex:
  fontsize: 10pt
  fontfamily: noto                       # global font family package name (see https://tug.org/FontCatalogue/)
  fontfamilyoptions: sfdefault           # font family options (e.g. sfdefault for sans-serif)
  fontenc: T1
  papersize: a4
  classoptions:
  geometryoptions: 
    - margin=1in
  pagestyle: fancy
  secnumdepth: 5                       # depth of numbering if numbering sections
  linkcolor:
    model: named                       # color model, e.g. named, RGB, HTML, etc. (see xcolor package)
    spec: Blue                         # color specification, e.g. Blue, '0, 0, 255', 0000ff etc.
  hidelinks:                           # hide links in the document (no colors or borders)
  links-as-notes:                      # links in footnotes, doesn't work currently
  urlstyle: same
  hyperrefoptions:
  indent:                              # indent paragraphs instead of vertical space
  block-headings:
  biblatexoptions:
  natbiboptions:
  biblio-style:
  microtypeoptions:
```

## Pandoc Defaults

The `defaults.yaml` file configures default options for the `pandoc` command.

```yaml
filters: 
  - extensions/multibib/multibib.lua
citeproc: true  # process citations
metadata-files:
  - meta.yaml
pdf-engine: pdflatex  # changing to xelatex or lualatex not tested
```

## Update Publications

You can use `update_pubs.py` to update the publication lists. This outputs the `.bib` files in the `publications` directory and the `metrics.json` file in the `data` directory.

The script requires Python 3.7 or above and the NASA ADS Python API. Go [here](https://ads.readthedocs.io/en/latest/#getting-started) for instructions on installing the ADS Python package and acquiring a NASA ADS API token.

Edit the variables at the top of `update_pubs.py` (see below) then run the script:

```bash
python update_pubs.py
```

### Query

Set arguments for the search query. If you have an up-to-date ORCID then this is the easiest way to ensure the search results match your publications. Otherwise, specify your name and additional details to find your papers. This example is for the famous astronomer Cecilia Payne-Gaposchkin:

```python
QUERY = {
    # "orcid": "0000-0000-0000-0000",  # set this to your ORCID
    "author": "Payne-Gaposchkin, Cecilia, H.",  # set this to your name
    "q": "year:1923-1980",  # set this to any additional query details
}
SORT = "citation_count"  # sort by citation count
ROWS = 25  # max. number of rows to return from ADS query
```

Here we sort by citation count then choose the first 25 rows of the search result.

### File Paths

If you wish to export files elsewhere then change these variables.

```python
# File paths
ABBR_PATH = "data/aas_macros.json"  # path to AAS macros
PUB_DIR = "publications"  # path to publication directory
DATA_DIR = "data"  # path to data directory
METRICS_FILE = "metrics.json"  # path to metrics file output
```

### Document Types

This dictionary controls the name of each `.bib` file and the document types which will be saved to them.

```python
# Set publication categories
# The following relates the category to the ADS doctypes
DOCTYPE = {
    "refereed": ["article"],
    "conference": ["inproceedings"],
}
```

### Bibtex Parsing

Some errors may be thrown if the bibtex file is not parsed by `pandoc`. You can set strings to be replaced before the file is saved using the following `dict`.

```python
# Set bibtex replacements
# These are items that may not be parsed correctly by the ADS API
# The key is the old string, the value is the new string
BIBTEX_REPLACEMENTS = {
    "\\'\\i": "\\'i",
}
```

# Credits

- Adapted default pandoc template files
- Uses [pandoc-ext/multibib](https://github.com/pandoc-ext/multibib)
- Adapted [APA (CV)](http://www.zotero.org/styles/apa-cv) CSL file
- Uses icons from [FontAwesome](https://fontawesome.com/)
