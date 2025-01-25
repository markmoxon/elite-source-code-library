\ ******************************************************************************
\
\       Name: cellocl
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table for converting a text row number to the address of
\             that row in text screen memory (low byte)
\
\ ------------------------------------------------------------------------------
\
\ The text screen has the same kind of interleaved row layout in memory as the
\ Apple II high-res screen, except screen memory is at &400 rather than &2000.
\ We add 2 to indent the text by two characters.
\
\ ******************************************************************************

.cellocl

 EQUB LO(&0400 + 2)
 EQUB LO(&0480 + 2)
 EQUB LO(&0500 + 2)
 EQUB LO(&0580 + 2)
 EQUB LO(&0600 + 2)
 EQUB LO(&0680 + 2)
 EQUB LO(&0700 + 2)
 EQUB LO(&0780 + 2)
 EQUB LO(&0428 + 2)
 EQUB LO(&04A8 + 2)
 EQUB LO(&0528 + 2)
 EQUB LO(&05A8 + 2)
 EQUB LO(&0628 + 2)
 EQUB LO(&06A8 + 2)
 EQUB LO(&0728 + 2)
 EQUB LO(&07A8 + 2)
 EQUB LO(&0450 + 2)
 EQUB LO(&04D0 + 2)
 EQUB LO(&0550 + 2)
 EQUB LO(&05D0 + 2)
 EQUB LO(&0650 + 2)
 EQUB LO(&06D0 + 2)
 EQUB LO(&0750 + 2)
 EQUB LO(&07D0 + 2)

