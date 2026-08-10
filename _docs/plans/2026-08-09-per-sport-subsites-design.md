# Per-Sport Sub-Sites — Design (2026-08-09)

## Context

MTL's sports are organized by different volunteer crews who have historically bolted arbitrary extras onto a WordPress/TeamSnap umbrella site that carries little per-sport depth. The soccer sub-site (this repo) proved the alternative: a file-based Jekyll site a volunteer (or their agent) can own end to end. The hockey coordinator has asked for the same, and gdd-sandbox (SiliconSaga/gdd-sandbox) now provides the delivery vehicle: a chat-reachable scoped agent that turns a non-technical volunteer's request into a PR with a preview site and visual diff. ken-site (SiliconSaga/ken-site) is the working example of a sandbox-ready site: agent-friendly README, deploy + pr-preview CI, PR-gated publishing.

## Goals

- One repo per sport, each independently ownable by its volunteer crew and independently targetable by a gdd-sandbox container and a single-repo machine-account grant.
- The WordPress site remains the umbrella primer; sub-sites carry the depth.
- mtl-hockey live at soccer parity soon, to show the hockey coordinator.
- Every sub-site subdomain-ready (hockey.mountaintopleague.com etc.) with launch on github.io until DNS access materializes.

## Decisions

- **Per-sport repos, hockey first.** A single all-sports repo would collide with the sandbox's one-target-one-repo scoping and make concurrent volunteer PRs chaotic. New repo `SiliconSaga/mtl-hockey` now; this repo refits to a dedicated soccer sub-site second, renaming to `mtl-soccer` only on the owner's explicit go (the rename breaks siliconsaga.github.io/mtl-site/ URLs — GitHub Pages does not redirect).
- **Copy the theme now, extract later.** mtl-hockey copies soccer's layouts/_sass/nav pattern with a navy/ice palette drawn from the 2026–27 flyer. A shared mtl-theme repo is deliberately deferred until a third sport (or real drift pain) justifies it.
- **Subdomain-ready, github.io launch.** Baseurl-aware URL discipline (`{{ site.baseurl }}` / `relative_url` on every internal link, never bare root-relative paths), CNAME staged but inert; the future flip to a subdomain is one commit per repo (url + baseurl + CNAME together).
- **Sandbox-ready, sandbox later.** Both repos ship the trust surface the sandbox needs — branch protection on main (PR-only publishing), ken-site-style pr-preview CI (preview build + visual-diff comment), agent-friendly README. The actual container/Discord/machine-account provisioning for the hockey coordinator is phase 2, after they've seen the site.

## Topology

```text
WordPress (mountaintopleague.com)      — umbrella primer, per-sport pages link out to sub-sites
SiliconSaga/mtl-hockey                 — hockey sub-site  → future hockey.mountaintopleague.com
SiliconSaga/mtl-site                   — soccer sub-site  → future soccer.mountaintopleague.com (rename to mtl-soccer later, owner-gated)
SiliconSaga/volundr                    — org utility repo: reusable CI workflows (and future composite actions)
SiliconSaga/gdd-sandbox                — per-sport sandbox containers, one --target per repo (phase 2)
realm-siliconsaga ecosystem            — declares each sub-site and volundr so ws verbs and sandbox targeting resolve
```

## mtl-hockey structure and content (v1, soccer parity)

- Jekyll scaffold copied from this repo: `_layouts/` (default, page, rules, stub→dropped), `_includes/` (nav, footer, print-button, quick-ref), `_sass/` with palette swapped to flyer navy/ice (`#0A2D5E` family), `_data/nav.yml`, pretty permalinks, page-layout default.
- Pages:
  - **Home** — program overview + division cards (Mites 8U / Squirts 10U / Middle School with birth years, fees; TBD-badged where pricing is pending).
  - **Register** — the one-stop shop the coordinator asked for: per-division TeamSnap registration links (TBD placeholders until links land), rolling-signup framing so interest can be gauged for ice-time purchases.
  - **Rinks** — O'Connor Park (street hockey), Codey Arena (full ice), Mennen Arena (league games): the supplied map links, committed overview shots, parking/entry notes as known.
  - **How It Works / FAQ / Contact** — drafted from known program details with clearly marked placeholders where only the hockey crew can answer; contact is mountaintop.hockey@gmail.com.
  - **Flyers** — the flyer kit (flyers/assets/ + flyers/hockey-2026/) migrated from this repo after PR #1 merges, plus a downloads page linking the committed exports.
- The kit's relative `../assets/` paths survive the migration unchanged; the kit remains Jekyll-independent.

## Flyer framework (revised decision, 2026-08-09)

The owner chose to promote the flyer machinery to a shared framework immediately (more sites will want it) instead of merging the kit into this repo and migrating it: volundr gains `flyer-kit/` — the generalized export script (manifest-driven variants), parameterized `make-qr.sh`, canonical fonts + OFL licenses, an install step that seeds a site's `flyers/` (fonts vendored per-site so Pages serves previews) — plus a reusable `flyer-export.yml` workflow that regenerates a PR's committed exports in CI and pushes them back to the PR branch, so an agent or volunteer with no local browser can complete a flyer change alone; local `export.sh` runs stay first-class (volundr as sibling clone or `VOLUNDR_DIR`). Site repos carry only flyer content: HTML/CSS, assets, a `flyers.conf` manifest (whitespace-table format, deliberately bash-parseable with no YAML tooling required on volunteer machines), and thin caller stubs. Consequences: mtl-site PR #1 closes unmerged once the hockey flyer content lands in mtl-hockey directly (its branch is the harvest source), and the soccer refit no longer removes a `flyers/` tree — it never merges here.

