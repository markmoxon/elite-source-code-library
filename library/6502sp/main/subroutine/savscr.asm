\ ******************************************************************************
\
\       Name: savscr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Save a screenshot if CTRL-D is pressed when the game is paused
\
\ ------------------------------------------------------------------------------
\
\ Screen memory from &4000 to &8000 is saved to disc with an incremental
\ filename, starting with ":0.X.SCREEN1" for the first screenshot, then
\ ":0.X.SCREEN2" for the next, and so on.
\
\ ******************************************************************************

.savscr

 JSR CTRL               \ Scan the keyboard to see if CTRL is currently pressed,
                        \ returning a negative value in A if it is

 BPL FREEZE             \ If CTRL is not being pressed, jump to FREEZE to keep
                        \ listening for configuration keys while we're paused

 LDX #17                \ We start by copying the 18 bytes in oscobl2 to oscobl,
                        \ so set a counter in X for 18 bytes. The oscobl block
                        \ is not altered by this routine or any other, so it
                        \ isn't clear why we copy oscobl2 to oscobl, but perhaps
                        \ there was a reason at some point

.savscl

 LDA oscobl2,X          \ Copy the X-th byte of oscobl2 to the X-th byte of
 STA oscobl,X           \ oscobl

 DEX                    \ Decrement the byte counter

 BPL savscl             \ Loop back for the next byte until we have copied all
                        \ 18 bytes

 LDX #LO(oscobl)        \ Set (Y X) to point to the oscobl parameter block
 LDY #HI(oscobl)

 LDA #0                 \ Call OSFILE with A = 0 to save a file containing the
 JSR OSFILE             \ screen memory from &4000 to &8000

 INC scname+11          \ Increment the screenshot number in the filename at
                        \ scname, so ":0.X.SCREEN1" becomes ":0.X.SCREEN2" and
                        \ so on

 JMP FREEZE             \ Jump back into the pause loop to keep listening for
                        \ configuration key presses

