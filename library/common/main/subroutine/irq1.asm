\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Screen mode
\    Summary: The main screen-mode interrupt handler (IRQ1V points here)
\  Deep dive: The split-screen mode
\
\ ------------------------------------------------------------------------------
\
\ The main interrupt handler, which implements Elite's split-screen mode (see
\ the deep dive on "The split-screen mode" for details).
\
\ IRQ1V is set to point to IRQ1 by the loading process.
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   VNT3+1              Changing this byte modifies the palette-loading
\                       instruction at VNT3, to support the #SETVDU19 <offset>
\                       command for changing the mode 1 palette
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

.LINSCN

                        \ This is called from the interrupt handler below, at
                        \ the start of each vertical sync (i.e. when the screen
                        \ refresh starts)

 LDA #30                \ Set the line scan counter to a non-zero value, so
 STA DL                 \ routines like WSCAN can set DL to 0 and then wait for
                        \ it to change to non-zero to catch the vertical sync

 STA VIA+&44            \ Set 6522 System VIA T1C-L timer 1 low-order counter
                        \ (SHEILA &44) to 30

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 LDA HFX                \ If HFX is non-zero, jump to VNT1 to set the mode 5
 BNE VNT1               \ palette instead of switching to mode 4, which will
                        \ have the effect of blurring and colouring the top
                        \ screen. This is how the white hyperspace rings turn
                        \ to colour when we do a hyperspace jump, and is
                        \ triggered by setting HFX to 1 in routine LL164

 LDA #%00001000         \ Set the Video ULA control register (SHEILA &20) to
 STA VIA+&20            \ %00001000, which is the same as switching to mode 4
                        \ (i.e. the top part of the screen) but with no cursor

.VNT3

 LDA TVT1+16,Y          \ Copy the Y-th palette byte from TVT1+16 to SHEILA &21
 STA VIA+&21            \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL VNT3               \ Loop back to VNT3 until we have copied all the
                        \ palette bytes

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Platform

 LDA LASCT              \ Decrement the value of LASCT, but if we go too far
 BEQ P%+5               \ and it becomes negative, bump it back up again (this
 DEC LASCT              \ controls the pulsing of pulse lasers)

ENDIF

IF _CASSETTE_VERSION \ Platform

 LDA SVN                \ If SVN is non-zero, we are in the process of saving
 BNE jvec               \ the commander file, so jump to jvec to pass control
                        \ to the next interrupt handler, so we don't break file
                        \ saving by blocking the interrupt chain

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Minor

 PLA                    \ Otherwise restore Y from the stack
 TAY

 LDA VIA+&41            \ Read 6522 System VIA input register IRA (SHEILA &41)

 LDA &FC                \ Set A to the interrupt accumulator save register,
                        \ which restores A to the value it had on entering the
                        \ interrupt

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

ENDIF

.IRQ1

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Minor

 TYA                    \ Store Y on the stack
 PHA

ELIF _MASTER_VERSION

 PHY                    \ Store Y on the stack

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 LDY #11                \ Set Y as a counter for 12 bytes, to use when setting
                        \ the dashboard palette below

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDY #15                \ Set Y as a counter for 16 bytes, to use when setting
                        \ the dashboard palette below

ENDIF

 LDA #%00000010         \ Read the 6522 System VIA status byte bit 1 (SHEILA
 BIT VIA+&4D            \ &4D), which is set if vertical sync has occurred on
                        \ the video system

 BNE LINSCN             \ If we are on the vertical sync pulse, jump to LINSCN
                        \ to set up the timers to enable us to switch the
                        \ screen mode between the space view and dashboard

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

 BVC jvec               \ Read the 6522 System VIA status byte bit 6, which is
                        \ set if timer 1 has timed out. We set the timer in
                        \ LINSCN above, so this means we only run the next bit
                        \ if the screen redraw has reached the boundary between
                        \ the space view and the dashboard. Otherwise bit 6 is
                        \ clear and we aren't at the boundary, so we jump to
                        \ jvec to pass control to the next interrupt handler

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 ASL A                  \ Double the value in A to 4

 STA VIA+&20            \ Set the Video ULA control register (SHEILA &20) to
                        \ %00000100, which is the same as switching to mode 5,
                        \ (i.e. the bottom part of the screen) but with no
                        \ cursor

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA #%00010100         \ Set the Video ULA control register (SHEILA &20) to
 STA VIA+&20            \ %00010100, which is the same as switching to mode 2,
                        \ (i.e. the bottom part of the screen) but with no
                        \ cursor

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

 LDA ESCP               \ If an escape pod is fitted, jump to VNT1 to set the
 BNE VNT1               \ mode 5 palette differently (so the dashboard is a
                        \ different colour if we have an escape pod)

 LDA TVT1,Y             \ Copy the Y-th palette byte from TVT1 to SHEILA &21
 STA VIA+&21            \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL P%-7               \ Loop back to the LDA TVT1,Y instruction until we have
                        \ copied all the palette bytes

