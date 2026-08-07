# Hockey Flyer Kit — Design (2026-08-07)

## Context

Harold (MTL hockey coordinator) requested a flyer for the 2026–27 youth ice hockey season, supplying program details, three previous-season flyers, team photos, and rink overview shots. Flyers are distributed by email and on the MTL Instagram; the funnel is flyer → TeamSnap → sign-up. Pricing for Mites and the final registration link are still TBD — Harold will send finals later, so the flyer must be "plug and play" to update.

This is sub-project A of three. Sub-project B (hockey site content, soccer-style, one-stop shop with all division sign-up links — explicitly endorsed by Harold) and sub-project C (per-sport subdomains with a GitHub Pages site per sport, handed to coordinating volunteers) are deliberately out of scope here and get their own specs.

## Goals

- A combined 2026–27 hockey flyer covering Mites (8U), Squirts (10U), and Middle School, plus a Middle School-only variant and an Instagram-format variant.
- A cheap edit loop: when Harold's final pricing lands, updating is a two-line HTML edit plus one export command — runnable by a volunteer or a GDD agent responding to a group-chat request.
- Reusable base assets (crest logo, QR, cleaned photos, rink shots) that also feed the future hockey site.

## Decisions

- **Structure: standalone flyer kit** in `flyers/` inside mtl-site — plain HTML+CSS, no Jekyll coupling, so it survives the future per-sport repo split unchanged. Jekyll copies the folder through, so every variant gets a live preview URL at `siliconsaga.github.io/mtl-site/flyers/hockey-2026/`.
- **QR / register target: `https://mountaintopleague.com/hockey/`** (the existing WordPress page). Stable URL, zero DNS work; volunteers keep sign-up links current there. The printed QR never goes stale when TeamSnap links change.
- **Logo: best available copy** of the crest, sourced from the supplied previous flyers or the league's own published assets on mountaintopleague.com (per the approved brainstorm option "pull the cleanest logo from the previous flyers / mountaintopleague.com"), background transparent, committed as PNG. Upgradeable to vector later without changing consumers.
- **Fonts: free-licensed font files committed to the repo** so exports render identically on any machine — no CDN fetch at print/export time.

## File layout

```
components/mtl-site/flyers/
  assets/
    mtl-logo.png          transparent MTL crest, extracted from cleanest source
    qr-hockey.png         QR → mountaintopleague.com/hockey/, generated locally
    make-qr.sh            offline QR regeneration script
    team-combined.jpg     cleaned/cropped best-of-three supplied photos, for the combined flyer
    team-ms.jpg           cleaned/cropped Middle School team photo
    rink-oconnor.png      downsized overview, O'Connor Park (street hockey)
    rink-codey.png        downsized overview, Codey Arena (full ice)
    fonts/                committed free-licensed font files
  hockey-2026/
    flyer.css             shared: palette, print @page, variant sizing
    index.html            combined flyer, US-letter portrait
    middle-school.html    Middle School-only variant, US-letter portrait
    instagram.html        1080×1350 portrait for IG feed + email embeds
    export.sh             headless Edge/Chrome → PDF + PNG per variant
    exports/              committed PDF/PNG outputs for direct download
```

## Content (combined flyer)

- Header: MTL crest, "HOCKEY", "Registration Now Open!", "2026–27 Season".
- Mites (Birth years 2018 & younger / 8U): fee **TBD**, monthly payment options available, 20 MCYHL league games at Mennen Arena + MTL practices.
- Squirts (Birth years 2016–2017 / 10U): $100 in-house skills coaching at MTL House; Mennen league team option if there is enough interest.
- Middle School (Birth years 2012–2015, grades 6–8): $400, 10-game Montclair State Middle School league.
- Footer: QR code, "Register at mountaintopleague.com/hockey", "Questions: mountaintop.hockey@gmail.com".
- TBD values render with an unmissable draft-highlight style (yellow badge) so a draft can't be mistaken for final; the style is removed when finals arrive.

The Middle School variant carries only the Middle School block plus header/footer. The Instagram variant carries the combined content condensed for feed legibility.

## Visual direction

Match the most recent previous flyer: deep navy arena backdrop, bold white stencil "HOCKEY", gold "REGISTRATION NOW OPEN!", centered team photo, QR block right, red accent bar above a light footer strip. Palette is sampled from that flyer (navy / white / gold / light blue / red). Combined flyer uses the best of the three supplied team photos; the Middle School variant uses the MS team photo.

## Base asset handling

- Crest extracted from the cleanest supplied source (the 2024/25 flyer shows it large on white), background removed.
- QR generated once by a small script kept in the repo (offline generation, no external service), scan-tested at print size.
- Team photos cropped and color-cleaned; only photos MTL has already used publicly are included.
- Rink overview shots downsized to web-friendly copies for reuse on the future hockey site.
- **Privacy:** the raw `newrequest/` intake folder (contains Harold's email with personal addresses and original attachments) stays untracked — `newrequest/` is added to `.gitignore`. Only processed assets are committed.

## Export and verification

`export.sh` drives headless Edge/Chrome to produce, per letter variant, a print PDF (US-letter) plus a PNG, and for the Instagram variant a PNG only (it is not a print format), into `exports/`, which is committed so Harold can download finished files straight from GitHub. Verification before any CR: exports visually compared against the rendered HTML, QR scan-tested from a print-size render, and TBD badges confirmed present (or absent, once finals land).

## Delivery

Work happens on `feat/hockey-flyer-kit` in mtl-site → `ws commit` → `ws push` → `ws cr`, with the GitHub Pages preview URL in the CR body for Harold/Matt to review. Follow-up when Harold sends finals: edit the two TBD lines, re-run `export.sh`, commit, CR.

## Out of scope

- Hockey site content (sub-project B) — separate spec; will reuse `flyers/assets/`.
- Per-sport subdomains and repo split (sub-project C) — separate spec; the flyer kit is deliberately portable.
- Changes to the WordPress site or TeamSnap configuration.

## Open items

- Mites fee and any final program corrections — awaited from Harold; flyer ships as clearly-marked draft until then.
- Confirmation from Harold/Matt on which team photo they prefer front-and-center (default: best technical quality of the three).
