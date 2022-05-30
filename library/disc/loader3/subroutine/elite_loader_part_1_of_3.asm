\ ******************************************************************************
\
\       Name: Elite loader (Part 1 of 3)
\       Type: Subroutine
\   Category: Loader
\    Summary: Set up the split screen mode, move code around, set up the sound
\             envelopes and configure the system
\
\ ******************************************************************************

.ENTRY

IF NOT(_ELITE_A_VERSION)

 JSR PROT1              \ Call PROT1 to calculate checksums into CHKSM

 LDA #144               \ Call OSBYTE with A = 144, X = 255 and Y = 0 to move
 LDX #255               \ the screen down one line and turn screen interlace on
 JSR OSB

ELIF _ELITE_A_VERSION

 CLI                    \ Enable interrupts

 LDA #144               \ Call OSBYTE with A = 144, X = 255 and Y = 1 to move
 LDX #255               \ the screen down one line and turn screen interlace off
 LDY #1
 JSR OSBYTE

ENDIF

 LDA #LO(B%)            \ Set the low byte of ZP(1 0) to point to the VDU code
 STA ZP                 \ table at B%

 LDA #HI(B%)            \ Set the high byte of ZP(1 0) to point to the VDU code
 STA ZP+1               \ table at B%

 LDY #0                 \ We are now going to send the N% VDU bytes in the table
                        \ at B% to OSWRCH to set up the special mode 4 screen
                        \ that forms the basis for the split-screen mode

.loop1

 LDA (ZP),Y             \ Pass the Y-th byte of the B% table to OSWRCH
 JSR OSWRCH

 INY                    \ Increment the loop counter

 CPY #N%                \ Loop back for the next byte until we have done them
 BNE loop1              \ all (the number of bytes was set in N% above)

 JSR PLL1               \ Call PLL1 to draw Saturn

IF NOT(_ELITE_A_VERSION)

 LDA #16                \ Call OSBYTE with A = 16 and X = 3 to set the ADC to
 LDX #3                 \ sample 3 channels from the joystick/Bitstik
 JSR OSBYTE

ELIF _ELITE_A_VERSION

 LDA #16                \ Call OSBYTE with A = 16 and X = 2 to set the ADC to
 LDX #2                 \ sample 2 channels from the joystick
 JSR OSBYTE

ENDIF

 LDA #&60               \ Store an RTS instruction in location &0232
 STA &0232

 LDA #&02               \ Point the NETV vector to &0232, which we just filled
 STA NETV+1             \ with an RTS
 LDA #&32
 STA NETV

 LDA #190               \ Call OSBYTE with A = 190, X = 8 and Y = 0 to set the
 LDX #8                 \ ADC conversion type to 8 bits, for the joystick
 JSR OSB

IF NOT(_ELITE_A_VERSION)

 LDA #200               \ Call OSBYTE with A = 200, X = 0 and Y = 0 to enable
 LDX #0                 \ the ESCAPE key and disable memory clearing if the
 JSR OSB                \ BREAK key is pressed

ELIF _ELITE_A_VERSION

 LDA #200               \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDX #3                 \ the ESCAPE key and clear memory if the BREAK key is
 JSR OSB                \ pressed

ENDIF

 LDA #13                \ Call OSBYTE with A = 13, X = 0 and Y = 0 to disable
 LDX #0                 \ the "output buffer empty" event
 JSR OSB

 LDA #225               \ Call OSBYTE with A = 225, X = 128 and Y = 0 to set
 LDX #128               \ the function keys to return ASCII codes for SHIFT-fn
 JSR OSB                \ keys (i.e. add 128)

IF NOT(_ELITE_A_VERSION)

 LDA #12                \ Set A = 12 and  X = 0 to pretend that this is an to
 LDX #0                 \ innocent call to OSBYTE to reset the keyboard delay
                        \ and auto-repeat rate to the default, when in reality
                        \ the OSB address in the next instruction gets modified
                        \ to point to OSBmod

.OSBjsr

 JSR OSB                \ This JSR gets modified by code inserted into PLL1 so
                        \ that it points to OSBmod instead of OSB, so this
                        \ actually calls OSBmod to calculate some checksums

