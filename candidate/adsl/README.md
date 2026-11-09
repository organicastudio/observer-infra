# Observer ADSL immersive laboratory — nonproduction candidate

This is a proposal branch only. Do not merge or deploy without separate governance authorization.

## Existing architecture
The repository is infrastructure-focused (Azure Application Gateway, AKS/AGIC, Key Vault, internal DNS). This candidate does not modify production IaC, networking, secrets, CI/CD or deployments.

## Boundary
- Frontend is a self-contained read-only HTML specimen with local fixture data.
- Authentication adapter must be implemented against a configured nonproduction Keycloak issuer and trusted HTTPS JWKS; no bearer tokens are stored in the browser fixture.
- Server must validate JWT signature, allowed algorithm, issuer, audience, expiry, tenant binding and scoped permissions before exposing data.
- Read-only service must use least-privilege DB role and PostgreSQL RLS; deny missing tenant, unauthorized role, and cross-tenant reads.
- Append-only evidence events require provenance, event ID, timestamp, causal parents, revision and digest. No direct UI promotion.
- Independent verification, acceptance and production authorization are distinct.

## Verification
Open lab.html locally to inspect the fixture-only specimen. Browser, accessibility, live OIDC, live PostgreSQL, and security integration tests are NOT_PERFORMED in this repository. Previous local Python 9/9 tests apply only to the separately supplied v0.3 candidate archive, not to this branch.

## Integration checklist
1. Verify baseline and choose service/runtime ownership.
2. Configure nonproduction Keycloak and server-side JWKS cache/rotation.
3. Implement tenant-scoped read-only service; never expose service credentials in HTML.
4. Apply and test RLS in disposable PostgreSQL 15+ with restricted role.
5. Add browser tests for keyboard, mobile, reduced motion and deterministic rendering.
6. Capture immutable receipts and independent reviewer appointment.
7. Keep RELEASE_HELD pending separate authorized decision.
