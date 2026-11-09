const test=require('node:test');const assert=require('node:assert/strict');const C=require('../src/core.js');
test('missing hero report is incomplete rather than a failed check',()=>assert.equal(C.validateHero(null).exportStatus,'Production Candidate'));
test('null kinematic options use bounded defaults',()=>assert.equal(C.kinematics(0,0,0,0,null).scale,1.08));
