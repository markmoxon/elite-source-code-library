\ ******************************************************************************
\
\       Name: DELAY
\       Type: Subroutine
\   Category: Utility routines
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\    Summary: Wait for a specified time, in 1/50s of a second
ELIF _ELECTRON_VERSION OR _APPLE_VERSION
\    Summary: Wait for a specified time, measured in loop iterations
ELIF _NES_VERSION
\    Summary: Wait until a specified number of NMI interrupts have passed (i.e.
\             a specified number of VBlanks)
ELIF _C64_VERSION
\    Summary: Wait for a specified time, in either 1/50s of a second (on PAL
\             systems) or 1/60s of a second (on NTSC systems)
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
\ Wait for the number of vertical syncs given in Y, so this effectively waits
\ for Y/50 of a second (as the vertical sync occurs 50 times a second).
\
ELIF _ELECTRON_VERSION
\ Loop round a convoluted loop-within-loop structure to pass the required
\ amount of time.
\
ELIF _C64_VERSION
\ Wait for the number of vertical syncs given in Y, so this effectively waits
\ for Y/50 of a second on PAL systems (as the PAL vertical sync occurs 50 times
\ a second) or Y/60 of a second on NTSC systems (as the NTSC vertical sync
\ occurs 60 times a second).
\
ELIF _APPLE_VERSION
\ This routine uses the WSCAN routine to implement a pause. In the released
\ version of Apple II Elite, WSCAN waits for 15 * 256 iterations of an empty
\ loop, so the DELAY routine waits for a specified number of loop iterations.
\
\ The variant on the source disk from Ian Bell's site implements WSCAN by
\ waiting for the vertical sync (like the BBC Micro and Commodore 64 versions),
\ so this behaviour was presumably changed at some stage during development.
\
ENDIF
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION \ Comment
\   Y                   The number of vertical sync events to wait for
ELIF _ELECTRON_VERSION
\   Y                   The number of delay loops to run
ELIF _NES_VERSION
\   Y                   The number of NMI interrupts to wait for
ENDIF
\
IF _CASSETTE_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DEL8                Wait for 8/50 of a second (0.16 seconds)
\
\   DELAY-5             Wait for 2/50 of a second (0.04 seconds)
\
ELIF _ELECTRON_VERSION
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   DEL8                Wait for 30 delay loops' worth of time
\
\   DELAY-5             Wait for 1 delay loop's worth of time
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION \ Electron: Group A: In the BBC versions, delays are implemented by waiting for a specified number of vertical syncs. The Electron's video system is different, so it has its own dedicated delay routine that isn't based around the screen refresh, but instead wastes time using a convoluted loop-within-loop structure

 LDY #2                 \ Set Y to 2 vertical syncs

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A0 &08, or BIT &08A0, which does nothing apart
                        \ from affect the flags

.DEL8

 LDY #8                 \ Set Y to 8 vertical syncs and fall through into DELAY
                        \ to wait for this long

ELIF _ELECTRON_VERSION

 LDY #1                 \ Set Y to 1 so we run the delay loop once

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &A0 &1E, or BIT &1EA0, which does nothing apart
                        \ from affect the flags

.DEL8

 LDY #30                \ Set Y to 30 and fall through into DELAY so we run the
                        \ delay loop 30 times

ENDIF

.DELAY

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Electron: See group A

 JSR WSCAN              \ Call WSCAN to wait for the vertical sync, so the whole
                        \ screen gets drawn

ELIF _ELECTRON_VERSION

 TXA                    \ Store X in A so we can retrieve it later

                        \ The following loop does 256 iterations of a convoluted
                        \ loop-back and pass-through sequence, which purely
                        \ exists to implement a delay (and to make us go
                        \ cross-eyed trying to follow the logic)

 LDX #0                 \ Set X = 0 to act as a loop counter

.DELY1

 EQUB &2C               \ Skip the following instruction by turning it into
                        \ &2C &D0 &FD, or BIT &FDD0, which does nothing apart
                        \ from affect the flags

.DELY2

 BNE DELY1              \ Loop back up as part of the chain of delay loops

 EQUB &2C               \ Skip the following instruction by turning it into
                        \ &2C &D0 &FB, or BIT &FBD0, which does nothing apart
                        \ from affect the flags

.DELY3

 BNE DELY2              \ Loop back up as part of the chain of delay loops

 DEX                    \ Decrement the loop counter

 BNE DELY3              \ Loop back up as part of the chain of delay loops

 TAX                    \ retrieve X from A, so it gets preserved

ELIF _APPLE_VERSION

 JSR WSCAN              \ Call WSCAN to wait for 15 * 256 loop iterations

ELIF _NES_VERSION

 JSR WaitForNMI         \ Wait until the next NMI interrupt has passed (i.e. the
                        \ next VBlank)

ENDIF

 DEY                    \ Decrement the counter in Y

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment

 BNE DELAY              \ If Y isn't yet at zero, jump back to DELAY to wait
                        \ for another vertical sync

ELIF _ELECTRON_VERSION OR _APPLE_VERSION

 BNE DELAY              \ If Y isn't yet at zero, jump back to DELAY to wait
                        \ for another iteration of the delay loop

ELIF _NES_VERSION

 BNE DELAY              \ If Y isn't yet at zero, jump back to DELAY to wait
                        \ for another NMI interrupt

ENDIF

 RTS                    \ Return from the subroutine

