\ ******************************************************************************
\
\       Name: boxEdgeImages
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Image data for patterns 0 to 4
\
\ ------------------------------------------------------------------------------
\
\ This table contains image data for patterns 0 to 4, which are as follows:
\
\   * 0 is the blank tile (all black)
\
\   * 1 contains a vertical bar down the right edge of the pattern (for the
\     left box edge)
\
\   * 2 contains a vertical bar down the left edge of the pattern (for the
\     right box edge)
\
\   * 3 contains a horizontal bar along the lower-middle of the pattern (for the
\     top box edge)
\
\   * 4 contains the first pattern for the top-left corner of the icon bar
\
\ ******************************************************************************

.boxEdgeImages

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &03, &03, &03, &03
 EQUB &03, &03, &03, &03

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &C0, &C0, &C0, &C0
 EQUB &C0, &C0, &C0, &C0

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &FF
 EQUB &FF, &FF, &00, &00

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00
 EQUB &0F, &1F, &1F, &DF
 EQUB &DF, &BF, &BF, &BF

