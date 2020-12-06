\ ******************************************************************************
\
\       Name: TT160
\       Type: Subroutine
\   Category: Market
\    Summary: Print "t" (for tonne) and a space
\
\ ******************************************************************************

.TT160

 LDA #'t'               \ Load a "t" character into A

 JSR TT26               \ Print the character, using TT216 so that it doesn't
                        \ change the character case

 BCC TT162              \ Jump to TT162 to print a space and return from the
                        \ subroutine using a tail call (this BCC is effectively
                        \ a JMP as the C flag is cleared by TT26)

