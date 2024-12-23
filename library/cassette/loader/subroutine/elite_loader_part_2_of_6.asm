\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Perform a number of OS calls, set up sound, push routines on stack
\
\ ------------------------------------------------------------------------------
\
\ This part of the loader does a number of calls to OS routines, sets up the
\ sound envelopes, pushes 33 bytes onto the stack that will be used later, and
\ sends us on a wild goose chase, just for kicks.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   Ian1                Re-entry point following the wild goose chase
\                       obfuscation
\
\ ******************************************************************************

.ENTRY

 SEI                    \ Disable all interrupts

 CLD                    \ Clear the decimal flag, so we're not in decimal mode

IF NOT(DISC)

 LDA #0                 \ Call OSBYTE with A = 0 and X = 255 to fetch the
 LDX #255               \ operating system version into X
 JSR OSBYTE

 TXA                    \ If X = 0 then this is OS 1.00, so jump down to OS100
 BEQ OS100              \ to skip the following

 LDY &FFB6              \ Otherwise this is OS 1.20, so set Y to the contents of
                        \ &FFB6, which contains the length of the default vector
                        \ table

 LDA &FFB7              \ Set ZP(1 0) to the location stored in &FFB7-&FFB8,
 STA ZP                 \ which contains the address of the default vector table
 LDA &FFB8
 STA ZP+1

 DEY                    \ Decrement Y so we can use it as an index for setting
                        \ all the vectors to their default states

.ABCDEFG

 LDA (ZP),Y             \ Copy the Y-th byte from the default vector table into
 STA &0200,Y            \ the vector table in &0200

 DEY                    \ Decrement the loop counter

 BPL ABCDEFG            \ Loop back for the next vector until we have done them
                        \ all

.OS100

ENDIF

 LDA #%01111111         \ Set 6522 System VIA interrupt enable register IER
 STA &FE4E              \ (SHEILA &4E) bits 0-6 (i.e. disable all hardware
                        \ interrupts from the System VIA)

 STA &FE6E              \ Set 6522 User VIA interrupt enable register IER
                        \ (SHEILA &6E) bits 0-6 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA &FFFC              \ Fetch the low byte of the reset address in &FFFC,
                        \ which will reset the machine if called

 STA &0200              \ Set the low bytes of USERV, BRKV, IRQ2V and EVENTV
 STA &0202
 STA &0206
 STA &0220

 LDA &FFFD              \ Fetch the high byte of the reset address in &FFFD,
                        \ which will reset the machine if called

 STA &0201              \ Set the high bytes of USERV, BRKV, IRQ2V and EVENTV
 STA &0203
 STA &0207
 STA &0221

 LDX #&2F-2             \ We now step through all the vectors from &0204 to
                        \ &022F and OR their high bytes with &C0, so they all
                        \ point into the MOS ROM space (which is from &C000 and
                        \ upwards), so we set a counter in X to count through
                        \ them

.purge

 LDA &0202,X            \ Set the high byte of the vector in &0202+X so it
 ORA #&C0               \ points to the MOS ROM
 STA &0202,X

 DEX                    \ Increment the counter to point to the next high byte
 DEX

 BPL purge              \ Loop back until we have done all the vectors

 LDA #&60               \ Store an RTS instruction in location &0232
 STA &0232

 LDA #&2                \ Point the NETV vector to &0232, which we just filled
 STA NETV+1             \ with an RTS
 LDA #&32
 STA NETV

 LDA #&20               \ Set A to the op code for a JSR call with absolute
                        \ addressing

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &D0 &66, or BIT &66D0, which does nothing apart
                        \ from affect the flags

.Ian1

 BNE David3             \ This instruction is skipped if we came from above,
                        \ otherwise this is part of the multi-jump obfuscation
                        \ in PROT1

 STA David2             \ Store &20 in location David2, which modifies the
                        \ instruction there (see David2 for details)

 LSR A                  \ Set A = 16

 LDX #3                 \ Set the high bytes of BLPTR(1 0), BLN(1 0) and
 STX BLPTR+1            \ EXCN(1 0) to &3. We will fill in the high bytes in
 STX BLN+1              \ the PLL1 routine, and will then use these values in
 STX EXCN+1             \ the IRQ1 handler

 DEX                    \ Set X = 2

 JSR OSBYTE             \ Call OSBYTE with A = 16 and X = 2 to set the ADC to
                        \ sample 2 channels from the joystick

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &D0 &A1, or BIT &A1D0, which does nothing apart
                        \ from affect the flags

