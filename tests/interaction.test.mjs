import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { runInNewContext } from 'node:vm';
import { test } from 'node:test';

const source = readFileSync(new URL('../shell/logic/InteractionRules.js', import.meta.url), 'utf8');
const rules = runInNewContext(`${source}\n({ newTap, tapPress, tapCombo, tapRelease, overlayStep, validMode, modeTransition, matchingApps, moveSelection, protectedCategory, safeWindowId, validSnapshot })`);

test('Super tap fires once; repeat, hold, combination, fullscreen are suppressed', () => {
  let state = rules.tapPress(rules.newTap(), 100);
  assert.equal(rules.tapPress(state, 110), state);
  assert.equal(rules.tapRelease(state, 200, true, 320).fire, true);
  assert.equal(rules.tapRelease(rules.newTap(), 201, true, 320).fire, false);
  state = rules.tapPress(rules.newTap(), 100);
  assert.equal(rules.tapRelease(state, 500, true, 320).fire, false);
  state = rules.tapCombo(rules.tapPress(rules.newTap(), 100));
  assert.equal(rules.tapRelease(state, 180, true, 320).fire, false);
  state = rules.tapPress(rules.newTap(), 100);
  assert.equal(rules.tapRelease(state, 180, false, 320).fire, false);
});

test('overlay state reverses cleanly during opening and closing', () => {
  assert.equal(rules.overlayStep('Closed', 'open'), 'Opening');
  assert.equal(rules.overlayStep('Opening', 'close'), 'Closing');
  assert.equal(rules.overlayStep('Closing', 'open'), 'Opening');
  assert.equal(rules.overlayStep('Opening', 'opened'), 'Open');
  assert.equal(rules.overlayStep('Open', 'close'), 'Closing');
  assert.equal(rules.overlayStep('Closing', 'closed'), 'Closed');
  assert.equal(rules.overlayStep('Closed', 'closed'), 'Closed');
});

test('desktop entry search filters and selection wraps', () => {
  const entries = [
    { name: 'Terminal', id: 'terminal.desktop', keywords: ['shell'] },
    { name: 'Code', id: 'code.desktop', genericName: 'Editor' },
    { name: 'Hidden', id: 'hidden.desktop', noDisplay: true },
  ];
  assert.deepEqual(Array.from(rules.matchingApps(entries, 'ed')).map(e => e.name), ['Code']);
  assert.deepEqual(Array.from(rules.matchingApps(entries, 'shell')).map(e => e.name), ['Terminal']);
  assert.equal(rules.moveSelection(0, -1, 3), 2);
  assert.equal(rules.moveSelection(2, 1, 3), 0);
  assert.equal(rules.moveSelection(-1, 1, 0), -1);
});

test('mode and registry constraints preserve protected work', () => {
  assert.equal(rules.validMode('Sanctuary'), true);
  assert.equal(rules.validMode('Workshop'), true);
  assert.equal(rules.validMode('Arena'), false);
  let mode = rules.modeTransition('Sanctuary', 'Workshop');
  assert.equal(mode.accepted, true);
  assert.equal(mode.changed, true);
  assert.equal(mode.nextMode, 'Workshop');
  mode = rules.modeTransition('Workshop', 'Sanctuary');
  assert.equal(mode.accepted, true);
  assert.equal(mode.nextMode, 'Sanctuary');
  mode = rules.modeTransition('Sanctuary', 'Arena');
  assert.equal(mode.accepted, false);
  assert.equal(mode.nextMode, 'Sanctuary');
  assert.equal(rules.protectedCategory('External', 'terminal'), true);
  assert.equal(rules.protectedCategory('Mode-Owned', 'docker'), true);
  assert.equal(rules.protectedCategory('Shared', 'database'), true);
  assert.equal(rules.protectedCategory('Shared', 'application'), false);
});

test('layout snapshots reject stale or malformed windows', () => {
  const good = { address: '0xabc1', workspaceId: 2, x: 0, y: 40, width: 1200, height: 800 };
  assert.equal(rules.validSnapshot(good), true);
  assert.equal(rules.validSnapshot({ ...good, address: 'danger' }), false);
  assert.equal(rules.validSnapshot({ ...good, width: -1 }), false);
  assert.equal(rules.validSnapshot({ ...good, workspaceId: 0 }), false);
  assert.equal(rules.safeWindowId('0x123f'), true);
  assert.equal(rules.safeWindowId('0x123; dispatch'), false);
});
