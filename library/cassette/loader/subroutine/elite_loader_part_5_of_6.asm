\ ******************************************************************************
\
\       Name: Elite loader (Part 5 of 6)
\       Type: Subroutine
\   Category: Loader
\    Summary: Load main game code, decrypt it, move it to the correct location
\
\ ------------------------------------------------------------------------------
\
\ This part loads the main game code, decrypts it and moves it to the correct
\ location for it to run.
\
\ The code in this part is encrypted by elite-checksum.py and is decrypted in
\ part 4 by the same routine that moves part 6 onto the stack.
\
\ ******************************************************************************

.ENTRY2

                        \ We start this part of the loader by setting the
                        \ following:
                        \
                        \   OSPRNT(1 0) = WRCHV
                        \   WRCHV(1 0) = TT26
                        \   (Y X) = MESS1(1 0)
                        \
                        \ so any character printing will use the TT26 routine

 LDA &20E               \ Copy the low byte of WRCHV to the low byte of OSPRNT
 STA OSPRNT

 LDA #LO(TT26)          \ Set the low byte of WRCHV to the low byte of TT26
 STA &20E

 LDX #LO(MESS1)         \ Set X to the low byte of MESS1

 LDA &20F               \ Copy the high byte of WRCHV to the high byte of OSPRNT
 STA OSPRNT+1

 LDA #HI(TT26)          \ Set the high byte of WRCHV to the high byte of TT26
 LDY #HI(MESS1)         \ and set Y to the high byte of MESS1
 STA &20F

 JSR AFOOL              \ This calls AFOOL, which jumps to the address in FOOLV,
                        \ which contains the address of FOOL, which contains an
                        \ RTS instruction... so overall this does nothing, but
                        \ in a rather roundabout fashion

 JSR command            \ Call command to execute the OSCLI command pointed to
                        \ by (Y X) in MESS1, which starts loading the main game
                        \ code

 JSR 512-LEN+CHECKER-ENDBLOCK \ Call the CHECKER routine in its new location on
                              \ the stack, to run a number of checksums on the
                              \ code (this routine, along with the whole of part
                              \ 6, was pushed onto the stack in part 4)

 JSR AFOOL              \ Another call to the round-the-houses routine to try
                        \ and distract the crackers, presumably

IF DISC

 LDA #140               \ Call OSBYTE with A = 140 and X = 12 to select the
 LDX #12                \ tape filing system (i.e. do a *TAPE command)
 JSR OSBYTE

ENDIF

 LDA #0                 \ Set SVN to 0, as the main game code checks the value
 STA SVN                \ of this location in its IRQ1 routine, so it needs to
                        \ be set to 0 so it can work properly once it takes over
                        \ when the game itself runs

                        \ We now decrypt and move the main game code from &1128
                        \ to &0F40

 LDX #HI(LC%)           \ Set X = high byte of LC%, the maximum size of the main
                        \ game code, so if we move this number of pages, we will
                        \ have definitely moved all the game code down

 LDA #LO(L%)            \ Set ZP(1 0) = L% (the start of the game code)
 STA ZP
 LDA #HI(L%)
 STA ZP+1

 LDA #LO(C%)            \ Set P(1 0) = C% = &0F40
 STA P
 LDA #HI(C%)
 STA P+1

 LDY #0                 \ Set Y as a counter for working our way through every
                        \ byte of the game code. We EOR the counter with the
                        \ current byte to decrypt it

.ML1

 TYA                    \ Copy the counter into A

IF _REMOVE_CHECKSUMS

 LDA (ZP),Y             \ If we have disabled checksums, just fetch the byte to
                        \ copy from the Y-th block pointed to by ZP(1 0)

ELSE

 EOR (ZP),Y             \ Fetch the byte and EOR it with the counter

ENDIF

 STA (P),Y              \ Store the copied (and decrypted) byte in the Y-th byte
                        \ of the block pointed to by P(1 0)

 INY                    \ Increment the loop counter

 BNE ML1                \ Loop back for the next byte until we have finished the
                        \ first 256 bytes

 INC ZP+1               \ Increment the high bytes of both ZP(1 0) and P(1 0) to
 INC P+1                \ point to the next 256 bytes

 DEX                    \ Decrement the number of pages we need to copy in X

 BPL ML1                \ Loop back to copy and decrypt the next page of bytes
                        \ until we have done them all

                        \ S% points to the entry point for the main game code,
                        \ so the following copies the addresses from the start
                        \ of the main code (see the S% label in the main game
                        \ code for the vector values)

 LDA S%+6               \ Set BRKV to point to the BR1 routine in the main game
 STA &202               \ code
 LDA S%+7
 STA &203

 LDA S%+2               \ Set WRCHV to point to the TT26 routine in the main
 STA &20E               \ game code
 LDA S%+3
 STA &20F

 RTS                    \ This RTS actually does a jump to the first instruction
                        \ in BLOCK, after the two EQUW operatives, which is now
                        \ on the stack. This takes us to the next and final
                        \ step of the loader in part 6. See the documentation
                        \ for the stack routine at BEGIN% for more details

.AFOOL

 JMP (FOOLV)            \ This jumps to the address in FOOLV as part of the
                        \ JSR AFOOL instruction above, which does nothing except
                        \ take us on wild goose chase

