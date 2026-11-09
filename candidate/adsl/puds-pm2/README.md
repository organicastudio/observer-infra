# PUDS × PM2 × DAiMAC — semantic integration candidate

Executed on 2026-11-09. “Yesterday” refers to 2026-11-08; no deployment is backdated.

## Run

Node.js 22+; Python 3 for the optional local server. No runtime package dependencies.

```sh
npm test
npm run build
npm start
# Local server: http://127.0.0.1:4173/
# Or open dist/puds-pm2-daimac.html without a server.
```

Browser tests require Python Playwright and Chromium. `python tests/browser.py` uses `/usr/bin/chromium` and an in-memory standalone document; adapt the executable path to your installation. This run's browser environment blocked HTTP navigation and exposed no WebGL.

## Implemented

The complete six-section PUDS page flow, PM2 registry and DAiMAC evidence boundary are integrated with labelled local fixtures. PUDS paper/teal and PM2 dark/phosphor use shared semantic aliases without replacing their namespaces.

The hero measures stable character slots and transforms only the inner characters. Frame-coalesced pointer handling includes bounded geometry, reduced-motion changes, touch fallback, explicit opt-out, hidden-document/blur resets, resize/font refresh and lifecycle cleanup.

Project filters announce counts. The case-study rail provides keyboard navigation, list mode and a vertical mobile layout. Invalid cases are quarantined. Service selection feeds a real local JSON brief download; nothing is sent or booked. Registry details separate runtime state, risk, specification, implementation and acceptance.

Contracts reject missing/blank fields, null inputs, invalid types/enums, duplicate identifiers and unsafe routes. The legacy PM2 prefix check is retained separately from the strict identifier validator. Unknown evidence is incomplete; failed evidence freezes. Browser-side checks never authorize release. The optional WebGL dither study has a static fallback and is not physically based refraction.

## Evidence

Final result: **114/114 Node contract tests and 41/41 Chromium smoke checks passed.** No JavaScript exceptions or specimen network requests were observed. Viewports: 320, 390, 768, 1024 and 1440 pixels. A 200% root-text-size check passed.

`evidence/execution-receipt.json`, `browser-report.json` and `source-manifest.json` bind the observations to source and standalone SHA-256 digests. The archive additionally retains raw TAP output, screenshots and initial failed-run evidence. Source tests are reproducible locally; they were not run in GitHub Actions.

The signed-zero motion reset was corrected. The outline test now establishes keyboard modality instead of assuming it after a mouse click. Missing-report and null-options regression checks were added. WebGL fallback passed; shader compilation remains NOT_PERFORMED. Idle frame timing is not interaction-load acceptance.

## Boundaries and remaining work

This is an additive static-frontend candidate under `candidate/adsl/puds-pm2/`. Existing infrastructure, original laboratory, authentication, databases, secrets, CI/CD and main branch are unchanged. No client outcomes or live telemetry are fabricated. Historical maturity 0.84 and confidence 0.86 remain estimates.

Outstanding: real WebGL target compilation; Safari/iOS/Firefox and assistive-technology checks; full contrast/accessibility review; target-device performance; independent review and scope-bound release decision; authorized hosting and hosted smoke tests. OIDC/JWKS and tenant RLS are required before any future live-data attachment, but none is attached here.

Lovable workspace access returned OAuth 403. Vercel was discoverable but not connected. Hosted deployment was NOT_PERFORMED. Acceptance is NOT_GRANTED; release is HELD. No canonical external registry was promoted.

Implementation references: W3C WCAG 2.2 Animation from Interactions, and MDN prefers-reduced-motion, getBoundingClientRect and CSS Scroll Snap documentation. These informed the code; they do not certify conformance.
