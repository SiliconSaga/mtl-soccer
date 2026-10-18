# MTL Soccer — site

The website for **Mountain Top League soccer** (West Orange, NJ), live at **<https://soccer.mountaintopleague.com/>**. It's a plain, file-based Jekyll site — every page is a simple text file you (or your AI agent) can edit. No logins to a website builder, no waiting on anyone else.

> **The easiest way to change anything: just ask your agent.**
> *"Update the 4v4 substitution rule."* · *"Add a note about the Redwood field closure."* · *"Change the fall season dates."*
> Then look over the PR it opens — every PR automatically gets a **preview site link and a visual diff** so you can see exactly what changes before it goes live.

No agent handy? Every content page on the live site has a **Suggest an edit** button (on tablet-width screens and up) that opens the file behind that page in GitHub's editor — the change comes back as a PR for the league to review, same as above. The flyer previews are standalone print artifacts and don't carry it; edit those under `flyers/` directly.

## How the site is laid out

| You want to change… | Edit this file |
|---|---|
| Home page | `index.md` |
| **News posts** (announcements, social posts) | `_posts/` — one file per post, images in `assets/news/<post>/`; see [News posts](#news-posts) |
| Rules (Little Kickers / 4v4 / 7v7) | `soccer/little-kickers.md`, `soccer/4v4.md`, `soccer/7v7.md` |
| Referee / Coach / Game Day guides | `soccer/referee-guide.md`, `soccer/coach-guide.md`, `soccer/game-day.md` |
| Field pages (maps, parking) | `soccer/fields/*.md` |
| How It Works | `soccer/how-it-works.md` |
| FAQ questions & answers | `faq.md` |
| Contact info | `contact.md` |
| Menu | `_data/nav.yml` |
| The "Follow" box on News and posts | `_includes/follow.html` |
| Age groups table | `_data/age_groups.yml` |
| The Print / Suggest an edit buttons | `_includes/page-tools.html` (edit-link base in `_config.yml`) |
| The colors and look | `_sass/_base.scss` |
| Site title / description | `_config.yml` |
| Photos and images | `assets/images/` |
| Printable/social flyers | `flyers/` (exports regenerate automatically on PRs) |

Non-published material (coaching notes, rules archives) lives in `_docs/`.

## News posts

When a post goes out on Facebook or Instagram, keep it here too: *"Save today's post to the site news."* Each post is one file in `_posts/` named `YYYY-MM-DD-short-title.md`, with the post text as the body (links written as links, no hashtags) and this front matter:

| Field | Holds |
|---|---|
| `title`, `description` | Headline and one-line summary, shown in lists and feeds |
| `image`, `image_alt` | The main picture, usually the image that was posted |
| `downloads` | Other sizes, as a list of `label` and `file` |
| `featured_until` | Optional date; the league-wide site features the post until then |

Images made for one post go in `assets/news/<post file name>/`; a post about the season flyers points at `flyers/fall-2026/exports/` instead. Posts show on the News page and, once there is one, the home page, and publish two feeds: `/feed.xml` (Atom, for feed readers; the News page has one-click follow buttons) and `/news/feed.json` (JSON Feed, read by the league-wide site). The news pieces (`_layouts/post.html`, `_includes/post-list.html` and `follow.html`, `_sass/_news.scss`, `news.md`, `news/feed.json`) are the same files on every MTL sport site; change them on all of them together.

## Previewing and publishing

- **Every PR gets a live preview**: a comment appears on the PR with a link to a full preview of the changed site, plus a visual diff against the current site. Review those, then merge — the live site updates within a couple of minutes.
- **Local preview** (optional): `bundle install` once, then `bundle exec jekyll serve` and open <http://localhost:4000/>.

## The bigger picture

This is one of the Mountain Top League's per-sport sub-sites — hockey lives in [mtl-hockey](https://github.com/SiliconSaga/mtl-hockey), and the [Mountain Top League site](https://mountaintopleague.com/) remains the league-wide primer covering the other sports. Architecture notes live in `_docs/plans/`. CI (deploy + PR preview + visual diff) is shared via [volundr](https://github.com/SiliconSaga/volundr).