ENDIF

 LDA #13                \ Call OSBYTE with A = 13, X = 2 and Y = 0 to disable
 LDX #2                 \ the "character entering buffer" event
 JSR OSB

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDX #1                 \ cursor editing, so the cursor keys return ASCII values
 JSR OSB                \ and can therefore be used in-game

 LDA #9                 \ Call OSBYTE with A = 9, X = 0 and Y = 0 to disable
 LDX #0                 \ flashing colours
 JSR OSB

IF _ELITE_A_VERSION

 LDA #119               \ Call OSBYTE with A = 119 to close any *SPOOL or *EXEC
 JSR OSBYTE             \ files

ENDIF

 JSR PROT3              \ Call PROT3 to do more checks on the CHKSM checksum

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&11               \   ZP(1 0) = &1100
 STA ZP+1               \   P(1 0) = TVT1code
 LDA #LO(TVT1code)
 STA P
 LDA #HI(TVT1code)
 STA P+1

IF NOT(_ELITE_A_VERSION)

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ TVT1code to &1100-&11FF

ELIF _ELITE_A_VERSION

 JSR MVPG               \ Call MVPG to move a page of memory from TVT1code to
                        \ &1100-&11FF

ENDIF

IF _ELITE_A_VERSION

 LDA #LO(S%+11)         \ Point BRKV to the fifth entry in the main docked
 STA BRKV               \ code's S% workspace, which contains JMP BRBR
 LDA #HI(S%+11)
 STA BRKV+1

ENDIF

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&78               \   ZP(1 0) = &7800
 STA ZP+1               \   P(1 0) = DIALS
 LDA #LO(DIALS)         \   X = 8
 STA P
 LDA #HI(DIALS)
 STA P+1
 LDX #8

IF NOT(_ELITE_A_VERSION)

 JSR MVBL               \ Call MVBL to move and decrypt 8 pages of memory from
                        \ DIALS to &7800-&7FFF

ELIF _ELITE_A_VERSION

 JSR MVBL               \ Call MVBL to move 8 pages of memory from DIALS to
                        \ &7800-&7FFF

ENDIF

IF NOT(_ELITE_A_VERSION)

 SEI                    \ Disable interrupts while we set up our interrupt
                        \ handler to support the split-screen mode

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA &0001              \ counter (SHEILA &44), which decrements one million
                        \ times a second and will therefore be pretty random,
                        \ and store it in location &0001, which is among the
                        \ main game code's random seeds (so this seeds the
                        \ random number generator for the main game)

 LDA #%00111001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 0 and 3-5 (i.e. disable the Timer1,
                        \ CB1, CB2 and CA2 interrupts from the System VIA)

 LDA #%01111111         \ Set 6522 User VIA interrupt enable register IER
 STA VIA+&6E            \ (SHEILA &6E) bits 0-7 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA IRQ1V              \ Copy the current IRQ1V vector address into VEC(1 0)
 STA VEC
 LDA IRQ1V+1
 STA VEC+1

 LDA #LO(IRQ1)          \ Set the IRQ1V vector to IRQ1, so IRQ1 is now the
 STA IRQ1V              \ interrupt handler
 LDA #HI(IRQ1)
 STA IRQ1V+1

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 CLI                    \ Re-enable interrupts

ENDIF

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&61               \   ZP(1 0) = &6100
 STA ZP+1               \   P(1 0) = ASOFT
 LDA #LO(ASOFT)
 STA P
 LDA #HI(ASOFT)
 STA P+1

IF NOT(_ELITE_A_VERSION)

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ASOFT to &6100-&61FF

ELIF _ELITE_A_VERSION

 JSR MVPG               \ Call MVPG to move a page of memory from ASOFT to
                        \ &6100-&61FF

ENDIF

 LDA #&63               \ Set the following:
 STA ZP+1               \
 LDA #LO(ELITE)         \   ZP(1 0) = &6300
 STA P                  \   P(1 0) = ELITE
 LDA #HI(ELITE)
 STA P+1

IF NOT(_ELITE_A_VERSION)

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ELITE to &6300-&63FF

ELIF _ELITE_A_VERSION

 JSR MVPG               \ Call MVPG to move a page of memory from ELITE to
                        \ &6300-&63FF

ENDIF

 LDA #&76               \ Set the following:
 STA ZP+1               \
 LDA #LO(CpASOFT)       \   ZP(1 0) = &7600
 STA P                  \   P(1 0) = CpASOFT
 LDA #HI(CpASOFT)
 STA P+1

