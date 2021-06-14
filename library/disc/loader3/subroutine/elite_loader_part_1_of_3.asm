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

 CLI                    \ AJD
 LDA #&90
 LDX #&FF
 LDY #&01
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

 LDA #&77               \ AJD
 JSR OSBYTE

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

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ TVT1code to &1100-&11FF

IF _ELITE_A_VERSION

 LDA #&EE               \ AJD
 STA BRKV
 LDA #&11
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

 JSR MVBL               \ Call MVBL to move and decrypt 8 pages of memory from
                        \ DIALS to &7800-&7FFF

IF NOT(_ELITE_A_VERSION)

 SEI                    \ Disable interrupts while we set up our interrupt
                        \ handler to support the split-screen mode

 LDA VIA+&44            \ Read the 6522 System VIA T1C-L timer 1 low-order
 STA &0001              \ counter (SHEILA &44), which increments 1000 times a
                        \ second so this will be pretty random, and store it in
                        \ &0001 among the random number seeds at &0000

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

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ASOFT to &6100-&61FF

 LDA #&63               \ Set the following:
 STA ZP+1               \
 LDA #LO(ELITE)         \   ZP(1 0) = &6300
 STA P                  \   P(1 0) = ELITE
 LDA #HI(ELITE)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ ELITE to &6300-&63FF

 LDA #&76               \ Set the following:
 STA ZP+1               \
 LDA #LO(CpASOFT)       \   ZP(1 0) = &7600
 STA P                  \   P(1 0) = CpASOFT
 LDA #HI(CpASOFT)
 STA P+1

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ CpASOFT to &7600-&76FF

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

 LDA #&F0               \ set up DDRB AJD
 STA &FE62
 LDA #0 \ Set up palatte flags
 STA &348
 STA &346
 LDA #&FF
 STA &386
 SEI 
 LDA &FE44
 \ STA &01
 LDA #&39
 STA &FE4E
 LDA #&7F
 STA &FE6E
 LDA IRQ1V
 STA &7FFE
 LDA IRQ1V+&01
 STA &7FFF
 LDA #&4B
 STA IRQ1V
 LDA #&11
 STA IRQ1V+&01
 LDA #&39
 STA &FE45
 CLI 
 LDA #0 \ test for BBC Master
 LDX #1
 JSR OSBYTE \ get OS version
 CPX #3
 BCC not_master
 LDX #0 \ copy master code to DD00

.cpmaster

 LDA to_dd00,X
 STA &DD00,X
 INX
 CPX #dd00_len
 BNE cpmaster
 LDA #&8F \ service call
 LDX #&21 \ ?
 LDY #&C0 \ ? top of absolute workspace
 JSR OSBYTE \ ? in XY
 STX put0+1 \ modify workspace save address
 STX put1+1
 STX put2+1
 STX get0+1 \ modify workspace restore address
 STX get1+1
 STX get2+1
 STY put0+2
 STY get0+2
 INY
 STY put1+2
 STY get1+2
 INY
 STY put2+2
 STY get2+2
 LDA FILEV \ modify address for old FILEV
 STA old_FILEV+1
 LDA FILEV+1
 STA old_FILEV+2
 LDA FSCV \ modify address for old FSCV
 STA old_FSCV+1
 LDA FSCV+1
 STA old_FSCV+2
 LDA BYTEV \ modify address for old BYTEV
 STA old_BYTEV+1
 LDA BYTEV+1
 STA old_BYTEV+2
 JSR set_vectors \ replace FILEV and FSCV

.not_master

 LDA #&EA \ test for tube
 LDY #&FF
 LDX #&00
 JSR OSBYTE
 TXA
 BNE tube_go
 LDA #&AC \ keyboard translation table
 LDX #&00
 LDY #&FF
 JSR OSBYTE
 STX key_io
 STY key_io+&01

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

 LDA #LO(S%+6)          \ Point BRKV to the third entry in the main docked
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

 JSR MVPG               \ Call MVPG to move and decrypt a page of memory from
                        \ LOADcode to LOAD

 LDY #35

.copy_d7a

 LDA iff_index_code,Y
 STA iff_index,Y
 DEY
 BPL copy_d7a
 JMP &0B00

.tube_go

 LDA #&AC \ keyboard translation table
 LDX #&00
 LDY #&FF
 JSR OSBYTE
 STX key_tube
 STY key_tube+&01
 \ LDX #LO(tube_400)
 \ LDY #HI(tube_400)
 \ LDA #1
 \ JSR &0406
 \ LDA #LO(WORDS)
 \ STA &72
 \ LDA #HI(WORDS)
 \ STA &73
 \ LDX #&04
 \ LDY #&00
 \tube_wr LDA (&72),Y
 \ JSR tube_wait
 \ BIT tube_r3s
 \ BVC tube_wr
 \ STA tube_r3d
 \ INY
 \ BNE tube_wr
 \ INC &73
 \ DEX
 \ BNE tube_wr
 \ LDA #LO(tube_wrch)
 \ STA WRCHV
 \ LDA #HI(tube_wrch)
 \ STA WRCHV+&01
 LDX #LO(tube_run)
 LDY #HI(tube_run)
 JMP OSCLI

.tube_run

 EQUS "R.2.H", &0D

 \tube_400 EQUD &0400

 \tube_wait
 \ JSR tube_wait2
 \tube_wait2
 \ JSR tube_wait3
 \tube_wait3
 \ RTS

ENDIF
