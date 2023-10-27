"""update_pubs.py - Update publication list from the NASA ADS database.

Copyright (c) 2023 Alex Lyttle

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
import os, json, ads

# Set constants
QUERY = {
    # "orcid": "0000-0000-0000-0000",  # set this to your ORCID
    "author": "Payne-Gaposchkin, Cecilia",  # set this to your name if needed
    "q": "year:1923-1980",  # set this to any additional query details
}
SORT = "citation_count"  # choose what to sort by
ROWS = 25  # max. number of rows to return from ADS query

# File paths
ABBR_PATH = "data/aas_macros.json"  # path to AAS macros
PUB_DIR = "publications"  # path to publication directory
DATA_DIR = "data"  # path to data directory
METRICS_FILE = "metrics.json"  # path to metrics file output

# Set publication categories
# The following relates the category to the ADS doctypes
DOCTYPE = {
    "refereed": ["article"],
    "conference": ["inproceedings"],
}

# Set bibtex replacements
# These are items that may not be parsed correctly by the ADS API
# The key is the old string, the value is the new string
BIBTEX_REPLACEMENTS = {
    "\\'\\i": "\\'i",
}

def get_bibtex(bibcodes: list) -> str:
    exp = ads.ExportQuery(bibcodes, "bibtex")
    return exp.execute()

def get_metrics(bibcodes: list) -> dict:
    metrics_query = ads.MetricsQuery(bibcodes)
    return metrics_query.execute()

def clean_bibtex(bibtex: str) -> str:
    for old, new in BIBTEX_REPLACEMENTS.items():
        bibtex = bibtex.replace(old, new)
    return bibtex

def expand_journal_abbr(bibtex: str, abbreviations: dict) -> str:
    for key, value in abbreviations.items():
        bibtex = bibtex.replace(f"journal = {{\\{key}}}", f"journal = {{{value}}}")
    return bibtex

def write_bibtex(filename: str, bibtex: str) -> None:
    with open(filename, "w") as file:
        file.write(bibtex)

def write_by_category(publications: list, category: str, abbreviations: dict) -> None:
    """Write publications to file by category."""
    if category not in DOCTYPE:
        raise ValueError(f"Category {category!r} not in {list(DOCTYPE)!r}")
    bibcodes = [pub.bibcode for pub in publications if pub.doctype in DOCTYPE[category]]
    bibtex = get_bibtex(bibcodes)
    bibtex = expand_journal_abbr(bibtex, abbreviations)
    bibtex = clean_bibtex(bibtex)
    filename = os.path.join(PUB_DIR, f"{category}.bib")
    write_bibtex(filename, bibtex)

def write_metrics(metrics: dict) -> None:
    filename = os.path.join(DATA_DIR, METRICS_FILE)
    with open(filename, "w") as file:
        file.write(json.dumps(metrics, indent=2))

def main() -> None:
    # Check publication directory exists
    if not os.path.isdir(PUB_DIR):
        os.makedirs(PUB_DIR)

    # Load AAS macros
    with open(ABBR_PATH) as file:
        # Add some security checks if needed
        abbreviations = json.loads(file.read())
    
    search_query = ads.SearchQuery(
        fl=["bibcode", "doctype"], 
        sort=SORT,
        rows=ROWS,
        **QUERY
    )
    publications = [row for row in search_query]

    # write all publications to files by category
    for category in DOCTYPE:
        write_by_category(publications, category, abbreviations)

    bibcodes = [pub.bibcode for pub in publications]
    metrics = get_metrics(bibcodes)
    write_metrics(metrics)

if __name__ == "__main__":
    main()
