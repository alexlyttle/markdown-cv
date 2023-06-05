# markdown-cv

Markdown CV or resumé template with pandoc

To compile, run the following commands where the order of the markdown files represents the order in the CV.

```bash
# HTML
pandoc --template templates/cv main.md meta.yaml -o main.html
# PDF
pandoc --template templates/cv main.md meta.yaml -o main.pdf
# DOCX - no template available
pandoc main.md meta.yaml -o main.docx
```

# Credits

- Adapted pandoc template files
- Icon set from Google
