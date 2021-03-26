\ ******************************************************************************
\
\       Name: TACTICS (Part 1 of 7)
\       Type: Subroutine
\   Category: Tactics
\    Summary: Apply tactics: Process missiles, both enemy missiles and our own
\  Deep dive: Program flow of the tactics routine
\
\ ------------------------------------------------------------------------------
\
\ This section implements missile tactics and is entered at TA18 from the main
\ entry point below, if the current ship is a missile. Specifically:
\
\   * If E.C.M. is active, destroy the missile
\
\   * If the missile is hostile towards us, then check how close it is. If it
\     hasn't reached us, jump to part 3 so it can streak towards us, otherwise
\     we've been hit, so process a large amount of damage to our ship
\
\   * Otherwise see how close the missile is to its target. If it has not yet
\     reached its target, give the target a chance to activate its E.C.M. if it
\     has one, otherwise jump to TA19 with K3 set to the vector from the target
\     to the missile
\
\   * If it has reached its target and the target is the space station, destroy
\     the missile, potentially damaging us if we are nearby
\
\   * If it has reached its target and the target is a ship, destroy the missile
\     and the ship, potentially damaging us if we are nearby
\
\ ******************************************************************************

IF _MASTER_VERSION

.TAX35

 LDA INWK               \ ???
 ORA INWK+3
 ORA INWK+6
 BNE P%+7

 LDA #&50
 JSR OOPS

 LDX #&04
 BNE TA87

ENDIF

.TA34

                        \ If we get here, the missile is hostile

 LDA #0                 \ Set A to x_hi OR y_hi OR z_hi
 JSR MAS4

 BEQ P%+5               \ If A = 0 then the missile is very close to our ship,
                        \ so skip the following instruction

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 JMP TA21               \ Jump down to part 3 to set up the vectors and skip
                        \ straight to aggressive manoeuvring

ELIF _MASTER_VERSION

 JMP TN4                \ ???

ENDIF

 JSR TA87+3             \ The missile has hit our ship, so call TA87+3 to set
                        \ bit 7 of the missile's byte #31, which marks the
                        \ missile as being killed

 JSR EXNO3              \ Make the sound of the missile exploding

 LDA #250               \ Call OOPS to damage the ship by 250, which is a pretty
 JMP OOPS               \ big hit, and return from the subroutine using a tail
                        \ call

.TA18

                        \ This is the entry point for missile tactics and is
                        \ called from the main TACTICS routine below

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 LDA ECMA               \ If an E.C.M. is currently active (either our's or an
 BNE TA35               \ opponent's), jump to TA35 to destroy this missile

ELIF _MASTER_VERSION


 LDA ECMA               \ If an E.C.M. is currently active (either our's or an
 BNE TAX35              \ opponent's), jump to TAX35 to ???

ENDIF

 LDA INWK+32            \ Fetch the AI flag from byte #32 and if bit 6 is set
 ASL A                  \ (i.e. missile is hostile), jump up to TA34 to check
 BMI TA34               \ whether the missile has hit us

 LSR A                  \ Otherwise shift A right again. We know bits 6 and 7
                        \ are now clear, so this leaves bits 0-5. Bits 1-5
                        \ contain the target's slot number, and bit 0 is cleared
                        \ in FRMIS when a missile is launched, so A contains
                        \ the slot number shifted left by 1 (i.e. doubled) so we
                        \ can use it as an index for the two-byte address table
                        \ at UNIV

IF _CASSETTE_VERSION \ Minor: This does exactly the same, but some code has moved into the VCSUB routine

 TAX                    \ Copy the address of the target ship's data block from
 LDA UNIV,X             \ UNIV(X+1 X) to V(1 0)
 STA V
 LDA UNIV+1,X
 STA V+1

 LDY #2                 \ K3(2 1 0) = (x_sign x_hi x_lo) - x-coordinate of
 JSR TAS1               \ target ship

 LDY #5                 \ K3(5 4 3) = (y_sign y_hi z_lo) - y-coordinate of
 JSR TAS1               \ target ship

 LDY #8                 \ K3(8 7 6) = (z_sign z_hi z_lo) - z-coordinate of
 JSR TAS1               \ target ship

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 TAX                    \ Copy the address of the target ship's data block from
 LDA UNIV,X             \ UNIV(X+1 X) to (A V)
 STA V
 LDA UNIV+1,X

 JSR VCSUB              \ Calculate vector K3 as follows:
                        \
                        \ K3(2 1 0) = (x_sign x_hi x_lo) - x-coordinate of
                        \ target ship
                        \
                        \ K3(5 4 3) = (y_sign y_hi z_lo) - y-coordinate of
                        \ target ship
                        \
                        \ K3(8 7 6) = (z_sign z_hi z_lo) - z-coordinate of
                        \ target ship

ENDIF

                        \ So K3 now contains the vector from the target ship to
                        \ the missile

 LDA K3+2               \ Set A = OR of all the sign and high bytes of the
 ORA K3+5               \ above, clearing bit 7 (i.e. ignore the signs)
 ORA K3+8
 AND #%01111111
 ORA K3+1
 ORA K3+4
 ORA K3+7

 BNE TA64               \ If the result is non-zero, then the missile is some
                        \ distance from the target, so jump down to TA64 see if
                        \ the target activates its E.C.M.

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 LDA INWK+32            \ Fetch the AI flag from byte #32 and if only bits 7 and
 CMP #%10000010         \ 1 are set (AI is enabled and the target is slot 1, the
 BEQ TA35               \ space station), jump to TA35 to destroy this missile,
                        \ as the space station ain't kidding around

ELIF _MASTER_VERSION

 LDA INWK+32            \ Fetch the AI flag from byte #32 and if only bits 7 and
 CMP #%10000010         \ 1 are set (AI is enabled and the target is slot 1, the
 BEQ TAX35               \ space station), jump to TAX35 to ???

