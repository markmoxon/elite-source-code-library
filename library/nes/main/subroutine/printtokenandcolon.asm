\ ******************************************************************************
\
\       Name: PrintTokenAndColon
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character followed by a colon, ensuring that the colon is
\             always drawn in colour 3 on a black background
\
\ ------------------------------------------------------------------------------
\
\ The colon is printed using font style 3. This draws the colon in colour 3 on
\ background colour 0 (i.e. green on black), but without using the normal font.
\
\ This ensures that the colon will be drawn in green when the colon's tile falls
\ within a 2x2 attribute block that's set to draw white text (i.e. where colour
\ 1 is white). This happens in the Status Mode screen in French, and in the Data
\ on System screen in all three languages.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to be printed
\
\ ******************************************************************************

.PrintTokenAndColon

 JSR TT27_b2            \ Print the character in A

 LDA #3                 \ Set the font style to green text on a black background
 STA fontStyle          \ (colour 3 on background colour 0)

 LDA #':'               \ Print a colon
 JSR TT27_b2

 LDA #1                 \ Set the font style to print in the normal font
 STA fontStyle

 RTS                    \ Return from the subroutine

