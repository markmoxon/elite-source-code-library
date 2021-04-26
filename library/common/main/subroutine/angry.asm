\ ******************************************************************************
\
\       Name: ANGRY
\       Type: Subroutine
\   Category: Tactics
\    Summary: Make a ship hostile
\
\ ------------------------------------------------------------------------------
\
\ All this routine does is set the ship's hostile flag, start it turning and
\ give it a kick of acceleration - later calls to TACTICS will make the ship
\ start to attack us.
\
\ Arguments:
\
\   A                   The type of ship we're going to irritate
\
\   INF                 The address of the data block for the ship we're going
\                       to infuriate
\
\ ******************************************************************************

.ANGRY

 CMP #SST               \ If this is the space station, jump to AN2 to make the
 BEQ AN2                \ space station hostile

IF _CASSETTE_VERSION \ Enhanced: Group A: In the enhanced versions, attacking an innocent bystander (i.e. a ship that has bit 5 of the NEWB flags set) will annoy the space station

 BCS HI1                \ If A >= #SST then this is a missile, asteroid, cargo
                        \ canister, Thargon or escape pod, and they can't get
                        \ hostile, so return from the subroutine (as HI1
                        \ contains an RTS)

 CMP #CYL               \ If this is not a Cobra Mk III trader, skip the
 BNE P%+5               \ following instruction

ELIF _ELECTRON_VERSION

 BCS HI1                \ If A >= #SST then this is a missile, asteroid, cargo
                        \ canister or escape pod, and they can't get hostile,
                        \ so return from the subroutine (as HI1 contains an RTS)

 CMP #CYL               \ If this is not a Cobra Mk III trader, skip the
 BNE P%+5               \ following instruction

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDY #36                \ Fetch the ship's NEWB flags from byte #36
 LDA (INF),Y

 AND #%00100000         \ If bit 5 of the ship's NEWB flags is clear, skip the
 BEQ P%+5               \ following instruction, otherwise bit 5 is set, meaning
                        \ this ship is an innocent bystander, and attacking it
                        \ will annoy the space station

ENDIF

 JSR AN2                \ Call AN2 to make the space station hostile

 LDY #32                \ Fetch the ship's byte #32 (AI flag)
 LDA (INF),Y

 BEQ HI1                \ If the AI flag is zero then this ship has no AI and
                        \ it can't get hostile, so return from the subroutine
                        \ (as HI1 contains an RTS)

 ORA #%10000000         \ Otherwise set bit 7 (AI enabled) to ensure AI is
 STA (INF),Y            \ definitely enabled

 LDY #28                \ Set the ship's byte #28 (acceleration) to 2, so it
 LDA #2                 \ speeds up
 STA (INF),Y

 ASL A                  \ Set the ship's byte #30 (pitch counter) to 4, so it
 LDY #30                \ starts pitching
 STA (INF),Y

IF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION \ Enhanced: In the enhanced versions, ship hostility is measured separately from aggression, so ships can be very aggressive, but not hostile (though this changes when provoked). This is more subtle than in the cassette version, where there is only a measure of aggression, and a ship is deemed to be hostile if the top bit of its aggression level is set

 LDA TYPE               \ If the ship's type is < #CYL (i.e. a missile, Coriolis
 CMP #CYL               \ space station, escape pod, plate, cargo canister,
 BCC AN3                \ boulder, asteroid, splinter, Shuttle or Transporter),
                        \ then jump to AN3 to skip the following

 LDY #36                \ Set bit 2 of the ship's NEWB flags in byte #36 to
 LDA (INF),Y            \ make this ship hostile
 ORA #%00000100
 STA (INF),Y

.AN3

ENDIF

 RTS                    \ Return from the subroutine

.AN2

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Enhanced: See group A

 ASL K%+NI%+32          \ Fetch the AI counter (byte #32) of the second ship
 SEC                    \ in the ship data workspace at K%, which is reserved
 ROR K%+NI%+32          \ for the sun or the space station (in this case it's
                        \ the latter), and set bit 7 to make it hostile

 CLC                    \ Clear the C flag, which isn't used by calls to this
                        \ routine, but it does set up the entry point FR1-2
                        \ so that it clears the C flag and does an RTS

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 LDA K%+NI%+36          \ Set bit 2 of the NEWB flags in byte #36 of the second
 ORA #%00000100         \ ship in the ship data workspace at K%, which is
 STA K%+NI%+36          \ reserved for the sun or the space station (in this
                        \ case it's the latter), to make it hostile

ENDIF

 RTS                    \ Return from the subroutine

