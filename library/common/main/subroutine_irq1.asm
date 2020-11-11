\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Screen mode
\    Summary: The main screen-mode interrupt handler (IRQ1V points here)
\
\ ------------------------------------------------------------------------------
\
\ The main interrupt handler, which implements Elite's split-screen mode (see
\ the deep dive on "The split-screen mode" for details).
\
\ IRQ1V is set to point to IRQ1 by elite-loader.asm.
\
\ ******************************************************************************


IF _CASSETTE_VERSION

.LINSCN

                        \ This is called from the interrupt handler below, at
                        \ the start of each vertical sync (i.e. when the screen
                        \ refresh starts)

 LDA #30                \ Set the line scan counter to a non-zero value, so
 STA DL                 \ routines like WSCAN can set DL to 0 and then wait for
                        \ it to change to non-zero to catch the vertical sync

 STA SHEILA+&44         \ Set 6522 System VIA T1C-L timer 1 low-order counter
                        \ (SHEILA &44) to 30

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA SHEILA+&45         \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 LDA HFX                \ If HFX is non-zero, jump to VNT1 to set the mode 5
 BNE VNT1               \ palette instead of switching to mode 4, which will
                        \ have the effect of blurring and colouring the top
                        \ screen. This is how the white hyperspace rings turn
                        \ to colour when we do a hyperspace jump, and is
                        \ triggered by setting HFX to 1 in routine LL164

 LDA #%00001000         \ Set Video ULA control register (SHEILA+&20) to
 STA SHEILA+&20         \ %00001000, which is the same as switching to mode 4
                        \ (i.e. the top part of the screen) but with no cursor

.VNT3

 LDA TVT1+16,Y          \ Copy the Y-th palette byte from TVT1+16 to SHEILA+&21
 STA SHEILA+&21         \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL VNT3               \ Loop back to VNT3 until we have copied all the
                        \ palette bytes

 LDA LASCT              \ Decrement the value of LASCT, but if we go too far
 BEQ P%+5               \ and it becomes negative, bump it back up again (this
 DEC LASCT              \ controls the pulsing of pulse lasers)

 LDA SVN                \ If SVN is non-zero, we are in the process of saving
 BNE jvec               \ the commander file, so jump to jvec to pass control
                        \ to the next interrupt handler, so we don't break file
                        \ saving by blocking the interrupt chain

 PLA                    \ Otherwise restore Y from the stack
 TAY

 LDA SHEILA+&41         \ Read 6522 System VIA input register IRA (SHEILA &41)

 LDA &FC                \ Set A to the interrupt accumulator save register,
                        \ which restores A to the value it had on entering the
                        \ interrupt

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

ENDIF

.^IRQ1

 TYA                    \ Store Y on the stack
 PHA

IF _CASSETTE_VERSION

 LDY #11                \ Set Y as a counter for 12 bytes, to use when setting
                        \ the dashboard palette below

ELIF _6502SP_VERSION

 LDY #15

ENDIF

 LDA #%00000010         \ Read the 6522 System VIA status byte bit 1, which is
 BIT SHEILA+&4D         \ set if vertical sync has occurred on the video system

 BNE LINSCN             \ If we are on the vertical sync pulse, jump to LINSCN
                        \ to set up the timers to enable us to switch the
                        \ screen mode between the space view and dashboard

 BVC jvec               \ Read the 6522 System VIA status byte bit 6, which is
                        \ set if timer 1 has timed out. We set the timer in
                        \ LINSCN above, so this means we only run the next bit
                        \ if the screen redraw has reached the boundary between
                        \ the mode 4 and mode 5 screens (i.e. the top of the
                        \ dashboard). Otherwise bit 6 is clear and we aren't at
                        \ the boundary, so we jump to jvec to pass control to
                        \ the next interrupt handler

IF _CASSETTE_VERSION

 ASL A                  \ Double the value in A to 4

ELIF _6502SP_VERSION

 LDA #&14

ENDIF

 STA SHEILA+&20         \ Set Video ULA control register (SHEILA+&20) to
                        \ %00000100, which is the same as switching to mode 5,
                        \ (i.e. the bottom part of the screen) but with no
                        \ cursor

IF _CASSETTE_VERSION

 LDA ESCP               \ If escape pod fitted, jump to VNT1 to set the mode 5
 BNE VNT1               \ palette differently (so the dashboard is a different
                        \ colour if we have an escape pod)

 LDA TVT1,Y             \ Copy the Y-th palette byte from TVT1 to SHEILA+&21
 STA SHEILA+&21         \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL P%-7               \ Loop back to the LDA TVT1,Y instruction until we have
                        \ copied all the palette bytes

ELIF _6502SP_VERSION

 LDA ESCP
 AND #4
 EOR #&34
 STA &FE21\ESCP

.VNT2

 LDA TVT1,Y
 STA &FE21
 DEY
 BNE VNT2

ENDIF

.jvec

 PLA                    \ Restore Y from the stack
 TAY

 JMP (VEC)              \ Jump to the address in VEC, which was set to the
                        \ original IRQ1V vector by elite-loader.asm, so this
                        \ instruction passes control to the next interrupt
                        \ handler

IF _CASSETTE_VERSION

.VNT1

 LDY #7                 \ Set Y as a counter for 8 bytes

 LDA TVT1+8,Y           \ Copy the Y-th palette byte from TVT1+8 to SHEILA+&21
 STA SHEILA+&21         \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL VNT1+2             \ Loop back to the LDA TVT1+8,Y instruction until we
                        \ have copied all the palette bytes

 BMI jvec               \ Jump up to jvec to pass control to the next interrupt
                        \ handler (this BMI is effectively a JMP as we didn't
                        \ loop back with the BPL above, so BMI is always true)

ELIF _6502SP_VERSION

.LINSCN

                        \ This is called from the interrupt handler below, at
                        \ the start of each vertical sync (i.e. when the screen
                        \ refresh starts)

 LDA #30                \ Set the line scan counter to a non-zero value, so
 STA DL                 \ routines like WSCAN can set DL to 0 and then wait for
                        \ it to change to non-zero to catch the vertical sync

 STA SHEILA+&44         \ Set 6522 System VIA T1C-L timer 1 low-order counter
                        \ (SHEILA &44) to 30

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA SHEILA+&45         \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 LDA HFX
 BNE jvec
 LDA #&18
 STA &FE20

.^VNT3

 LDA TVT3,Y
 STA &FE21
 DEY
 BNE VNT3

 PLA                    \ Otherwise restore Y from the stack
 TAY

 LDA SHEILA+&41         \ Read 6522 System VIA input register IRA (SHEILA &41)

 LDA &FC                \ Set A to the interrupt accumulator save register,
                        \ which restores A to the value it had on entering the
                        \ interrupt

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here


ENDIF