IF NOT(_ELITE_A_VERSION)

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ CpASOFT to &7600-&76FF

ELIF _ELITE_A_VERSION

 JSR MVPG               \ Call MVPG to move a page of memory from CpASOFT to
                        \ &7600-&76FF

ENDIF

IF NOT(_ELITE_A_VERSION)

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&04               \   ZP(1 0) = &0400
 STA ZP+1               \   P(1 0) = WORDS
 LDA #LO(WORDS)         \   X = 4
 STA P
 LDA #HI(WORDS)
 STA P+1
 LDX #4

 JSR MVBL               \ Call MVBL to move and decrypt 4 pages of memory from
                        \ WORDS to &0400-&07FF

 LDX #35                \ We now want to copy the disc catalogue routine from
                        \ CATDcode to CATD, so set a counter in X for the 36
                        \ bytes to copy

.loop2

 LDA CATDcode,X         \ Copy the X-th byte of CATDcode to the X-th byte of
 STA CATD,X             \ CATD

 DEX                    \ Decrement the loop counter

 BPL loop2              \ Loop back to copy the next byte until they are all
                        \ done

 LDA &76                \ Set the drive number in the CATD routine to the
 STA CATBLOCK           \ contents of &76, which gets set in ELITE3

ENDIF

 FNE 0                  \ Set up sound envelopes 0-3 using the FNE macro
 FNE 1
 FNE 2
 FNE 3

 LDX #LO(MESS1)         \ Set (Y X) to point to MESS1 ("DIR E")
 LDY #HI(MESS1)

 JSR OSCLI              \ Call OSCLI to run the OS command in MESS1, which
                        \ changes the disc directory to E

IF NOT(_ELITE_A_VERSION)

 LDA #LO(LOAD)          \ Set the following:
 STA ZP                 \
 LDA #HI(LOAD)          \   ZP(1 0) = LOAD
 STA ZP+1               \   P(1 0) = LOADcode
 LDA #LO(LOADcode)
 STA P
 LDA #HI(LOADcode)
 STA P+1

 LDY #0                 \ We now want to move and decrypt one page of memory
                        \ from LOADcode to LOAD, so set Y as a byte counter

.loop3

 LDA (P),Y              \ Fetch the Y-th byte of the P(1 0) memory block

 EOR #&18               \ Decrypt it by EOR'ing with &18

 STA (ZP),Y             \ Store the decrypted result in the Y-th byte of the
                        \ ZP(1 0) memory block

 DEY                    \ Decrement the byte counter

 BNE loop3              \ Loop back to copy the next byte until we have done a
                        \ whole page of 256 bytes

 JMP LOAD               \ Jump to the start of the routine we just decrypted

ELIF _ELITE_A_VERSION

 LDA #%11110000         \ Set the Data Direction Register (DDR) of port B of the
 STA VIA+&62            \ user port so we can read the buttons on the Delta 14b
                        \ joystick, using PB4 to PB7 as output (so we can write
                        \ to the button columns to select the column we are
                        \ interested in) and PB0 to PB3 as input (so we can read
                        \ from the button rows)

 LDA #0                 \ Set HFX = 0
 STA HFX

 STA LASCT              \ Set LASCT = 0

 LDA #&FF               \ Set ESCP = &FF so we show the palette for when we have
 STA ESCP               \ an escape pod fitted (i.e. black, red, white, cyan)

 SEI                    \ Disable interrupts while we set up our interrupt
                        \ handler to support the split-screen mode

 LDA VIA+&44            \ If the STA instruction were not commented out, then
