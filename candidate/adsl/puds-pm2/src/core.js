/* PUDS x PM2 x DAiMAC — pure contracts. No authority is granted by client code. */
(function (root, factory) {
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  else root.PUDSCore = Object.freeze(api);
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  'use strict';
  const STATES = ['IDLE', 'ACTIVE', 'OVERDRIVE', 'FAULT', 'FROZEN'];
  const RISKS = ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'];
  const WEIGHTS = ['LIGHT', 'MEDIUM', 'HEAVY', 'MISSION_CRITICAL'];
  const SURFACES = ['LANDING', 'PORTFOLIO', 'OBSERVER_HUD', 'CASE_STUDY', 'REAL_ESTATE_INTELLIGENCE', 'ASIMETRIA_DASHBOARD', 'CROSS_MEDIA_VIEWPORT'];
  const GOVERNANCE = ['DRAFT', 'CANDIDATE', 'REVIEW', 'FROZEN', 'VERIFIED', 'ACCEPTED'];
  const isRecord = value => value !== null && typeof value === 'object' && !Array.isArray(value);
  const text = value => typeof value === 'string' && value.trim().length > 0;
  const finite = value => typeof value === 'number' && Number.isFinite(value);
  const exact = value => text(value) && value === value.trim();
  const namespace = value => typeof value === 'string' && value.startsWith('PM2.');
  const pm2Identifier = value => exact(value) && /^PM2\.(?:C_[0-9]{2,}|[A-Z][A-Z0-9_]*(?:\.[A-Z][A-Z0-9_]*)*\.v[1-9][0-9]*)$/.test(value);
  const SYMBOL = /^[A-Z][A-Z0-9_]{1,11}$/;
  const CLASS = /^[A-Za-z][A-Za-z0-9]{1,79}$/;
  function verdict(errors) {
    return { valid: errors.length === 0, errors, validationStatus: errors.length ? 'FAILED' : 'PASSED', exportStatus: errors.length ? 'Frozen' : 'Production Candidate', deploymentAuthorized: false };
  }
  function safeRoute(value) {
    if (!exact(value) || /[\s\\\u0000-\u001f\u007f]/.test(value)) return false;
    if (/^#[A-Za-z][A-Za-z0-9_-]*$/.test(value)) return true;
    if (/^\/(?!\/)[A-Za-z0-9/_-]*(?:\?[A-Za-z0-9_=&%-]*)?(?:#[A-Za-z][A-Za-z0-9_-]*)?$/.test(value)) return true;
    try { const u = new URL(value); return u.protocol === 'https:' && !!u.hostname && !u.username && !u.password; } catch { return false; }
  }
  function validateRegistryRow(row) {
    if (!isRecord(row)) return verdict(['row: object required']);
    const errors = [];
    if (!pm2Identifier(row.componentIdentifier)) errors.push('componentIdentifier: invalid PM2 identifier');
    if (!exact(row.symbolicCode) || !SYMBOL.test(row.symbolicCode)) errors.push('symbolicCode: invalid');
    if (!exact(row.className) || !CLASS.test(row.className)) errors.push('className: invalid');
    ['hook', 'microTextureRule'].forEach(k => { if (!text(row[k])) errors.push(k + ': nonempty text required'); });
    if (!STATES.includes(row.state)) errors.push('state: unsupported');
    if (!RISKS.includes(row.governanceRisk)) errors.push('governanceRisk: unsupported');
    if (!WEIGHTS.includes(row.weightClass)) errors.push('weightClass: unsupported');
    if (!Array.isArray(row.deploymentSurface) || !row.deploymentSurface.length || row.deploymentSurface.some(s => !SURFACES.includes(s)) || new Set(row.deploymentSurface).size !== row.deploymentSurface.length) errors.push('deploymentSurface: unique allowlisted values required');
    return verdict(errors);
  }
  function auditRegistry(rows) {
    if (!Array.isArray(rows)) return { ...verdict(['registry: array required']), rows: [] };
    const seenIds = new Set(), seenSymbols = new Set();
    const results = rows.map((row, index) => {
      const result = validateRegistryRow(row);
      if (isRecord(row)) {
        if (seenIds.has(row.componentIdentifier)) result.errors.push('componentIdentifier: duplicate');
        if (seenSymbols.has(row.symbolicCode)) result.errors.push('symbolicCode: duplicate');
        seenIds.add(row.componentIdentifier); seenSymbols.add(row.symbolicCode);
      }
      return { index, ...verdict(result.errors) };
    });
    return { ...verdict(results.flatMap(r => r.errors.map(e => 'row ' + r.index + ': ' + e))), rows: results };
  }
  function validateCase(item) {
    if (!isRecord(item)) return verdict(['case: object required']);
    const errors = [];
    ['projectId', 'title', 'category', 'problem', 'signal', 'method', 'system', 'result', 'ctaLabel'].forEach(k => { if (!text(item[k])) errors.push(k + ': nonempty text required'); });
    if (!exact(item.projectId) || !/^[A-Z][A-Z0-9._-]*$/.test(item.projectId)) errors.push('projectId: invalid');
    if (!safeRoute(item.ctaUrl)) errors.push('ctaUrl: unsafe or empty');
    if (!GOVERNANCE.includes(item.governanceStatus)) errors.push('governanceStatus: unsupported');
    if (!['FIXTURE', 'UNVERIFIED', 'VERIFIED'].includes(item.evidenceStatus)) errors.push('evidenceStatus: unsupported');
    if (item.evidenceStatus === 'VERIFIED' && (!Array.isArray(item.evidenceRefs) || !item.evidenceRefs.length || !item.evidenceRefs.every(text))) errors.push('evidenceRefs: required for VERIFIED');
    if (item.governanceStatus === 'FROZEN') errors.push('governanceStatus: explicit freeze');
    ['maturityScore', 'confidenceScore'].forEach(k => { if (item[k] != null && (!finite(item[k]) || item[k] < 0 || item[k] > 1)) errors.push(k + ': expected 0..1 or null'); });
    return verdict(errors);
  }
  function validateHero(report) {
    if (!isRecord(report)) return { ...verdict(['report: object required']), pass: null, validationStatus: 'INCOMPLETE' };
    const failures = [], missing = [];
    const requirements = { causesLayoutShift: false, interactionSmoothness: 'smooth', respectsReducedMotion: true, hasMobileFallback: true };
    for (const [key, expected] of Object.entries(requirements)) {
      if (report[key] == null) missing.push(key);
      else if (report[key] !== expected) failures.push(key);
    }
    const pass = failures.length ? false : missing.length ? null : true;
    return { pass, failures, missing, validationStatus: failures.length ? 'FAILED' : missing.length ? 'INCOMPLETE' : 'PASSED', exportStatus: failures.length ? 'Frozen' : 'Production Candidate', reviewRequired: missing.length > 0 || report.hasMobileFallback !== true, deploymentAuthorized: false };
  }
  const CHECKS = ['implementation', 'schema', 'browser', 'accessibility', 'performance', 'registryBinding'];
  // This evaluates supplied evidence, not its authenticity. Enforcement belongs on a trusted server.
  function evaluateRelease(report) {
    const failures = [], missing = [];
    if (!isRecord(report)) return { validationStatus: 'INCOMPLETE', exportStatus: 'Production Candidate', missing: ['report'], failures, deploymentAuthorized: false };
    if (!text(report.revision)) missing.push('revision');
    if (!text(report.scope)) missing.push('scope');
    if (report.activeHold !== false) missing.push('hold clearance');
    const checks = isRecord(report.checks) ? report.checks : {};
    for (const name of CHECKS) {
      const check = checks[name];
      if (check?.status === 'FAILED') failures.push(name);
      else if (check?.status !== 'PASSED' || !text(check.receipt) || !text(check.revision) || check.revision !== report.revision) missing.push(name);
    }
    return { validationStatus: failures.length ? 'FAILED' : missing.length ? 'INCOMPLETE' : 'PASSED', exportStatus: failures.length ? 'Frozen' : 'Production Candidate', acceptanceEligibility: !failures.length && !missing.length ? 'ELIGIBLE' : 'NOT_ESTABLISHED', missing, failures, deploymentAuthorized: false, authorityEffect: 'NONE' };
  }
  function kinematics(x, y, cx, cy, options = {}) {
    if (![x, y, cx, cy].every(finite)) return { x: 0, y: 0, scale: 1, rotate: 0, power: 0 };
    const radius = finite(options.radius) && options.radius > 0 ? options.radius : 250;
    const dx = x - cx, dy = y - cy, distance = Math.hypot(dx, dy);
    const power = Math.max(0, 1 - distance / radius), divisor = Math.max(distance, 0.001);
    if (power === 0) return { x: 0, y: 0, scale: 1, rotate: 0, power: 0 };
    return { x: -dx / divisor * power * 18, y: -dy / divisor * power * 12, scale: 1 + power * 0.08, rotate: Math.max(-6, Math.min(6, dx * power * 0.03)), power };
  }
  return { STATES, RISKS, WEIGHTS, SURFACES, GOVERNANCE, CHECKS, validatePM2ComponentIdentifier: namespace, validatePM2IdentifierStrict: pm2Identifier, validateRegistryRow, auditRegistry, validateCase, validateHero, evaluateRelease, safeRoute, kinematics };
});
