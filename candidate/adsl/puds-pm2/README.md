# PUDS × PM2 × DAiMAC — semantic integration candidate

Execution date: 2026-11-09. Reference to “yesterday” means 2026-11-08, not a backdated deployment.

This is a static frontend integration. It implements the six-section PUDS flow, PM2 registry surface and DAiMAC evidence boundary using local, explicitly labelled implementation fixtures. No client outcome, commercial metric, signed decision or live telemetry is invented. The historical 0.84/0.86 figures remain labelled estimates.

## Run

Requires Node.js 22+ for tests/build, and Python 3 for the optional local server. Runtime has no package dependencies.

```sh
npm test
npm run build
npm start
# Open http://127.0.0.1:4173/ on your own machine.
# Or open dist/puds-pm2-daimac.html directly without a server.
```

Browser tests require Python Playwright and Chromium. `tests/browser.py` uses `/usr/bin/chromium`, an in-memory standalone document, and local downloads; adjust the browser executable only to your installed path. It is not a hosted test. The environment used for this run blocks HTTP browser navigation and does not expose WebGL.

## Changes

- Shared primitive/semantic/component aliases: PUDS paper/teal and PM2 dark/phosphor.
- Canonical PUDS, PM2 and DAiMAC identifiers preserved; legacy namespace prefix checker retained separately from strict identifier validation.
- Hero uses stable outer character slots and transforms only inner characters. Zero-distance and outside-radius cases are bounded. Pointer work is frame-coalesced and motion is disabled for reduced motion, touch, explicit opt-out, hidden documents and blur. Resize and font changes refresh measurements.
- Project index has keyboard-native filter buttons and announced result counts.
- Case-study rail has keyboard navigation, previous/next, list mode, mobile vertical layout and safe text rendering. Missing/invalid cases are visible in quarantine rather than silently treated as valid.
- Service selection updates a local brief generator. The CTA produces a real local JSON download, not a fake booking or external submission.
- Registry exposes contract details without confusing runtime state, specification, implementation, risk and acceptance.
- Validators reject nulls, missing/blank fields, invalid types, unsupported enums, duplicate identifiers and unsafe routes.
- Client-side validation NEVER authorizes production. Missing evidence remains incomplete, failed evidence freezes, valid evidence can only establish local eligibility.
- Optional WebGL1 dither study has a static CSS fallback. It is not physically based refraction.

## Executed evidence

112/112 Node contract tests passed. 41/41 Chromium interaction/layout/accessibility-smoke checks passed. No JavaScript exceptions and no specimen network requests were observed. Viewport widths tested: 320, 390, 768, 1024 and 1440 pixels. A 200% root-text-size check passed. These checks do not constitute a complete WCAG audit or real-device verification.

The initial signed-zero unit failure was fixed. The initial browser outline check used mouse modality; the test now establishes keyboard modality explicitly. WebGL unavailability is reported as NOT_PERFORMED for compilation; only the fallback behavior passed. Original failed-run receipts are retained in the archive.

The build generates `evidence/source-manifest.json` with SHA-256 digests. Browser evidence binds the standalone HTML digest. Test receipts are tool-observed local execution, not independent assurance.

## Remaining gates

- Actual WebGL compilation/link/draw on a supported target.
- Real Safari/iOS/Firefox and assistive-technology checks; full contrast/accessibility review.
- Interaction-load performance profiling on target devices (idle frame timing is not a smoothness acceptance test).
- Reviewer acceptance and an explicit version/scope-bound release decision.
- A reachable authorized hosting target and hosted smoke verification.
- OIDC/JWKS, tenant isolation and RLS for any future live-data attachment. None is attached here.

## Integration boundary

Additive subdirectory under `candidate/adsl/puds-pm2/` on the existing nonproduction candidate branch. No existing production infrastructure, authentication, database, secrets or CI/CD files are changed. No external canonical registry is promoted. No release hold is lifted.

The connected Lovable workspace call returned an OAuth 403 during this run. Vercel was discoverable but not connected. Therefore no hosted deployment is claimed.

## Reference standards used

- W3C WCAG 2.2, Understanding Animation from Interactions: https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions
- MDN prefers-reduced-motion: https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/At-rules/@media/prefers-reduced-motion
- MDN getBoundingClientRect: https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect
- MDN CSS Scroll Snap: https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Scroll_snap

Standards informed implementation; citing them does not certify compliance.