ELIF _6502SP_VERSION OR _MASTER_VERSION

 LDA ESCP               \ Set A = ESCP, which is &FF if we have an escape pod
                        \ fitted, or 0 if we don't

 AND #4                 \ Set A = 4 if we have an escape pod fitted, or 0 if we
                        \ don't

 EOR #&34               \ Set A = &30 if we have an escape pod fitted, or &34 if
                        \ we don't

 STA &FE21              \ Store A in SHEILA &21 to map colour 3 (#YELLOW2) to
                        \ white if we have an escape pod fitted, or yellow if we
                        \ don't, so the outline colour of the dashboard changes
                        \ from yellow to white if we have an escape pod fitted

                        \ The following loop copies bytes #15 to #1 from TVT1 to
                        \ SHEILA &21, but not byte #0, as we just did that
                        \ colour mapping

.VNT2

 LDA TVT1,Y             \ Copy the Y-th palette byte from TVT1 to SHEILA &21
 STA &FE21              \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BNE VNT2               \ Loop back to VNT2 until we have copied all the palette
                        \ bytes bar the first one

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Platform

.jvec

 PLA                    \ Restore Y from the stack
 TAY

 JMP (VEC)              \ Jump to the address in VEC, which was set to the
                        \ original IRQ1V vector by elite-loader.asm, so this
                        \ instruction passes control to the next interrupt
                        \ handler

ELIF _MASTER_VERSION

 LDA VIA+&18            \ ??? A to D joystick status byte (channel?)
 AND #&03
 TAY
 LDA VIA+&19            \ A to D joystick high byte
 STA L12A7,Y
 INY
 TYA
 CMP #&03
 BCC P%+4

 LDA #&00
 STA VIA+&18
 PLY
 LDA VIA+&44

 LDA &FC                \ Restore the value of A from before the call to the
                        \ interrupt handler (the MOS stores the value of A in
                        \ location &FC before calling the interrupt handler)

 RTI

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION \ Screen

.VNT1

 LDY #7                 \ Set Y as a counter for 8 bytes

 LDA TVT1+8,Y           \ Copy the Y-th palette byte from TVT1+8 to SHEILA &21
 STA VIA+&21            \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL VNT1+2             \ Loop back to the LDA TVT1+8,Y instruction until we
                        \ have copied all the palette bytes

 BMI jvec               \ Jump up to jvec to pass control to the next interrupt
                        \ handler (this BMI is effectively a JMP as we didn't
                        \ loop back with the BPL above, so BMI is always true)

ENDIF

IF _6502SP_VERSION \ Screen

.LINSCN

                        \ This is called from the interrupt handler below, at
                        \ the start of each vertical sync (i.e. when the screen
                        \ refresh starts)

 LDA #30                \ Set the line scan counter to a non-zero value, so
 STA DL                 \ routines like WSCAN can set DL to 0 and then wait for
                        \ it to change to non-zero to catch the vertical sync

ELIF _MASTER_VERSION

.LINSCN

 LDA VIA+&41            \ ???

 LDA &FC                \ Fetch the value of A from before the call to the
                        \ interrupt handler (the MOS stores the value of A in
                        \ location &FC before calling the interrupt handler)

 PHA

 LDA DLCNT
 STA DL

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 STA VIA+&44            \ Set 6522 System VIA T1C-L timer 1 low-order counter
                        \ (SHEILA &44) to 30

ENDIF

IF _6502SP_VERSION \ Screen

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

ELIF _MASTER_VERSION

 LDA VSCAN              \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to the contents of VSCAN (57) to start
                        \ the T1 counter counting down from 14622 at a rate of
                        \ 1 MHz

ENDIF

IF _6502SP_VERSION OR _MASTER_VERSION \ Screen

 LDA HFX                \ If the hyperspace effect flag in HFX is non-zero, then
 BNE jvec               \ jump up to jvec to pass control to the next interrupt
                        \ handler, instead of switching the palette to mode 1.
                        \ This will have the effect of blurring and colouring
                        \ the top screen in a mode 2 palette, making the
                        \ hyperspace rings turn multicoloured when we do a
                        \ hyperspace jump. This effect is triggered by the
                        \ parasite issuing a #DOHFX 1 command in routine LL164
                        \ and is disabled again by a #DOHFX 0 command

 LDA #%00011000         \ Set the Video ULA control register (SHEILA &20) to
 STA VIA+&20            \ %00011000, which is the same as switching to mode 1
                        \ (i.e. the top part of the screen) but with no cursor

.VNT3

                        \ The following instruction gets modified in-place by
                        \ the #SETVDU19 <offset> command, which changes the
                        \ value of TVT3+1 (i.e. the low byte of the address in
                        \ the LDA instruction). This changes the palette block
                        \ that gets copied to SHEILA &21, so a #SETVDU19 32
                        \ command applies the third palette from TVT3 in this
                        \ loop, for example

 LDA TVT3,Y             \ Copy the Y-th palette byte from TVT3 to SHEILA &21
 STA VIA+&21            \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BNE VNT3               \ Loop back to VNT3 until we have copied all the
                        \ palette bytes

ENDIF

IF _6502SP_VERSION \ Minor

 PLA                    \ Otherwise restore Y from the stack
 TAY

 LDA VIA+&41            \ Read 6522 System VIA input register IRA (SHEILA &41)

 LDA &FC                \ Set A to the interrupt accumulator save register,
                        \ which restores A to the value it had on entering the
                        \ interrupt

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

ENDIF

IF _MASTER_VERSION \ Platform

.jvec

 PHX                    \ ???
 JSR NOISE2
 PLX

 PLA                    \ Restore A from the stack

 PLY                    \ Restore Y from the stack

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

ENDIF

