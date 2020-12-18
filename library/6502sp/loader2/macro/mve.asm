\ ******************************************************************************
\
\       Name: MVE
\       Type: Macro
\   Category: Utility routines
\    Summary: Move a one-page block of memory from one location to another
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to move a block of memory from one location to
\ another:
\
\   MVE S%, D%, PA%
\
\ It is used to move the component parts of the loading screen into screen
\ memory, such as the dashboard background and Acornsoft copyright message.
\
\ Arguments:
\
\   S%                  The source address of the block to move
\
\   D%                  The destination address of the block to move
\
\   PA%                 Number of pages of memory to move (1 page = 256 bytes)
\
\ ******************************************************************************

MACRO MVE S%, D%, PA%

  LDA #LO(S%)           \ Set Z1(1 0) = S%
  STA Z1
  LDA #HI(S%)
  STA Z1+1

  LDA #LO(D%)           \ Set Z1(1 0) = D%
  STA Z2
  LDA #HI(D%)
  STA Z2+1

  LDX #PA%              \ Set X = PA%

  JSR MVBL              \ Call MVBL to copy X pages from S% to D%

ENDMACRO

