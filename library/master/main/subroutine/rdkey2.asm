\ ******************************************************************************
\
\       Name: RDKEY2
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a flight key and update the key logger
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   X                   If a key is being pressed, X contains the internal key
\                       number, otherwise it contains 0
\
\ ******************************************************************************

.RDKEY2

 JSR U%                 \ Call U% to clear the key logger, which also sets X to
                        \ 0 (so we can use X as an index for working our way
                        \ through the flight keys in RDK3 below)

 LDA #16                \ Start the scan with internal key number 16 ("Q")

 CLC                    \ Clear the C flag so we can do the additions below

.RDK1

 LDY #%00000011         \ Set Y to %00000011, so it's ready to send to SHEILA
                        \ once interrupts have been disabled

 SEI                    \ Disable interrupts so we can scan the keyboard
                        \ without being hijacked

 STY VIA+&40            \ Set 6522 System VIA output register ORB (SHEILA &40)
                        \ to %00000011 to stop auto scan of keyboard

 LDY #%01111111         \ Set 6522 System VIA data direction register DDRA
 STY VIA+&43            \ (SHEILA &43) to %01111111. This sets the A registers
                        \ (IRA and ORA) so that:
                        \
                        \   * Bits 0-6 of ORA will be sent to the keyboard
                        \
                        \   * Bit 7 of IRA will be read from the keyboard

 STA VIA+&4F            \ Set 6522 System VIA output register ORA (SHEILA &4F)
                        \ to A, the key we want to scan for; bits 0-6 will be
                        \ sent to the keyboard, of which bits 0-3 determine the
                        \ keyboard column, and bits 4-6 the keyboard row

 LDY VIA+&4F            \ Read 6522 System VIA output register IRA (SHEILA &4F)
                        \ into Y; bit 7 is the only bit that will have changed.
                        \ If the key is pressed, then bit 7 will be set,
                        \ otherwise it will be clear

 LDA #%00001011         \ Set 6522 System VIA output register ORB (SHEILA &40)
 STA VIA+&40            \ to %00001011 to restart auto scan of keyboard

 CLI                    \ Allow interrupts again

 TYA                    \ Transfer Y into A

 BMI RDK3               \ If the key was pressed then Y is negative, so jump to
                        \ RDK3

.RDK2

 ADC #1                 \ Increment A to point to the next key to scan for

 BPL RDK1               \ If A is positive, we still have keys to check, so loop
                        \ back to scan for the next one

                        \ If we get here then no keys are being pressed

 CLD                    \ Clear the D flag to return to binary mode (for cases
                        \ where this routine is called in BCD mode)

 LDA KY6                \ If KY6 ("S") is being pressed, then KY6 is &FF, and
 EOR #&FF               \ KY6 EOR &FF AND KY19 will be zero, so this stops "C"
 AND KY19               \ from being registered as being pressed if "S" is being
 STA KY19               \ pressed. This code isn't necessary on a BBC Master, as
                        \ it's from other versions of Elite where there were
                        \ issues with "ghost keys", which the Master didn't have

 LDA KL                 \ Fetch the last key pressed from KL

 TAX                    \ Copy the key value into X

 RTS                    \ Return from the subroutine

.RDK3

                        \ If we get here then the key in A is being pressed. We
                        \ now work our way through the KYTB table, looking for
                        \ a match against the flight keys, using X as an index
                        \ into the table (X was initialised to 0 by the call to
                        \ U% above, and it keeps track of our progress through
                        \ the table between calls to RDK3)

 EOR #%10000000         \ The key in A is being pressed and the number of the
                        \ key is in A with bit 7 set, so flip bit 7 back to 0

 STA KL                 \ Store the number of the key pressed in KL

                        \ Now to scan the KYTB table for a possible match for
                        \ the pressed key (if we get a match we update the key
                        \ logger, as KYTB contains the flight keys that have
                        \ key logger entries. Because we are scanning the
                        \ keyboard by incrementing the key to check in A, and
                        \ the KYTB table is sorted in increasing order, we don't
                        \ need to scan the whole KYTB table each time for a
                        \ match, we can just check against the next key in the
                        \ table, as pointed to by X

.DKL5

 CMP KYTB,X             \ If A is less than the X-th byte in KYTB, jump back to
 BCC RDK2               \ RDK2 to continue scanning for more keys, as this key
                        \ isn't in the KYTB table and doesn't have an entry in
                        \ the key logger

 BEQ P%+5               \ If A is equal to the X-th byte in KYTB, we have a
                        \ match, so skip the next two instructions to go to the
                        \ part where we update the key logger

 INX                    \ The pressed key is higher than the KYTB entry at X, so
                        \ increment X to point to the next key in the table

 BNE DKL5               \ And loop back to DKL5 to test against this next flight
                        \ key in KYTB (this BNE is effectively a JMP as X won't
                        \ get high enough to wrap around to zero)

                        \ If we get here, the pressed key has an entry in the
                        \ key logger, so now to update the logger

 DEC KY17,X             \ We got a match in the KYTB table for our key at
                        \ position X, so we decrement the corresponding key
                        \ logger byte for this key at KY17+X (KY17 is the first
                        \ key in the key logger)

 INX                    \ Increment X so next time we check KYTB from the next
                        \ key in the table

 CLC                    \ Clear the C flag so we can do more additions

 BCC RDK2               \ Jump back to RDK2 to continue scanning for more keys
                        \ (this BCC is effectively a JMP as we just cleared the
                        \ C flag)

