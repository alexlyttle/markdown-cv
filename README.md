# markdown-cv

Markdown CV or resumé template with pandoc. Edit `main.md` with your CV content. Edit `meta.yaml` to configure personal details.

To compile, run the `Makefile`,

```bash
make clean; make
```

This uses pandoc to produce `main.pdf` and `main.html` with default options configured in `defaults.yaml`.

# Configuration

## Document Metadata

Use the `meta.yaml` file to configure your CV and personal details. Here we list the defaults.

### Personal Information

```yaml
title: Firstname M. Lastname, PhD
subtitle: Postdoctoral Research Fellow
author: Firstname Lastname
date: '2023-06-05'
location: City, Country
phone: '+44 1234 567 890'  # be careful sharing this online
email: local@domain.com    # be careful sharing this online
website: domain.com
lang: en-GB
```

### Publications

Default options for the bibliography using the `multibib` filter. You can specify as many `.bib` files as you like. These can then be printed by putting in your markdown file, e.g.

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

The `nocite` option lists citation keys for papers you wish to print in the bibliography without citing in text. For a CV, you may want to cite everything.

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

You can use `scripts/update_pubs.py` to update the publication lists. This outputs the `.bib` files in the `publications` directory and the `metrics.json` file in the `data` directory. This can be configured at the top of the file.

### Constants

```python
# Set constants
QUERY = {
    # "orcid": "0000-0000-0000-0000",  # set this to your ORCID
    "author": "Payne-Gaposchkin, Cecilia",  # set this to your name
    "q": "year:1923-1980",  # set this to any additional query details
}
SORT = "citation_count"  # sort by citation count
ROWS = 25  # max. number of rows to return from ADS query
```

### File Paths

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
