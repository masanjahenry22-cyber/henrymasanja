# Henry Mashen Masanja — Personal Website

A fast, static personal portfolio (single `index.html` + `images/` + `documents/`).
No build step — edit the HTML, `git push`, and GitHub Pages publishes it automatically.

Live site: **https://henrymasanja.com** (after DNS — see below)

---

## Project structure

```
Website/
├── index.html      # the whole site (HTML + CSS + JS in one file)
├── images/         # photos used on the site (clean names)
├── documents/      # CV, transcripts, certificates (PDFs)
├── CNAME           # custom domain for GitHub Pages
├── .nojekyll       # serve files as-is (no Jekyll processing)
├── .gitignore
└── README.md
```

## Editing

Open `index.html` — everything lives in that one file:
- **Text/sections**: plain HTML, edit in place.
- **Add a gallery photo**: drop the file in `images/`, copy a `.gallery-tile`
  block in `§ 06 Gallery`, point `data-full` + `<img src>` at it.
- **Add a document**: drop the PDF in `documents/`, copy a `.doc-card`
  block in `§ 07 Documents`, update the `href`.
- **Colors/theme**: the `:root` / `[data-theme="dark"]` CSS variables at the top.

Preview locally:
```bash
python -m http.server 5500    # open http://localhost:5500
```

---

## Hosting on GitHub Pages

### 1. Push the repo (one time)
```bash
gh repo create henrymasanja --public --source=. --remote=origin --push
# (or create the repo on github.com, then: git remote add origin ... && git push -u origin main)
```

### 2. Enable Pages from the main branch root
```bash
gh api -X POST repos/masanjahenry22-cyber/henrymasanja/pages \
  -f "source[branch]=main" -f "source[path]=/"
```
Your site goes live at `https://chanx-charitana.github.io/henrymasanja/`.

### 3. Custom domain (henrymasanja.com)
The `CNAME` file in this repo already sets the domain. At your registrar, add DNS:

```
# Apex (henrymasanja.com) -> GitHub Pages IPs
@   A   185.199.108.153
@   A   185.199.109.153
@   A   185.199.110.153
@   A   185.199.111.153

# www subdomain
www CNAME chanx-charitana.github.io.
```

### 4. Verify + enforce HTTPS
```bash
nslookup henrymasanja.com          # should list the 185.199.x.x IPs
curl -I https://henrymasanja.com   # HTTP/2 200 once the cert is issued
```
GitHub auto-issues a free SSL cert (can take a few minutes to an hour).

---

## Publishing updates (the everyday loop)

```bash
git add -A
git commit -m "update site"
git push
```
GitHub Pages rebuilds automatically within ~1 minute. That's the whole workflow.
