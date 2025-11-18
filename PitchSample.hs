module PitchSample (pitchSample)
where

import Sound.Tidal.Context
import Control.Applicative (liftA2)
import Data.Char (toLower)
import Data.Maybe (fromMaybe)
import Sound.Tidal.ParseBP (parseBP_E)

ps :: String -> Pattern String
ps = parseBP_E

data Mode = Maj | Min
  deriving (Eq, Show)

data Root
  = C | Cs | D | Ds | E | F | Fs | G | Gs | A | As | B
  deriving (Eq, Show, Enum, Bounded)

data Key = Key Root Mode
  deriving (Eq, Show)

-- Parse Key from a 1-3 character string <R[A][M]> where
--    * R is the root note,
--    * A is the optional accidental ('', 'b', 's')
--    * M is the optional mode, defaulting to major ('', 'm')
-- For example:
--    * "d": D major
--    * "ebm": E flat minor
--    * "as": A sharp major
parseKey :: String -> Maybe Key
parseKey raw = do
  (root, accidental, mode) <- parseParts (map toLower raw)
  Key <$> toCanonicalRoot root accidental <*> pure mode
  where
    parseParts [r] = Just (r, Nothing, Maj)
    parseParts [r, 'm'] = Just (r, Nothing, Min)
    parseParts [r, acc]
      | isAcc acc = Just (r, Just acc, Maj)
    parseParts [r, acc, 'm']
      | isAcc acc = Just (r, Just acc, Min)
    parseParts _ = Nothing

    isAcc c = c == 'b' || c == 's'

-- Given a Root character and an optional Mode character, return a canonical Root (no flats)
toCanonicalRoot :: Char -> Maybe Char -> Maybe Root
toCanonicalRoot root acc = case (root, acc) of
  ('c', Just 'b')-> Just B
  ('c', Nothing) -> Just C
  ('c', Just 's')-> Just Cs
  ('d', Just 'b')-> Just Cs
  ('d', Nothing) -> Just D
  ('d', Just 's')-> Just Ds
  ('e', Just 'b')-> Just Ds
  ('e', Nothing) -> Just E
  ('e', Just 's')-> Just F
  ('f', Just 'b')-> Just E
  ('f', Nothing) -> Just F
  ('f', Just 's')-> Just Fs
  ('g', Just 'b')-> Just Fs
  ('g', Nothing) -> Just G
  ('g', Just 's')-> Just Gs
  ('a', Just 'b')-> Just Gs
  ('a', Nothing) -> Just A
  ('a', Just 's')-> Just As
  ('b', Just 'b')-> Just As
  ('b', Nothing) -> Just B
  ('b', Just 's')-> Just C
  _ -> Nothing

-- Convert a Root to its corresponding pitch class (e.g. C = 0, C# = 1, ...)
toPitchClass :: Root -> Int
toPitchClass root = fromEnum root

-- Given a Key (diatonic mode), get the parent major as pitch class (0 to 11)
-- For example,
--    parentMajor (Key A Min) = 0 (C)
--    parentMajor (Key B Min) = 2 (D)
parentMajor :: Key -> Int
parentMajor (Key root Maj) = toPitchClass root
parentMajor (Key root Min) = (toPitchClass root + 3) `mod` 12

-- Returns the shortest signed distance in semitones between two keys (range [-6, 6])
semitoneInterval :: Key -> Key -> Int
semitoneInterval src dst
  | diff > 6   = diff - 12
  | diff < -6  = diff + 12
  | otherwise  = diff
  where
    diff = parentMajor dst - parentMajor src

-- Extract suffix after last underscore in sample name
-- E.g. "my_sample_ebm" -> Just "ebm"
extractSuffix :: String -> Maybe String
extractSuffix name = case span (/= '_') (reverse name) of
  (_, [])           -> Nothing
  ("", _:_)         -> Nothing
  (revSuffix, _:_)  -> Just (reverse revSuffix)

-- Compute semitone shift
computeShift :: String -> String -> Maybe Int
computeShift sampleName targetKey = do
  srcSuffix <- extractSuffix sampleName
  srcKey    <- parseKey srcSuffix
  dstKey    <- parseKey targetKey
  return $ semitoneInterval srcKey dstKey

-- Pitches all the samples in a pattern to a key and returns the resulting control pattern.
-- Each sample in the pattern should have the format "samplename_key"
-- where "key" is a 1-3 char string representing the Root, Accidental, and Mode
-- Examples
--    d1 $ pitchSample "pianoimp_eb pianoim_fm" "c"
pitchSample :: String -> String -> ControlPattern
pitchSample samp targetKey =
  let sampPat   = ps samp
      targetPat = ps targetKey
      shiftPat  = fmap (fromIntegral . fromMaybe 0) $
                  liftA2 computeShift sampPat targetPat
  in (sound sampPat) # note shiftPat