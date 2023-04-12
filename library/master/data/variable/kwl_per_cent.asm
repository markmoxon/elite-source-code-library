\ ******************************************************************************
\
\       Name: KWL%
\       Type: Variable
\   Category: Status
\    Summary: Fractional number of kills awarded for destroying each type of
\             ship
\
\ ------------------------------------------------------------------------------
\
\ This figure contains the fractional part of the points that are added to the
\ combat rank in TALLY when destroying a ship of this type. This is different to
\ the other BBC versions, where you always get a single combat point for
\ everything you kill; in the Master version, it's more sophisticated.
\
\ The integral part is stored in the KWH% table.
\
\ Each fraction is stored as the numerator in a fraction with a denominator of
\ 256, so 149 represents 149 / 256 = 0.58203125 points.
\
\ ******************************************************************************

.KWL%

 EQUB 149               \ Missile                               0.58203125
 EQUB 0                 \ Coriolis space station                0.0
 EQUB 16                \ Escape pod                            0.0625
 EQUB 10                \ Alloy plate                           0.0390625
 EQUB 10                \ Cargo canister                        0.0390625
 EQUB 6                 \ Boulder                               0.0234375
 EQUB 8                 \ Asteroid                              0.03125
 EQUB 10                \ Splinter                              0.0390625
 EQUB 16                \ Shuttle                               0.0625
 EQUB 17                \ Transporter                           0.06640625
 EQUB 234               \ Cobra Mk III                          0.9140625
 EQUB 170               \ Python                                0.6640625
 EQUB 213               \ Boa                                   0.83203125
 EQUB 0                 \ Anaconda                              1.0
 EQUB 85                \ Rock hermit (asteroid)                0.33203125
 EQUB 26                \ Viper                                 0.1015625
 EQUB 85                \ Sidewinder                            0.33203125
 EQUB 128               \ Mamba                                 0.5
 EQUB 85                \ Krait                                 0.33203125
 EQUB 90                \ Adder                                 0.3515625
 EQUB 85                \ Gecko                                 0.33203125
 EQUB 170               \ Cobra Mk I                            0.6640625
 EQUB 50                \ Worm                                  0.1953125
 EQUB 42                \ Cobra Mk III (pirate)                 1.1640625
 EQUB 21                \ Asp Mk II                             1.08203125
 EQUB 42                \ Python (pirate)                       1.1640625
 EQUB 64                \ Fer-de-lance                          1.25
 EQUB 192               \ Moray                                 0.75
 EQUB 170               \ Thargoid                              2.6640625
 EQUB 33                \ Thargon                               0.12890625
 EQUB 85                \ Constrictor                           5.33203125
 EQUB 85                \ Cougar                                5.33203125
 EQUB 0                 \ Dodecahedron ("Dodo") space station   0.0

