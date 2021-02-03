\ ******************************************************************************
\
\       Name: LOAD
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Load a hidden file from disc (not used in this version as disc
\             protection is disabled)
\
\ ******************************************************************************

.LOAD

 JSR p2                 \ Call p2 below

 JMP load3              \ Jump to load3 to load and run the next part of the
                        \ loader

 LDA #2                 \ Set PARAMS1+8 = 2, which is the track number in the
 STA PARAMS1+8          \ OSWORD parameter block

 LDA #127               \ Call OSWORD with A = 127 and (Y X) = PARAMS1 to seek
 LDX #LO(PARAMS1)       \ disc track 2
 LDY #HI(PARAMS1)
 JMP OSWORD

.p2

 STA PARAMS2+7          \ Set PARAMS2+7 = A, which is the track number in the
                        \ OSWORD parameter block

 LDA #127               \ Call OSWORD with A = 127 and (Y X) = PARAMS2 to seek
 LDX #LO(PARAMS2)       \ the disc track given in A
 LDY #HI(PARAMS2)
 JMP OSWORD

