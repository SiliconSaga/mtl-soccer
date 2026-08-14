# MTL Soccer — site

The website for **Mountain Top League soccer** (West Orange, NJ), live at **<https://soccer.mountaintopleague.com/>**. It's a plain, file-based Jekyll site — every page is a simple text file you (or your AI agent) can edit. No logins to a website builder, no waiting on anyone else.

> **The easiest way to change anything: just ask your agent.**
> *"Update the 4v4 substitution rule."* · *"Add a note about the Redwood field closure."* · *"Change the fall season dates."*
> Then look over the PR it opens — every PR automatically gets a **preview site link and a visual diff** so you can see exactly what changes before it goes live.

## How the site is laid out

| You want to change… | Edit this file |
|---|---|
| Home page | `index.md` |
| Rules (Little Kickers / 4v4 / 7v7-9v9) | `soccer/little-kickers.md`, `soccer/4v4.md`, `soccer/7v7-9v9.md` |
| Referee / Coach / Game Day guides | `soccer/referee-guide.md`, `soccer/coach-guide.md`, `soccer/game-day.md` |
| Field pages (maps, parking) | `soccer/fields/*.md` |
| How It Works | `soccer/how-it-works.md` |
| FAQ questions & answers | `faq.md` |
| Contact info | `contact.md` |
| Menu | `_data/nav.yml` |
| Age groups table | `_data/age_groups.yml` |
| The colors and look | `_sass/_base.scss` |
| Site title / description | `_config.yml` |
| Photos and images | `assets/images/` |
| Printable/social flyers | `flyers/` (exports regenerate automatically on PRs) |

Non-published material (coaching notes, rules archives) lives in `_docs/`.

## Previewing and publishing

- **Every PR gets a live preview**: a comment appears on the PR with a link to a full preview of the changed site, plus a visual diff against the current site. Review those, then merge — the live site updates within a couple of minutes.
- **Local preview** (optional): `bundle install` once, then `bundle exec jekyll serve` and open <http://localhost:4000/>.

## The bigger picture

This is one of the Mountain Top League's per-sport sub-sites — hockey lives in [mtl-hockey](https://github.com/SiliconSaga/mtl-hockey), and the [Mountain Top League site](https://mountaintopleague.com/) remains the league-wide primer covering the other sports. Architecture notes live in `_docs/plans/`. CI (deploy + PR preview + visual diff) is shared via [volundr](https://github.com/SiliconSaga/volundr).