.FRED1

 BNE David7             \ This instruction is skipped if we came from above,
                        \ otherwise this is part of the multi-jump obfuscation
                        \ in PROT1

 LDX #255               \ Call doPROT1 to change an instruction in the PROT1
 LDA #&48               \ routine and set up another couple of variables
 JSR doPROT1

 LDA #144               \ Call OSBYTE with A = 144, X = 255 and Y = 0 to move
 JSR OSB                \ the screen down one line and turn screen interlace on

 LDA #247               \ Call OSBYTE with A = 247 and X = Y = 0 to disable the
 LDX #0                 \ BREAK intercept code by poking 0 into the first value
 JSR OSB

\LDA #129               \ These instructions are commented out in the original
\LDY #255               \ source, along with the comment "Damn 0.1", so
\LDX #1                 \ presumably MOS version 0.1 was a bit of a pain to
\JSR OSBYTE             \ support - which is probably why Elite doesn't bother
\                       \ and only supports 1.0 and 1.2
\TXA
\
\BPL OS01
\
\Damn 0.1

 LDA #190               \ Call OSBYTE with A = 190, X = 8 and Y = 0 to set the
 LDX #8                 \ ADC conversion type to 8 bits, for the joystick
 JSR OSB

 EQUB &2C               \ Skip the next instruction by turning it into
                        \ &2C &D0 &E1, or BIT &E1D0, which does nothing apart
                        \ from affect the flags

.David8

 BNE FRED1              \ This instruction is skipped if we came from above,
                        \ otherwise this is part of the multi-jump obfuscation
                        \ in PROT1

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&C                \ type &C with argument &FF, which is the "NMI claim"
 LDY #&FF               \ service call that asks the current user of the NMI
 JSR OSBYTE             \ space to clear it out

 LDA #13                \ Set A = 13 for the next OSBYTE call

.abrk

 LDX #0                 \ Call OSBYTE with A = 13, X = 0 and Y = 0 to disable
 JSR OSB                \ the "output buffer empty" event

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #255
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 LDA #200               \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDX #3                 \ the ESCAPE key and clear memory if the BREAK key is
 JSR OSB                \ pressed

IF PROT AND NOT(DISC)

 CPX #3                 \ If the previous value of X from the call to OSBYTE 200
 BNE abrk+1             \ was not 3 (ESCAPE disabled, clear memory), jump to
                        \ abrk+1, which contains a BRK instruction which will
                        \ reset the computer (as we set BRKV to point to the
                        \ reset address above)

ENDIF

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering keyboard buffer" event
 JSR OSB

.OS01

 LDX #&FF               \ Set the stack pointer to &01FF, which is the standard
 TXS                    \ location for the 6502 stack, so this instruction
                        \ effectively resets the stack

 INX                    \ Set X = 0, to use as a counter in the following loop

.David3

 LDA BEGIN%,X           \ This routine pushes 33 bytes from BEGIN% onto the
                        \ stack, so fetch the X-th byte from BEGIN%

.PROT1

 INY                    \ This instruction gets changed to a PHA instruction by
                        \ the doPROT1 routine that's called above, so by the
                        \ time we get here, this instruction actually pushes the
                        \ X-th byte from BEGIN% onto the stack

 INX                    \ Increment the loop counter

 CPX #LEN               \ If X < #LEN (which is 33), loop back for the next one.
 BNE David8             \ This branch actually takes us on a wild goose chase
                        \ through the following locations, where each BNE is
                        \ prefaced by an EQUB &2C that disables the branch
                        \ instruction during the normal instruction flow:
                        \
                        \   David8 -> FRED1 -> David7 -> Ian1 -> David3
                        \
                        \ so in the end this just loops back to push the next
                        \ byte onto the stack, but in a really sneaky way

 LDA #LO(B%)            \ Set the low byte of ZP(1 0) to point to the VDU code
 STA ZP                 \ table at B%

 LDA #&C8               \ Poke &C8 into PROT1 to change the instruction that we
 STA PROT1              \ modified back to an INY instruction, rather than a PHA

 LDA #HI(B%)            \ Set the high byte of ZP(1 0) to point to the VDU code
 STA ZP+1               \ table at B%

 LDY #0                 \ We are now going to send the N% VDU bytes in the table
                        \ at B% to OSWRCH to set up the special mode 4 screen
                        \ that forms the basis for the split-screen mode

.LOOP

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE LOOP               \ all (the number of bytes was set in N% above)

 LDA #1                 \ In doPROT1 above we set V219(1 0) = &0218, so this
 TAX                    \ code sets the contents of &0219 (the high byte of
 TAY                    \ BPUTV) to 1. We will see why this later, at the start
 STA (V219),Y           \ of part 4

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 JSR OSB                \ cursor editing, so the cursor keys return ASCII values
                        \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

 LDA #&6C               \ Poke &6C into crunchit after EOR'ing it first (which
 EOR crunchit           \ has no effect as crunchit contains a BRK instruction
 STA crunchit           \ with opcode 0), to change crunchit to an indirect JMP

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

