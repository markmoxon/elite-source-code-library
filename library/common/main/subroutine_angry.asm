\ ******************************************************************************
\
\       Name: ANGRY
\       Type: Subroutine
\   Category: Tactics
\    Summary: Make a ship hostile
\
\ ------------------------------------------------------------------------------
\
\ All this actually does is set the ship's hostile flag, start it turning and
\ give it a kick of acceleration - later calls to TACTICS will make the ship
\ actually attack.
\
\ Arguments:
\
\   A                   The type of ship to irritate
\
\   INF                 The address of the data block for the ship to infuriate
\
\ ******************************************************************************

.ANGRY

 CMP #SST               \ If this is the space station, jump to AN2 to make the
 BEQ AN2                \ space station hostile

IF _CASSETTE_VERSION

 BCS HI1                \ If A >= #SST then this is a missile, asteroid, cargo
                        \ canister, Thargon or escape pod, and they can't get
                        \ hostile, so return from the subroutine (as HI1
                        \ contains an RTS)

 CMP #CYL               \ If this is not a Cobra Mk III trader, skip the
 BNE P%+5               \ following instruction

ELIF _6502SP_VERSION

 LDY #36
 LDA (INF),Y
 AND #32
 BEQ P%+5

ENDIF

 JSR AN2                \ Call AN2 to make the space station hostile

 LDY #32                \ Fetch the ship's byte #32 (AI flag)
 LDA (INF),Y

 BEQ HI1                \ If the AI flag is zero then this ship has no AI and
                        \ it can't get hostile, so return from the subroutine
                        \ (as HI1 contains an RTS)

 ORA #%10000000         \ Otherwise set bit 7 to ensure AI is definitely enabled
 STA (INF),Y

 LDY #28                \ Set the ship's byte #28 (acceleration) to 2, so it
 LDA #2                 \ speeds up
 STA (INF),Y

 ASL A                  \ Set the ship's byte #30 (pitch counter) to 4, so it
 LDY #30                \ starts pitching
 STA (INF),Y

IF _6502SP_VERSION

 LDA TYPE
 CMP #CYL
 BCC AN3
 LDY #36
 LDA (INF),Y
 ORA #4
 STA (INF),Y

.AN3

ENDIF

 RTS                    \ Return from the subroutine

.AN2

IF _CASSETTE_VERSION

 ASL K%+NI%+32          \ Fetch the AI counter (byte #32) of the second ship
 SEC                    \ in the ship data workspace at K%, which is reserved
 ROR K%+NI%+32          \ for the sun or the space station (in this case it's
                        \ the latter), and set bit 7 to make it hostile

 CLC                    \ Clear the C flag, which isn't used by calls to this
                        \ routine, but it does set up the entry point FR1-2
                        \ so that it clears the C flag and does an RTS

ELIF _6502SP_VERSION

 LDA K%+NI%+36
 ORA #4
 STA K%+NI%+36

ENDIF

 RTS                    \ Return from the subroutine

