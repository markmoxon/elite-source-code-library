\ ******************************************************************************
\
\       Name: DELAY
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Wait for a specified time, in 1/50s of a second
\
\ ------------------------------------------------------------------------------
\
\ Wait for the number of vertical syncs given in Y, so this effectively waits
\ for Y/50 of a second (as the vertical sync occurs 50 times a second).
\
\ Arguments:
\
\   Y                   The number of vertical sync events to wait for
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
\ Other entry points:
\
\   DEL8                Wait for 8/50 of a second (0.16 seconds)
\
\   DELAY-5             Wait for 2/50 of a second (0.04 seconds).
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION \ Platform

 LDY #2                 \ Set Y to 2 vertical syncs

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A0 &08, or BIT &08A0, which does nothing apart
                        \ from affect the flags

.DEL8

 LDY #8                 \ Set Y to 8 vertical syncs and fall through into DELAY
                        \ to wait for this long

ELIF _ELECTRON_VERSION

.L285F

 LDY #1                 \ Set Y to 1 ???

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A0 &08, or BIT &08A0, which does nothing apart
                        \ from affect the flags

.DEL8

 LDY #30                \ Set Y to 30 ??? and fall through into DELAY
                        \ to wait for this long

ENDIF

.DELAY

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Electron: On the BBC versions, delays are implemented by waiting for a specified number of vertical syncs. The Electron's video system doesn't work in the same way, so it has its own dedicated delay routine that isn't based around the screen refresh

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn

ELIF _ELECTRON_VERSION

 TXA                    \ ???
 LDX #0

.L2867

 EQUB &2C

.L2868

 BNE L2867

 EQUB &2C

.L286B

 BNE L2868

 DEX
 BNE L286B

 TAX

ENDIF

 DEY                    \ Decrement the counter in Y

 BNE DELAY              \ If Y isn't yet at zero, jump back to DELAY to wait
                        \ for another vertical sync

 RTS                    \ Return from the subroutine

