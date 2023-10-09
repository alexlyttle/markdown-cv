# Makefile
#
# Uses Pandoc to convert Markdown to HTML and PDF using the CV template
# 
# Run "make" to generate HTML and PDF files, or
# E.g. run "make main.html" to generate only the HTML file.
#
# Run "make clean" to remove all generated files.

SOURCE_DOCS := main.md
EXPORTED_DOCS=\
 $(SOURCE_DOCS:.md=.html) \
 $(SOURCE_DOCS:.md=.pdf)

TEMPLATE := templates/cv
DEFAULTS := defaults.yaml

HTML_OPTIONS=
PDF_OPTIONS=

all: $(EXPORTED_DOCS)

.PHONY: all clean

%.html: %.md
	pandoc --template $(TEMPLATE) --defaults $(DEFAULTS) $(HTML_OPTIONS) -o $@ $<

%.pdf: %.md
	pandoc --template $(TEMPLATE) --defaults $(DEFAULTS) $(PDF_OPTIONS) -o $@ $<

clean:
	- rm -f $(EXPORTED_DOCS)
