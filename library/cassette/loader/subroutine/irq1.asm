\ ******************************************************************************
\
\       Name: IRQ1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: The loader's screen-mode interrupt handler (IRQ1V points here)
\  Deep dive: The split-screen mode in BBC Micro Elite
\
\ ------------------------------------------------------------------------------
\
\ The main interrupt handler, which implements Elite's split-screen mode.
\
\ This routine is similar to the main IRQ1 routine in the main game code, except
\ it's a bit simpler (it doesn't need to support the mode-flashing effect of
\ hyperspace, for example).
\
\ It also sets Timer 1 to a different value, 14386 instead of 14622. The split
\ in the split-screen mode does overlap more in the loader than in the game, so
\ it's interesting that they didn't fine-tune this version as much.
\
\ For more details on how the following works, see the IRQ1 routine in the main
\ game code.
\
\ ******************************************************************************

.VIA2

 LDA #%00000100         \ Set the Video ULA control register (SHEILA &20) to
 STA &FE20              \ %00000100, which is the same as switching to mode 5,
                        \ (i.e. the bottom part of the screen) but with no
                        \ cursor

 LDY #11                \ We now apply the palette bytes from block1 to the
                        \ mode 5 screen, so set a counter in Y for 12 bytes

.inlp1

 LDA block1,Y           \ Copy the Y-th palette byte from block1 to SHEILA &21
 STA &FE21              \ to map logical to actual colours for the bottom part
                        \ of the screen (i.e. the dashboard)

 DEY                    \ Decrement the palette byte counter

 BPL inlp1              \ Loop back to the inlp1 until we have copied all the
                        \ palette bytes

 PLA                    \ Restore Y from the stack
 TAY

 JMP (VEC)              \ Jump to the address in VEC, which was set to the
                        \ original IRQ1V vector in part 4, so this instruction
                        \ passes control to the next interrupt handler

.IRQ1

 TYA                    \ Store Y on the stack
 PHA

IF PROT AND NOT(DISC)

                        \ By this point, we have set up the following in
                        \ various places throughout the loader code (such as
                        \ part 2 and PLL1):
                        \
                        \   BLPTR(1 0) = &03CA
                        \   BLN(1 0)   = &03C6
                        \   EXCN(1 0)  = &03C2
                        \
                        \ BLPTR (&03CA) is a byte in the MOS workspace that
                        \ stores the block flag of the most recent block loaded
                        \ from tape
                        \
                        \ BLN (&03C6) is the low byte of the number of the last
                        \ block loaded from tape
                        \
                        \ EXCN (&03C2) is the low byte of the execution address
                        \ of the file being loaded

 LDY #0                 \ Set A to the block flag of the most recent block
 LDA (BLPTR),Y          \ loaded from tape

 BIT M2                 \ If bit 1 of the block flag is set, jump to itdone
 BNE itdone

 EOR #%10000011         \ Otherwise flip bits 0, 1 and 7 of A. This has two
                        \ main effects:
                        \
                        \   * Bit 0 of the block flag gets cleared. Most
                        \     cassette versions of Acornsoft games are saved to
                        \     tape with locked blocks, so you can't just load
                        \     the game into memory (you'll get a "Locked" error
                        \     for each block). Locked blocks have bit 0 set, so
                        \     this clears the locked status, so when the MOS
                        \     gets round to checking whether the block is
                        \     locked, we've already cleared it and updated it in
                        \     memory (which we do below), so the block loads
                        \     without throwing an error
                        \
                        \   * Bit 1 of the block flag gets set, so we won't
                        \     increment BLCNT again until the next block starts
                        \     loading (so in this way we count the number of
                        \     blocks loaded in BLCNT)

 INC BLCNT              \ Increment BLCNT, which was initialised to 0 in part 3

 BNE ZQK                \ If BLCNT is non-zero, skip the next instruction

 DEC BLCNT              \ If incrementing BLCNT set it to zero, decrement it, so
                        \ this sets a maximum of 255 on BLCNT

.ZQK

 STA (BLPTR),Y          \ Store the updated value of A in the block flag, so the
                        \ block gets unlocked

 LDA #35                \ If the block number in BLN is 35, skip the next
 CMP (BLN),Y            \ instruction, leaving A = 32 = &23
 BEQ P%+4

 EOR #17                \ Set A = 35 EOR 17 = 50 = &32

 CMP (EXCN),Y           \ If the low byte of the execution address of the file
 BEQ itdone             \ we are loading is equal to A (which is either &23 or
                        \ &32), skip to itdone

 DEC LOAD%              \ Otherwise decrement LOAD%, which is the address of the
                        \ first byte of the main game code file (i.e. the load
                        \ address of "ELTcode"), so this decrements the first
                        \ byte of the file we are loading, i.e. the LBL variable
                        \ added by the Big Code File source

.itdone

ENDIF

 LDA VIA+&4D            \ Read the 6522 System VIA status byte bit 1 (SHEILA
 BIT M2                 \ &4D), which is set if vertical sync has occurred on
                        \ the video system

 BNE LINSCN             \ If we are on the vertical sync pulse, jump to LINSCN
                        \ to set up the timers to enable us to switch the
                        \ screen mode between the space view and dashboard

 AND #%01000000         \ If the 6522 System VIA status byte bit 6 is set, which
 BNE VIA2               \ means timer 1 has timed out, jump to VIA2

 PLA                    \ Restore Y from the stack
 TAY

 JMP (VEC)              \ Jump to the address in VEC, which was set to the
                        \ original IRQ1V vector in part 4, so this instruction
                        \ passes control to the next interrupt handler

.LINSCN

 LDA #50                \ Set 6522 System VIA T1C-L timer 1 low-order counter
 STA VIA+&44            \ (SHEILA &44) to 50

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (56) to start the T1 counter
                        \ counting down from 14386 at a rate of 1 MHz

 LDA #8                 \ Set the Video ULA control register (SHEILA &20) to
 STA &FE20              \ %00001000, which is the same as switching to mode 4
                        \ (i.e. the top part of the screen) but with no cursor

 LDY #11                \ We now apply the palette bytes from block2 to the
                        \ mode 4 screen, so set a counter in Y for 12 bytes

.inlp2

 LDA block2,Y           \ Copy the Y-th palette byte from block2 to SHEILA &21
 STA &FE21              \ to map logical to actual colours for the top part of
                        \ the screen (i.e. the space view)

 DEY                    \ Decrement the palette byte counter

 BPL inlp2              \ Loop back to the inlp1 until we have copied all the
                        \ palette bytes

 PLA                    \ Restore Y from the stack
 TAY

 JMP (VEC)              \ Jump to the address in VEC, which was set to the
                        \ original IRQ1V vector in part 4, so this instruction
                        \ passes control to the next interrupt handler

