# livecoding-utils
A set of tools, scripts, and helper modules for TidalCycles, Strudel, and other livecoding environments. All code in this repository is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for details.

## PitchSample
A Haskell module that exports a single function, `pitchSample`. This function takes two arguments:
  1. `samp`: A String Pattern of samples with the folder name convention of `samplename_<key>` where `key` is a 1-3 character string that represents the key signature of the sample. `key` takes the form `R[A][M]` where:
      1. `R` is the root note (`c, d, e, f, g, a, b`)
      2. `A` is the optional accidental (`b, s` for flat and sharp respectively)
      3. `M` is the optional mode (`m` for minor, empty for major)
  2. `targetKey` A String Pattern of key signature(s)

and outputs a control pattern that pitches the samples according to the target key signatures.

Example:

`d1 $ pitchSample "pianoimp_eb pianoimp_fm" "c"`
plays `pianoimp_eb` (an E flat major piano sample) and `pianoimp_fm` (a F minor piano sample) transposed to the key of C major.