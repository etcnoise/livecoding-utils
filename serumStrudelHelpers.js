defaultmidimap({
  pan: 10,
  resonance: { ccn: 71, min: 0, max: 50 },
  release: { ccn: 72, min: 0, max: 32, exp: 0.2},
  attack: { ccn: 73, min: 0, max: 32, exp: 0.2},
  lpf: { ccn: 74, min: 41, max: 22050, exp: 0.29 }, // not accurate
  wt: 75,
  decay: { ccn: 85, min: 0, max: 32, exp: 0.2},
  sustain: 86,
})

function modwheel(value) {
  return ccv(value).ccn(1)
}

function mac(macroNum, value) {
  return ccv(value).ccn(add(macroNum, 19))
}

const midiStep = 1./128;

// Serum Synth Macros
m1: mac(1, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m2: mac(2, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m3: mac(3, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m4: mac(4, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m5: mac(5, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m6: mac(6, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m7: mac(7, slider(0.5, 0, 1, midiStep).seg(16)).midi()
m8: mac(8, slider(0.5, 0, 1, midiStep).seg(16)).midi()
mw: modwheel(slider(0.5, 0, 1, midiStep).seg(16)).midi()