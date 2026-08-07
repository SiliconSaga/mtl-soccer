# MTL Site

Static website for the Mountain Top League — a volunteer youth sports
organization in West Orange, NJ.

Built with Jekyll and hosted on GitHub Pages.

## Editing

All content is in Markdown files. Edit directly on GitHub or clone locally.

- **Soccer rules** are in `soccer/`
- **Sport stubs** are in `baseball/`, `basketball/`, `hockey/`, `softball/`
- **Structured data** (age groups, sports list) is in `_data/`
- **Flyer kit** (printable/social flyers + base assets) is in `flyers/` — edit the HTML, then run `bash flyers/hockey-2026/export.sh` to regenerate the PDFs/PNGs in `exports/`
- **Non-published docs** (coaching notes, archives) are in `_docs/`

## Local Preview (optional)

```bash
bundle install
bundle exec jekyll serve
```

Then visit http://localhost:4000/mtl-site/
