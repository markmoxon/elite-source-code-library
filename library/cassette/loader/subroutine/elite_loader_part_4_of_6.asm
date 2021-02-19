\ ******************************************************************************
\
\       Name: Elite loader (Part 4 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy more code onto stack, decrypt TUT block, set up IRQ1 handler
\
\ ------------------------------------------------------------------------------
\
\ This part copies more code onto the stack (from BLOCK to ENDBLOCK), decrypts
\ the code from TUT onwards, and sets up the IRQ1 handler for the split-screen
\ mode.
\
\ ******************************************************************************

 STY David3-2           \ Y was set to 0 above, so this modifies the OS01
                        \ routine above by changing the TXS instruction to BRK,
                        \ so calls to OS01 will now do this:
                        \
                        \   LDX #&FF
                        \   BRK
                        \
                        \ This is presumably just to confuse any cracker, as we
                        \ don't call OS01 again

                        \ We now enter a loop that starts with the counter in Y
                        \ (initially set to 0). It calls JSR &01F1 on the stack,
                        \ which pushes the Y-th byte of BLOCK on the stack
                        \ before encrypting the Y-th byte of BLOCK in-place. It
                        \ then jumps back to David5 below, where we increment Y
                        \ until it reaches a value of ENDBLOCK - BLOCK. So this
                        \ loop basically decrypts the code from TUT onwards, and
                        \ at the same time it pushes the code between BLOCK and
                        \ ENDBLOCK onto the stack, so it's there ready to be run
                        \ (at address &0163)

.David2

 EQUB &AC               \ This byte was changed to &20 by part 2, so by the time
 EQUW &FFD4             \ we get here, these three bytes together become JSR
                        \ &FFD4, or JSR OSBPUT. Amongst all the code above,
                        \ we've also managed to set BPUTV to &01F1, and as BPUTV
                        \ is the vector that OSBPUT goes through, these three
                        \ bytes are actually doing JSR &01F1
                        \
                        \ That address is in the stack, and is the address of
                        \ the first routine, that we pushed onto the stack in
                        \ the modified PROT1 routine. That routine doesn't
                        \ return with an RTS, but instead it removes the return
                        \ address from the stack and jumps to David5 below after
                        \ pushing the Y-th byte of BLOCK onto the stack and
                        \ EOR'ing the Y-th byte of TUT with the Y-th byte of
                        \ BLOCK
                        \
                        \ This obfuscation probably kept the crackers busy for a
                        \ while - it's difficult enough to work out when you
                        \ have the source code in front of you!

.LBLa

                        \ If, for some reason, the above JSR doesn't call the
                        \ routine on the stack and returns normally, which might
                        \ happen if crackers manage to unpick the BPUTV
                        \ redirection, then we end up here. We now obfuscate the
                        \ the first 255 bytes of the location where the main
                        \ game gets loaded (which is set in C%), just to make
                        \ things hard, and then we reset the machine... all in
                        \ a completely twisted manner, of course

 LDA C%,X               \ Obfuscate the X-th byte of C% by EOR'ing with &A5
 EOR #&A5
 STA C%,X

 DEX                    \ Decrement the loop counter

 BNE LBLa               \ Loop back until X wraps around, after EOR'ing a whole
                        \ page

 JMP (C%+&CF)           \ C%+&CF is &100F, which in the main game code contains
                        \ an LDA KY17 instruction (it's in the main loader in
                        \ the MA76 section). This has opcode &A5 &4E, and the
                        \ EOR above changes the first of these to &00, so this
                        \ jump goes to a BRK instruction, which in turn goes to
                        \ BRKV, which in turn resets the computer (as we set
                        \ BRKV to point to the reset address in part 2)

.swine2

 JMP swine              \ Jump to swine to reset the machine

 EQUW &4CFF             \ This data doesn't appear to be used

.crunchit

 BRK                    \ This instruction gets changed to an indirect JMP at
 EQUW David23           \ the end of part 2, so this does JMP (David23). David23
                        \ contains &01DF, so these bytes are actually doing JMP
                        \ &01DF. That address is in the stack, and is the
                        \ address of the MVDL routine, which we pushed onto the
                        \ stack in the modified PROT1 routine... so this
                        \ actually does the following:
                        \
                        \   JMP MVDL
                        \
                        \ meaning that this instruction:
                        \
                        \   JSR crunchit
                        \
                        \ actually does this, because it's a tail call:
                        \
                        \   JSR MVDL
                        \
                        \ It's yet another impressive bit of obfuscation and
                        \ misdirection

.RAND

 EQUD &6C785349         \ The random number seed used for drawing Saturn

.David5

 INY                    \ Increment the loop counter

 CPY #(ENDBLOCK-BLOCK)  \ Loop back to copy the next byte until we have copied
 BNE David2             \ all the bytes between BLOCK and ENDBLOCK

 SEI                    \ Disable interrupts while we set up our interrupt
                        \ handler to support the split-screen mode

 LDA #%11000010         \ Clear 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 1 and 7 (i.e. enable CA1 and TIMER1
                        \ interrupts from the System VIA, which enable vertical
                        \ sync and the 1 MHz timer, which we need enabled for
                        \ the split-screen interrupt code to work)

 LDA #%01111111         \ Set 6522 User VIA interrupt enable register IER
 STA &FE6E              \ (SHEILA &6E) bits 0-7 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA IRQ1V              \ Store the low byte of the current IRQ1V vector in VEC
 STA VEC

 LDA IRQ1V+1            \ If the current high byte of the IRQ1V vector is less
 BPL swine2             \ than &80, which means it points to user RAM rather
                        \ the MOS ROM, then something is probably afoot, so jump
                        \ to swine2 to reset the machine

 STA VEC+1              \ Otherwise all is well, so store the high byte of the
                        \ current IRQ1V vector in VEC+1, so VEC(1 0) now
                        \ contains the original address of the IRQ1 handler

 LDA #HI(IRQ1)          \ Set the IRQ1V vector to IRQ1, so IRQ1 is now the
 STA IRQ1V+1            \ interrupt handler
 LDA #LO(IRQ1)
 STA IRQ1V

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (56) to start the T1 counter
                        \ counting down from 14080 at a rate of 1 MHz (this is
                        \ a different value to the main game code)

 CLI                    \ Re-enable interrupts

IF DISC

 LDA #%10000001         \ Clear 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bit 1 (i.e. enable the CA2 interrupt,
                        \ which comes from the keyboard)

 LDY #20                \ Set Y = 20 for the following OSBYTE call

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, skip the OSBYTE call
 NOP
 NOP

ELSE

 JSR OSBYTE             \ A was set to 129 above, so this calls OSBYTE with
                        \ A = 129 and Y = 20, which reads the keyboard with a
                        \ time limit, in this case 20 centiseconds, or 0.2
                        \ seconds

ENDIF

 LDA #%00000001         \ Set 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bit 1 (i.e. disable the CA2 interrupt,
                        \ which comes from the keyboard)

ENDIF

 RTS                    \ This RTS actually does a jump to ENTRY2, to the next
                        \ step of the loader in part 5. See the documentation
                        \ for the stack routine at BEGIN% for more details