\STA &0001              \ this would set location &0001 among the random number
                        \ seeds to a pretty random number (i.e. the value of the
                        \ the 6522 System VIA T1C-L timer 1 low-order counter),
                        \ but as the STA is commented out, this has no effect

 LDA #%00111001         \ Set 6522 System VIA interrupt enable register IER
 STA VIA+&4E            \ (SHEILA &4E) bits 0 and 3-5 (i.e. disable the Timer1,
                        \ CB1, CB2 and CA2 interrupts from the System VIA)

 LDA #%01111111         \ Set 6522 User VIA interrupt enable register IER
 STA VIA+&6E            \ (SHEILA &6E) bits 0-7 (i.e. disable all hardware
                        \ interrupts from the User VIA)

 LDA IRQ1V              \ Copy the current IRQ1V vector address into VEC(1 0)
 STA VEC
 LDA IRQ1V+1
 STA VEC+1

 LDA #LO(IRQ1)          \ Set the IRQ1V vector to IRQ1, so IRQ1 is now the
 STA IRQ1V              \ interrupt handler
 LDA #HI(IRQ1)
 STA IRQ1V+1

 LDA #VSCAN             \ Set 6522 System VIA T1C-L timer 1 high-order counter
 STA VIA+&45            \ (SHEILA &45) to VSCAN (57) to start the T1 counter
                        \ counting down from 14622 at a rate of 1 MHz

 CLI                    \ Re-enable interrupts

 LDA #0                 \ Call OSBYTE with A = 0 and X = 1 to fetch bit 0 of the
 LDX #1                 \ operating system version into X
 JSR OSBYTE

 CPX #3                 \ If X =< 3 then this is not a BBC Master, so jump to
 BCC not_master         \ not_master to continue loading the BBC Micro version

                        \ This is a BBC Master, so now we copy the block of
                        \ Master-specific filing system code from to_dd00 to
                        \ &DD00 (so we copy the following routines: do_FILEV,
                        \ do_FSCV, do_BYTEV, set_vectors and old_BYTEV)

 LDX #0                 \ Set up a counter in X for the copy

.cpmaster

 LDA to_dd00,X          \ Copy the X-th byte of to_dd00 to &DD00
 STA &DD00,X

 INX                    \ Increment the loop counter

 CPX #dd00_len          \ Loop back until we have copied all the bytes in the
 BNE cpmaster           \ to_dd00 block (as the length of the block is set in
                        \ dd00_len below)

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&21               \ type &21 with argument &C0, which is the "Indicate
 LDY #&C0               \ static workspace in 'hidden' RAM" service call. This
 JSR OSBYTE             \ call returns the address of a safe place that we can
                        \ use within the memory bank &C000-&DFFF, and returns
                        \ the start location in (Y X)

                        \ We now modify the savews routine so that when it's
                        \ called, it copies the first three pages from the &C000
                        \ workspace to this safe place, and then copies the MOS
                        \ character set into the first three pages of &C000, so
                        \ the character printing routines can use them

                        \ We also modify the restorews routine in a similar way,
                        \ so that when it's called, it copies the three pages
                        \ from the safe place back into the first three pages
                        \ of &C000, thus restoring the filing system workspace

 STX put0+1             \ Modify the low byte of the workspace save address in
 STX put1+1             \ the savews routine to that of (Y X)
 STX put2+1

 STX get0+1             \ Modify the low byte of the workspace restore address
 STX get1+1             \ in the restorews routine to that of (Y X)
 STX get2+1

 STY put0+2             \ Modify the high byte of the workspace save address of
                        \ the first page in the savews routine to that of (Y X)

 STY get0+2             \ Modify the high byte of the workspace restore address
                        \ of the first page in the restorews routine to that of
                        \ (Y X)

 INY                    \ Increment Y so that (Y X) points to the second page,
                        \ i.e. (Y+1 X)

 STY put1+2             \ Modify the high byte of the workspace save address of
                        \ the second page in the savews routine to (Y+1 X)

 STY get1+2             \ Modify the high byte of the workspace restore address
                        \ of the second page in the restorews routine to that of
                        \ (Y+1 X)

 INY                    \ Increment Y so that (Y X) points to the third page,
                        \ i.e. (Y+2 X)

 STY put2+2             \ Modify the high byte of the workspace save address of
                        \ the third page in the savews routine to (Y+2 X)

 STY get2+2             \ Modify the high byte of the workspace restore address
                        \ of the third page in the restorews routine to that of
                        \ (Y+2 X)

 LDA FILEV              \ Set old_FILEV(1 0) to the existing address for FILEV
 STA old_FILEV+1        \ (this modifies the JMP instruction in the do_FILEV
 LDA FILEV+1            \ routine)
 STA old_FILEV+2

 LDA FSCV               \ Set old_FSCV(1 0) to the existing address for FSCV
 STA old_FSCV+1         \ (this modifies the JMP instruction in the do_FILEV
 LDA FSCV+1             \ routine)
 STA old_FSCV+2

 LDA BYTEV              \ Set old_BYTEV(1 0) to the existing address for BYTEV
 STA old_BYTEV+1        \ (this modifies the JMP instruction in the old_BYTEV
 LDA BYTEV+1            \ routine)
 STA old_BYTEV+2

 JSR set_vectors        \ Call set_vectors to update FILEV, FSCV and BYTEV to
                        \ point to the new handlers in do_FILEV, do_FSCV and
                        \ do_BYTEV

