\ ******************************************************************************
\
\       Name: KWH%
\       Type: Variable
\   Category: Status
\    Summary: Integer number of kills awarded for destroying each type of ship
\
\ ------------------------------------------------------------------------------
\
\ This figure contains the integer part of the points that are added to the
\ combat rank in TALLY when destroying a ship of this type. This is different to
\ the original BBC Micro versions, where you always get a single combat point
\ for everything you kill; in the Master version, it's more sophisticated.
\
\ The fractional part is stored in the KWL% table.
\
IF _NES_VERSION
\ Note that in the NES version, the kill count is doubled before it is added to
\ the kill tally.
\
ENDIF
\ ******************************************************************************

.KWH%

 EQUB 0                 \ Missile                               0.58203125
 EQUB 0                 \ Coriolis space station                0.0
 EQUB 0                 \ Escape pod                            0.0625
 EQUB 0                 \ Alloy plate                           0.0390625
 EQUB 0                 \ Cargo canister                        0.0390625
 EQUB 0                 \ Boulder                               0.0234375
 EQUB 0                 \ Asteroid                              0.03125
 EQUB 0                 \ Splinter                              0.0390625
 EQUB 0                 \ Shuttle                               0.0625
 EQUB 0                 \ Transporter                           0.06640625
 EQUB 0                 \ Cobra Mk III                          0.9140625
 EQUB 0                 \ Python                                0.6640625
 EQUB 0                 \ Boa                                   0.83203125
 EQUB 1                 \ Anaconda                              1.0
 EQUB 0                 \ Rock hermit (asteroid)                0.33203125
 EQUB 0                 \ Viper                                 0.1015625
 EQUB 0                 \ Sidewinder                            0.33203125
 EQUB 0                 \ Mamba                                 0.5
 EQUB 0                 \ Krait                                 0.33203125
 EQUB 0                 \ Adder                                 0.3515625
 EQUB 0                 \ Gecko                                 0.33203125
 EQUB 0                 \ Cobra Mk I                            0.6640625
 EQUB 0                 \ Worm                                  0.1953125
 EQUB 1                 \ Cobra Mk III (pirate)                 1.1640625
 EQUB 1                 \ Asp Mk II                             1.08203125
 EQUB 1                 \ Python (pirate)                       1.1640625
 EQUB 1                 \ Fer-de-lance                          1.25
 EQUB 0                 \ Moray                                 0.75
 EQUB 2                 \ Thargoid                              2.6640625
 EQUB 0                 \ Thargon                               0.12890625
 EQUB 5                 \ Constrictor                           5.33203125
IF NOT(_APPLE_VERSION)
 EQUB 5                 \ Cougar                                5.33203125
ENDIF
 EQUB 0                 \ Dodecahedron ("Dodo") space station   0.0

