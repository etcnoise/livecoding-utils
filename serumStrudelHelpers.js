defaultmidimap({
  gain: 7,
  pan: 10,
  resonance: { ccn: 71, min: 0, max: 50 },
  release: { ccn: 72, min: 0, max: 32, exp: 0.2},
  attack: { ccn: 73, min: 0, max: 32, exp: 0.2},
  lpf: { ccn: 74, min: 41, max: 22050, exp: 0.29 },
  wt: 75,
  hpf: { ccn: 81, min: 8, max: 22050, exp: 0.16 },
  decay: { ccn: 85, min: 0, max: 32, exp: 0.2},
  sustain: 86,
  size: 90,
  room: 91,
})

function modwheel(value) {
  return ccv(value).ccn(1)
}

function mac(macroNum, value) {
  return ccv(value).ccn(add(macroNum, 19))
}

function resetFx(pat) {
  if (pat) return pat.hpf(0).room(0).size(0)
  return hpf(0).room(0).size(0)
}

Pattern.prototype.resetFx = function() {
  return resetFx(this);
}

// // ---------------- SYNTH MACROS----------------
// Channel 1
m1a: mac(1, slider(0.5, 0, 1).seg(16)).midichan(1).midi()
m2a: mac(2, slider(0.5, 0, 1).seg(16)).midichan(1).midi()
m3a: mac(3, slider(0.5, 0, 1).seg(16)).midichan(1).midi()
m4a: mac(4, slider(0.5, 0, 1).seg(16)).midichan(1).midi()
mwa: modwheel(slider(0.5, 0, 1).seg(16)).midichan(1).midi()
gaa: gain(slider(0.8, 0, 1).seg(16)).midichan(1).midi()

// Channel 2
m1b: mac(1, slider(0.5, 0, 1).seg(16)).midichan(2).midi()
m2b: mac(2, slider(0.5, 0, 1).seg(16)).midichan(2).midi()
m3b: mac(3, slider(0.5, 0, 1).seg(16)).midichan(2).midi()
m4b: mac(4, slider(0.5, 0, 1).seg(16)).midichan(2).midi()
mwb: modwheel(slider(0.5, 0, 1).seg(16)).midichan(2).midi()
gab: gain(slider(0.8, 0, 1).seg(16)).midichan(2).midi()