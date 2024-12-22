\ ******************************************************************************
\
\       Name: ylookupl
\       Type: Variable
\   Category: Drawing pixels
\    Summary: Lookup table for converting a pixel y-coordinate to the low byte
\             of a screen address (within the 256-pixel wide game screen)
\  Deep dive: Drawing pixels in the Commodore 64 version
\
\ ------------------------------------------------------------------------------
\
\ The address returned is indented by four character blocks from the edge of the
\ screen (that's the &20 part, as each character is 8 bytes, and 4 * 8 = &20).
\
\ This is because the first four characters of every character line are blank,
\ so the 256-pixel wide game screen is centred in the Commodore 64's screen
\ width of 320 pixels.
\
\ ******************************************************************************

.ylookupl

 FOR I%, 0, 255

  EQUB LO(SCBASE + &20 + ((I% AND &F8) * 40))

 NEXT

