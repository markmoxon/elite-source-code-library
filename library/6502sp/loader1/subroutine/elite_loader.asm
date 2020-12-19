\ ******************************************************************************
\
\       Name: Elite loader
\       Type: Subroutine
\   Category: Loader
\    Summary: Check for a 6502 Second Processor, perform a number of OS calls,
\             set up sound and run the second loader
\
\ ******************************************************************************

.ENTRY

 CLD                    \ Clear the decimal flag, so we're not in decimal mode

 LDA #129               \ Call OSBYTE with A = 129, X = 0 and Y = &FF to detect
 LDX #0                 \ the machine type. This call is undocumented and is not
 LDY #&FF               \ the recommended way to determine the machine type
 JSR OSBYTE             \ (OSBYTE 0 is the correct way), but this call returns
                        \ the following:
                        \
                        \   * X = Y = 0   if this is a BBC Micro with MOS 0.1
                        \   * X = Y = &FF if this is a BBC Micro with MOS 1.20

 TXA                    \ If X is non-zero then jump to not0, as this is not MOS
 BNE not0               \ 0.1

 TYA                    \ If Y is non-zero then jump to not0, as this is not MOS
 BNE not0               \ 0.1

 JMP happy              \ If we get here then this is a BBC Micro Model B with
                        \ MOS 0.1, so jump to happy to continue the loading
                        \ process (which is a bit odd as Elite doesn't work on
                        \ MOS 0.1, so this just tries to load the game, which
                        \ fails)

.not0

                        \ If we get here, then this is not MOS 0.1. We now jump
                        \ to blap2 only if X = &FF and Y = &FF

 INX                    \ Increment X, which will give us zero if X was &FF

 BNE blap1              \ If X is non-zero, then X was not &FF before the
                        \ increment, so jump to blap1

 INY                    \ Increment Y, which will give us zero if Y was &FF

 BEQ blap2              \ If Y is now 0, jump to blap2 for further checks

.blap1

 JMP happy              \ If we get here then this is not a BBC Micro with MOS
                        \ 1.20... so we jump to happy to continue the loading
                        \ process, which is again a bit odd, as the game won't
                        \ actually work (if you load this version of the game
                        \ on a Master or BBC B+, it will try to run the game
                        \ rather than giving an error - most odd)

\JSR ZZZAP              \ These instructions are commented out in the original
\BRK                    \ source
\BRK
\EQUS " This program only runs on a BBC Micro with 6502 Second Processor"
\EQUW &0C0A
\BRK

.blap2

                        \ If we get here then this is a BBC Micro with MOS 1.20,
                        \ and we arrive here with X = 0 and Y = 0

 LDA #234               \ Call OSBYTE with A = 234, X = 0 and Y = &FF, which
 DEY                    \ detects whether Tube hardware is present, returning
 JSR OSBYTE             \ X = 0 (not present) or X = &FF (present)

 TXA                    \ If X is non-zero (Tube is present) then jump to happy
 BNE happy              \ to continue the loading process

 JSR ZZZAP              \ Otherwise the Tube is not present, and we can't run
                        \ the game, so call ZZZAP to blank out memory

 BRK                    \ Execute a BRK instruction to display the following
                        \ system error, and stop everything

 BRK
 EQUS "This program needs a 6502 Second Processor"
 EQUW &0D0A
 BRK

.ZZZAP

                        \ The following blanks out memory, so crackers can't
                        \ just unplug their Tube, run the game, get an error
                        \ message and then poke around in memory to discover
                        \ the loader's secrets

 LDA #LO(happy)         \ Set the low byte of ZP(1 0) to the low byte of happy
 STA ZP

 LDX #HI(happy)         \ Set X to the high byte of happy, to act as a page
                        \ counter

 LDY #0                 \ Set Y = 0 to act as a byte counter

.ZZZAPL

 STX ZP+1               \ Set the high byte of ZP(1 0) to X, so ZP(1 0) starts
                        \ by pointing to the location happy, and will increase
                        \ by a page every time we increment X

 STA (ZP),Y             \ Store A (we don't care what it contains) in the Y-th
                        \ byte of the block pointed to be ZP(1 0)

 INY                    \ Increment the byte counter

 BNE ZZZAPL             \ Loop back until we reach a page boundary

 INX                    \ Increment the page counter to point to the next page

 CPX #(HI(MESS2)+1)     \ Loop back until we have filled up to the end of the
 BNE ZZZAPL             \ page containing MESS2, which is at the end of the
                        \ loader code

 RTS                    \ Return from the subroutine

.happy

                        \ If we get here, then one of the following is true:
                        \
                        \   * This is a BBC Micro Model B with MOS 0.1
                        \     (X = Y = 0)
                        \
                        \   * This is not a BBC Micro with MOS 1.20
                        \     (X <> &FF and Y <> &FF)
                        \
                        \   * This is a BBC Micro with MOS 1.20 and the Tube
                        \     (X = Y = &FF and Tube hardware is detected)
                        \
                        \ The odd thing is that the game only works on the last
                        \ system, so you would think that the first two would
                        \ give an error... but instead, we try to run the game
                        \ and fail, which is all a bit strange
                        \
                        \ That's what you get for using undocumented calls...

 LDA #16                \ Call OSBYTE with A = 16 and X = 3 to set the ADC to
 LDX #3                 \ sample 3 channels from the joystick/Bitstik
 JSR OSBYTE

 LDA #190               \ Call OSBYTE with A = 190, X = 8 and Y = 0 to set the
 LDX #8                 \ ADC conversion type to 8 bits, for the joystick
 JSR OSB

 LDA #200               \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDX #3                 \ the ESCAPE key and clear memory if the BREAK key is
 JSR OSB                \ pressed

\LDA #144               \ These instructions are commented out in the original
\LDX #255               \ source, but they would Call OSBYTE with A = 144 and
\JSR OSB                \ Y = 255 to turn the screen interlace off (equivalent
                        \ to a *TV 255, 255 command)

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering u=buffer" event
 JSR OSB

 LDA #LO(B%)            \ Set ZP(1 0) to point to the VDU code table at B%
 STA ZP
 LDA #HI(B%)
 STA ZP+1

 LDY #0                 \ We are now going to send the 67 VDU bytes in the table
                        \ at B% to OSWRCH to set up the special mode 4 screen
                        \ that forms the basis for the split-screen mode

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 LDA #20                \ Call OSBYTE with A = 20, X = 0 and Y = 0 to implode
 LDX #0                 \ the soft character definitions, so they don't take up
 JSR OSB                \ extra memory

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDX #1                 \ cursor editing, so the cursor keys return ASCII values
 JSR OSB                \ and can therefore be used in-game

 LDA #9                 \ Disable flashing colours (via OSBYTE 9)
 LDX #0
 JSR OSB

 JSR PLL1               \ Call PLL1 to draw Saturn

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS2 ("DIR E")
 LDY #HI(MESS1)

 JSR SCLI               \ Call SCLI to run the OS command in MESS1, which
                        \ changes the disc directory to E

 LDX #LO(MESS2)         \ Set (Y X) to point to MESS2 ("R.I.ELITEa")
 LDY #HI(MESS2)

 JMP SCLI               \ Call SCLI to run the OS command in MESS2, which *RUNs
                        \ the second loader in I.ELITEa, returning from the
                        \ subroutine using a tail call