## Shared wiring (both repos)

- **CI centralized in volundr:** ken-site's `deploy.yml` and `pr-preview.yml` are ported into `SiliconSaga/volundr` as reusable (`workflow_call`) workflows — jekyll-pages-deploy and pr-preview-visual-diff (the review surface a non-technical owner judges PRs by). Each site repo carries only a thin caller stub per workflow (GitHub requires the trigger stub in-repo; logic lives centrally). volundr gets the same branch protection as the sites — a central workflow edit affects every caller at once. Follow-ups recorded in volundr's README, not built here: migrating ken-site to callers; the planned Jules-review composite action.
- **CI trust model (stated deliberately):** callers and volundr live in the same org and volundr's main is branch-protected — callers reference `@main` as a centralization trade-off (SHA-pinning callers would reinstate the per-repo drift volundr exists to remove); revisit pinning if a repo outside the org ever calls these workflows. No custom secrets exist anywhere in this CI — jobs use only the ephemeral `GITHUB_TOKEN`, scoped by each caller's `permissions:` block. Preview jobs are write-by-design but only to `gh-pages/pr-preview/<pr>/` and PR comments (that preview+diff surface is the product); production deploys run only from push-to-main on branch-protected repos, which is the merge gate a human controls. Fork PRs: a fork-originated PR receives a read-only `GITHUB_TOKEN`, so its preview/diff jobs simply fail without side effects — safe by default, and consistent with the sandbox model's deliberate no-fork choice (scoped machine accounts on the same repo keep the review surface alive; see gdd-sandbox's README).
- **Branch protection on main:** changes land only via PR; this is what makes the sandbox's "agent can push branches but never publish" posture enforceable rather than promised.
- **Agent-friendly README** in ken-site's style: a "you want to change X → edit file Y" table, add-a-page recipe, preview/publish instructions.
- **CNAME staged inert** (documented value per repo, file added only at DNS flip time so github.io serving is unaffected).
- **Ecosystem declaration** in realm-siliconsaga for mtl-hockey (and the rename, when it happens) so `ws clone/test/cr` and sandbox `--target` resolve.

## mtl-soccer refit (second pass, this repo)

- Remove the four sport stub dirs (`baseball/ basketball/ hockey/ softball/`), stub layout, and stub entries in `_data/sports.yml`; keep a single "other MTL sports" link-out to the WordPress primer (and mtl-hockey once live). The README is refreshed in the same pass — stub references removed, replaced by the agent-friendly edit map from the shared wiring.
- Rebrand `_config.yml`/index as the dedicated soccer sub-site.
- (Flyer removal dropped: with the framework decision the kit never merges into this repo — PR #1 closes unmerged.)
- Port the shared wiring above.
- Prepare the `mtl-soccer` rename but execute it only on the owner's explicit go signal — nothing (baseurl, ecosystem name, README, Pages settings) flips early. When the go comes, the rename is one coordinated change: repo name + Pages settings + baseurl + README + ecosystem declaration together. Compatibility action for the old github.io project URL (GitHub redirects the repo, not the Pages path): recreate `mtl-site` as a tiny placeholder repo whose Pages site serves redirect pages (meta-refresh + canonical link) to the new URLs, and sweep known link inventory (WordPress, TeamSnap, prior emails) as part of the same change.

## Sequencing

1. Preamble: triage PR #1's pending bot reviews. (Superseded by the flyer-framework decision: PR #1 closes unmerged after the hockey flyer content lands in mtl-hockey; its branch is the harvest source.)
2. volundr: repo creation, the two reusable workflows ported from ken-site, branch protection, README with follow-ups (ken-site caller migration, Jules-review action), ecosystem declaration; then the flyer framework (flyer-kit/ + flyer-export.yml) as its own change.
3. mtl-hockey: repo creation, scaffold, content v1, wiring (caller stubs → volundr), then flyer content harvested from the PR #1 branch against the framework — shown to the hockey coordinator.
4. mtl-soccer refit: de-stub, rebrand, flyer removal, wiring (caller stubs → volundr); rename staged awaiting go.
5. Phase 2 (own spec): sandbox provisioning for the hockey coordinator (machine account, Discord, briefing).
6. Later: DNS flips per sub-site; ken-site migrates to volundr callers; Jules-review composite action lands in volundr; shared mtl-theme extraction when a third sport arrives.

## Risks and open items

- **Pages-URL break on rename** — user-gated, deliberately deferred; risk shrinks to zero once subdomains are live.
- **PR #1 is a harvest source, not a dependency** — with the framework decision nothing blocks on its merge; it closes unmerged once the hockey flyer content lands.
- **TeamSnap links, Mites fee, FAQ answers** — awaited from the hockey coordinator; all render as TBD badges until then.
- **Flyer content is a harvest, not a merge-then-move** — the PR #1 branch (never merged) is the extraction source for mtl-hockey's flyer content; the branch is deleted only after the owner confirms the harvest landed. No repo ever carries a second copy.

## Out of scope

- Sandbox container provisioning, Discord bot setup, machine accounts (phase 2 spec).
- Building the Jules-review action and migrating ken-site onto volundr callers (recorded follow-ups in volundr).
- DNS record changes and CNAME activation.
- WordPress content changes beyond eventually linking out to sub-sites.
- Sites for baseball/basketball/softball (the pattern is ready when their volunteers are).
