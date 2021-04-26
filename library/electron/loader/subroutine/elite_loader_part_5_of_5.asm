\ ******************************************************************************
\
\       Name: Elite loader (Part 5 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Set up interrupt vectors, calculate checksums, run main game code
\
\ ------------------------------------------------------------------------------
\
\ This is the final part of the loader. It sets up some of the main game's
\ interrupt vectors and calculates various checksums, before finally handing
\ over to the main game.
\
\ ******************************************************************************

 EQUD &10101010         \ This data appears to be unused
 EQUD &10101010
 EQUD &10101010
 EQUD &10101010
 EQUB &10

.ENTRY2

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("LOAD EliteCo FFFF2000")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which loads
                        \ the maon game code at location &2000

 LDA #3                 \ Directly update &0258, the memory location associated
 STA &0258              \ with OSBYTE 200, so this is the same as calling OSBYTE
                        \ with A = 200, X = 3 and Y = 0 to disable the ESCAPE
                        \ key and clear memory if the BREAK key is pressed

 LDA #140               \ Call OSBYTE with A = 140 and X = 12 to select the
 LDX #12                \ tape filing system (i.e. do a *TAPE command)
 LDY #0
 JSR OSBYTE

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&C                \ type &C with argument &FF, which is the "NMI claim"
 LDY #&FF               \ service call that asks the current user of the NMI
 JSR OSBYTE             \ space to clear it out

 LDA #&40               \ Set S% to an RTI instruction (opcode &40), so we can
 STA S%                 \ claim the NMI workspace at &0D00 (the RTI makes sure
                        \ we return from any spurious NMIs that still call this
                        \ workspace)

 LDX #&4A               \ Set X = &4A, as we want to copy the &4A pages of main
                        \ game code from where we just loaded it at &2000, down
                        \ to &0D00 where we will run it

 LDY #0                 \ Set the source and destination addresses for the copy:
 STY ZP                 \
 STY P                  \   ZP(1 0) = L% = &2000
 LDA #HI(L%)            \   P(1 0) = C% = &0D00
 STA ZP+1               \
 LDA #HI(C%)            \ and set Y = 0 to act as a byte counter in the
 STA P+1                \ following loop

.MVDL

 LDA (ZP),Y             \ Copy the Y-th byte from the source to the Y-th byte of
 STA (P),Y              \ the destination

 LDA #0                 \ Zero the source byte we just copied, so that this loop
 STA (ZP),Y             \ moves the memory block rather than copying it

 INY                    \ Increment the byte counter

 BNE MVDL               \ Loop back until we have copied a whole page of bytes

 INC ZP+1               \ Increment the high bytes of ZP(1 0) and P(1 0) so we
 INC P+1                \ copy bytes from the next page in memory

 DEX                    \ Decrement the page counter in X

 BPL MVDL               \ Loop back to move the next page of bytes until we have
                        \ moved the number of pages in X (this also sets X to
                        \ &FF)

 SEI                    \ Disable all interrupts

 TXS                    \ Set the stack pointer to &01FF, which is the standard
                        \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 LDA RDCHV              \ Set the user vector USERV to the same value as the
 STA USERV              \ read character vector RDCHV
 LDA RDCHV+1
 STA USERV+1

 LDA KEYV               \ Store the current value of the keyboard vector KEYV
 STA S%+4               \ in S%+4
 LDA KEYV+1
 STA S%+5

 LDA #LO(S%+16)         \ Point the keyboard vector KEYV to S%+16 in the main
 STA KEYV               \ game code
 LDA #HI(S%+16)
 STA KEYV+1

 LDA S%+14              \ Point the break vector BRKV to the address stored in
 STA BRKV               \ S%+14 in the main game code
 LDA S%+15
 STA BRKV+1

 LDA S%+10              \ Point the write character vector WRCHV to the address
 STA WRCHV              \ stored in S%+10 in the main game code
 LDA S%+11
 STA WRCHV+1

 LDA IRQ1V              \ Store the current value of the interrupt vector IRQ1V
 STA S%+2               \ in S%+2
 LDA IRQ1V+1
 STA S%+3

 LDA S%+12              \ Point the interrupt vector IRQ1V to the address stored
 STA IRQ1V              \ in S%+12 in the main game code
 LDA S%+13
 STA IRQ1V+1

 LDA #%11111100         \ Clear all interrupts (bits 4-7) and de-select the
 JSR VIA05              \ BASIC ROM (bit 3) by setting the interrupt clear and
                        \ paging register at SHEILA &05

 LDA #%00001000         \ Select ROM 8 (the keyboard) by setting the interrupt
 JSR VIA05              \ clear and paging register at SHEILA &05

 LDA #&60               \ Set the screen start address registers at SHEILA &02
 STA VIA+&02            \ and SHEILA &03 so screen memory starts at &7EC0. This
 LDA #&3F               \ gives us a blank line at the top of the screen (for
 STA VIA+&03            \ the screen memory between &7EC0 and &7FFF, as one row
                        \ of mode 4 is &140 bytes), and then the rest of the
                        \ screen memory from &5800 to &7EBF cover the second
                        \ row and down

 CLI                    \ Re-enable interrupts

 JMP (S%+8)             \ Jump to the address in S%+8 in the main game code,
                        \ which points to TT170, so this starts the game

.VIA05

 STA &00F4              \ Store A in &00F4

 STA VIA+&05            \ Set the value of the interrupt clear and paging
                        \ register at SHEILA &05 to A

 RTS                    \ Return from the subroutine