.not_master

 LDA #234               \ Call OSBYTE with A = 234, X = 0 and Y = &FF, which
 LDY #&FF               \ detects whether Tube hardware is present, returning
 LDX #0                 \ X = 0 (not present) or X = &FF (present)
 JSR OSBYTE

 TXA                    \ Copy the result of the Tube check from X into A

 BNE tube_go            \ If X is non-zero then we are running this over the
                        \ Tube, so jump to tube_go to set up the Tube version

                        \ If we get here then we are not running on a 6502
                        \ Second Processor

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #&FF
 JSR OSBYTE

 STX TRTB%              \ Store the address of the keyboard translation table in
 STY TRTB%+1            \ TRTB%(1 0)

 LDA #&00               \ Set the following:
 STA ZP                 \
 LDA #&04               \   ZP(1 0) = &0400
 STA ZP+1               \   P(1 0) = WORDS
 LDA #LO(WORDS)         \   X = 4
 STA P
 LDA #HI(WORDS)
 STA P+1
 LDX #4

 JSR MVBL               \ Call MVBL to move 4 pages of memory from WORDS to
                        \ &0400-&07FF

 LDA #LO(S%+6)          \ Point WRCHV to the third entry in the main docked
 STA WRCHV              \ code's S% workspace, which contains JMP CHPR
 LDA #HI(S%+6)
 STA WRCHV+1

 LDA #LO(LOAD)          \ Set the following:
 STA ZP                 \
 LDA #HI(LOAD)          \   ZP(1 0) = LOAD
 STA ZP+1               \   P(1 0) = LOADcode
 LDA #LO(LOADcode)
 STA P
 LDA #HI(LOADcode)
 STA P+1

 JSR MVPG               \ Call MVPG to move a page of memory from LOADcode to
                        \ LOAD

 LDY #35                \ We now want to copy the iff_index routine from
                        \ iff_index_code to iff_index, so set a counter in Y
                        \ for the 36 bytes to copy

.copy_d7a

 LDA iff_index_code,Y   \ Copy the X-th byte of iff_index_code to the X-th byte
 STA iff_index,Y        \ of iff_index

 DEY                    \ Decrement the loop counter

 BPL copy_d7a           \ Loop back to copy the next byte until they are all
                        \ done

 JMP LOAD               \ Jump to the start of the LOAD routine we moved above,
                        \ to run the game

.tube_go

 LDA #172               \ Call OSBYTE 172 to read the address of the MOS
 LDX #0                 \ keyboard translation table into (Y X)
 LDY #&FF
 JSR OSBYTE

 STX key_tube           \ Store the address of the keyboard translation table in
 STY key_tube+1         \ key_tube(1 0)

\LDX #LO(tube_400)      \ These instructions are commented out in the original
\LDY #HI(tube_400)      \ source
\LDA #1
\JSR &0406
\LDA #LO(WORDS)
\STA &72
\LDA #HI(WORDS)
\STA &73
\LDX #&04
\LDY #&00
\.tube_wr
\LDA (&72),Y
\JSR tube_wait
\BIT tube_r3s
\BVC tube_wr
\STA tube_r3d
\INY
\BNE tube_wr
\INC &73
\DEX
\BNE tube_wr
\LDA #LO(tube_wrch)
\STA WRCHV
\LDA #HI(tube_wrch)
\STA WRCHV+&01

 LDX #LO(tube_run)      \ Set (Y X) to point to tube_run ("R.2.H")
 LDY #HI(tube_run)

 JMP OSCLI              \ Call OSCLI to run the OS command in tube_run, which
                        \ runs the I/O processor code in 2.H

.tube_run

 EQUS "R.2.H"           \ The OS command for running the Tube version's I/O
 EQUB 13                \ processor code in file 2.H (this command is short for
                        \ "*RUN 2.H")

\.tube_400              \ These instructions are commented out in the original
\EQUD &0400             \ source
\.tube_wait
\JSR tube_wait2
\.tube_wait2
\JSR tube_wait3
\.tube_wait3
\RTS

ENDIF
