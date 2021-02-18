\ ******************************************************************************
\
\       Name: MTIN
\       Type: Variable
\   Category: Text
\    Summary: Lookup table for random tokens in the extended token table (0-37)
\  Deep dive: Extended text tokens
\
\ ------------------------------------------------------------------------------
\
\ The ERND token type, which is part of the extended token system, takes an
\ argument between 0 and 37, and returns a randomly chosen token in the range
\ specified in this table. This is used to generate the extended description of
\ each system.
\
\ For example, the entry at position 13 in this table (counting from 0) is 66,
\ so ERND 14 will expand into a random token in the range 66-70, i.e. one of
\ "JUICE", "BRANDY", "WATER", "BREW" and "GARGLE BLASTERS".
\
\ ******************************************************************************

.MTIN

 EQUB 16                \ Token  0: a random extended token between 16 and 20
 EQUB 21                \ Token  1: a random extended token between 21 and 25
 EQUB 26                \ Token  2: a random extended token between 26 and 30
 EQUB 31                \ Token  3: a random extended token between 31 and 35
 EQUB 155               \ Token  4: a random extended token between 155 and 159
 EQUB 160               \ Token  5: a random extended token between 160 and 164
 EQUB 46                \ Token  6: a random extended token between 46 and 50
 EQUB 165               \ Token  7: a random extended token between 165 and 169
 EQUB 36                \ Token  8: a random extended token between 36 and 40
 EQUB 41                \ Token  9: a random extended token between 41 and 45
 EQUB 61                \ Token 10: a random extended token between 61 and 65
 EQUB 51                \ Token 11: a random extended token between 51 and 55
 EQUB 56                \ Token 12: a random extended token between 56 and 60
 EQUB 170               \ Token 13: a random extended token between 170 and 174
 EQUB 66                \ Token 14: a random extended token between 66 and 70
 EQUB 71                \ Token 15: a random extended token between 71 and 75
 EQUB 76                \ Token 16: a random extended token between 76 and 80
 EQUB 81                \ Token 17: a random extended token between 81 and 85
 EQUB 86                \ Token 18: a random extended token between 86 and 90
 EQUB 140               \ Token 19: a random extended token between 140 and 144
 EQUB 96                \ Token 20: a random extended token between 96 and 100
 EQUB 101               \ Token 21: a random extended token between 101 and 105
 EQUB 135               \ Token 22: a random extended token between 135 and 139
 EQUB 130               \ Token 23: a random extended token between 130 and 134
 EQUB 91                \ Token 24: a random extended token between 91 and 95
 EQUB 106               \ Token 25: a random extended token between 106 and 110
 EQUB 180               \ Token 26: a random extended token between 180 and 184
 EQUB 185               \ Token 27: a random extended token between 185 and 189
 EQUB 190               \ Token 28: a random extended token between 190 and 194
 EQUB 225               \ Token 29: a random extended token between 225 and 229
 EQUB 230               \ Token 30: a random extended token between 230 and 234
 EQUB 235               \ Token 31: a random extended token between 235 and 239
 EQUB 240               \ Token 32: a random extended token between 240 and 244
 EQUB 245               \ Token 33: a random extended token between 245 and 249
 EQUB 250               \ Token 34: a random extended token between 250 and 254
 EQUB 115               \ Token 35: a random extended token between 115 and 119
 EQUB 120               \ Token 36: a random extended token between 120 and 124
 EQUB 125               \ Token 37: a random extended token between 125 and 129