ENDIF

 LDY #31                \ Fetch byte #31 (the exploding flag) of the target ship
 LDA (V),Y              \ into A

 BIT M32+1              \ M32 contains an LDY #32 instruction, so M32+1 contains
                        \ 32, so this instruction tests A with %00100000, which
                        \ checks bit 5 of A (the "already exploding?" bit)

 BNE TA35               \ If the target ship is already exploding, jump to TA35
                        \ to destroy this missile

 ORA #%10000000         \ Otherwise set bit 7 of the target's byte #31 to mark
 STA (V),Y              \ the ship as having been killed, so it explodes

.TA35

 LDA INWK               \ Set A = x_lo OR y_lo OR z_lo of the missile
 ORA INWK+3
 ORA INWK+6

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

 BNE TA87               \ If A is non-zero then the missile is not near our
                        \ ship, so jump to TA87 to skip damaging our ship

ELIF _MASTER_VERSION

 BNE P%+7               \ If A is non-zero then the missile is not near our
                        \ ship, so skip the next two instructions to avoid
                        \ damaging our ship

ENDIF

 LDA #80                \ Otherwise the missile just got destroyed near us, so
 JSR OOPS               \ call OOPS to damage the ship by 80, which is nowhere
                        \ near as bad as the 250 damage from a missile slamming
                        \ straight into us, but it's still pretty nasty

IF _MASTER_VERSION

 LDA INWK+32            \ ???
 AND #%01111111
 LSR A
 TAX

ENDIF

.TA87

 JSR EXNO2              \ Call EXNO2 to process the fact that we have killed a
                        \ missile (so increase the kill tally, make an explosion
                        \ sound and so on)

 ASL INWK+31            \ Set bit 7 of the missile's byte #31 flag to mark it as
 SEC                    \ having been killed, so it explodes
 ROR INWK+31

.TA1

 RTS                    \ Return from the subroutine

.TA64

                        \ If we get here then the missile has not reached the
                        \ target

 JSR DORND              \ Set A and X to random numbers

IF _CASSETTE_VERSION \ Minor

 CMP #16                \ If A >= 16 (94% chance), jump down to TA19 with the
 BCS TA19               \ vector from the target to the missile in K3

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 CMP #16                \ If A >= 16 (94% chance), jump down to TA19S with the
 BCS TA19S              \ vector from the target to the missile in K3

ENDIF

.M32

 LDY #32                \ Fetch byte #32 for the target and shift bit 0 (E.C.M.)
 LDA (V),Y              \ into the C flag
 LSR A

IF _CASSETTE_VERSION \ Minor

 BCC TA19               \ If the C flag is clear then the target does not have
                        \ E.C.M. fitted, so jump down to TA19 with the vector
                        \ from the target to the missile in K3

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

 BCS P%+5               \ If the C flag is set then the target has E.C.M.
                        \ fitted, so skip the next instruction

.TA19S

 JMP TA19               \ The target does not have E.C.M. fitted, so jump down
                        \ to TA19 with the vector from the target to the missile
                        \ in K3

ENDIF

 JMP ECBLB2             \ The target has E.C.M., so jump to ECBLB2 to set it
                        \ off, returning from the subroutine using a tail call

