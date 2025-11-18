# livecoding-utils
A set of tools, scripts, and helper modules for TidalCycles, Strudel, and other livecoding environments. All code in this repository is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for details.

## PitchSample

A Haskell helper for easy pitch transposition of samples in TidalCycles. (A Strudel version will be coming soon!)
It works by reading a small key tag at the end of your sample names and automatically pitching them to the key you specify.

### How the key tag works

Each sample folder that you want to transpose with this helper should have a short key tag, like:

```
_dm   _eb   _f   _gs   _bbm
```

The format is:
- **Root note**: `c d e f g a b`
- **Optional accidental**: `s` = sharp, `b` = flat  
- **Optional `m`**: for minor (major is implied when omitted)

Examples:
- `_dm` → D minor  
- `_eb` → E♭ major  
- `_fs` → F♯ major  
- `_bbm` → B♭ minor  

### Usage

```haskell
d1 $ pitchSample "pianoimp_eb pianoimp_fm" "c"
```

This takes samples tagged as E♭ major and F minor, retunes them into **C major**, and plays the resulting pattern. Note that both arguments to `pitchSample` can be patterened.
