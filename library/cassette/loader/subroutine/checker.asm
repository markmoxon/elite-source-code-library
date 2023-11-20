\ ******************************************************************************
\
\       Name: CHECKER
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Run checksum checks on tokens, loader and tape block count
\
\ ------------------------------------------------------------------------------
\
\ This routine runs checksum checks on the recursive token table and the loader
\ code at the start of the main game code file, to prevent tampering with these
\ areas of memory. It also runs a check on the tape loading block count.
\
\ Other entry points:
\
\   ENDBLOCK            Denotes the end of the encrypted code that starts at
\                       BLOCK
\
\ ******************************************************************************

.CHECKER

                        \ First we check the MAINSUM+1 checksum for the
                        \ recursive token table from &0400 to &07FF

 LDY #0                 \ Set Y = 0 to count through each byte within each page

 LDX #4                 \ We are going to checksum 4 pages from &0400 to &07FF
                        \ so set a page counter in X

 STX ZP+1               \ Set ZP(1 0) = &0400, to point to the start of the code
 STY ZP                 \ we want to checksum

 TYA                    \ Set A = 0 for building the checksum

.CHKq

 CLC                    \ Add the Y-th byte of this page of the token table to A
 ADC (ZP),Y

 INY                    \ Increment the counter for this page

 BNE CHKq               \ Loop back for the next byte until we have finished
                        \ adding up this page

 INC ZP+1               \ Increment the high byte of ZP(1 0) to point to the
                        \ next page

 DEX                    \ Decrement the page counter we set in X

 BNE CHKq               \ Loop back to add up the next page until we have done
                        \ them all

 CMP MAINSUM+1          \ Compare the result to the contents of MAINSUM+1, which
                        \ contains the checksum for the table (this gets set by
                        \ elite-checksum.py)

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, do nothing
 NOP

ELSE

 BNE nononono           \ If the checksum we just calculated does not match the
                        \ contents of MAINSUM+1, jump to nononono to reset the
                        \ machine

ENDIF

                        \ Next, we check the LBL routine in the header that's
                        \ appended to the main game code in elite-bcfs.asm, and
                        \ which is currently loaded at LOAD% (which contains the
                        \ load address of the main game code file)

 TYA                    \ Set A = 0 for building the checksum (as Y is still 0
                        \ from the above checksum loop)

.CHKb

 CLC                    \ Add the Y-th byte of LOAD% to A
 ADC LOAD%,Y

 INY                    \ Increment the counter

 CPY #40                \ There are 40 bytes in the loader, so loop back until
 BNE CHKb               \ we have added them all

 CMP MAINSUM            \ Compare the result to the contents of MAINSUM, which
                        \ contains the checksum for loader code

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, do nothing
 NOP

ELSE

 BNE nononono           \ If the checksum we just calculated does not match the
                        \ contents of MAINSUM, jump to nononono to reset the
                        \ machine

ENDIF

                        \ Finally, we check the block count from the tape
                        \ loading code in the IRQ1 routine, which counts the
                        \ number of blocks in the main game code

IF PROT AND DISC = 0

 LDA BLCNT              \ If the tape protection is enabled and we are loading
 CMP #&4F               \ from tape (as opposed to disc), check that the block
 BCC nononono           \ count in BLCNT is &4F, and if it isn't, jump to
                        \ nononono to reset the machine

ENDIF

IF _REMOVE_CHECKSUMS

 RTS                    \ If we have disabled checksums, return from the
 NOP                    \ subroutine
 NOP

ELSE

 JMP (CHECKV)           \ Call the LBL routine in the header (whose address is
                        \ in CHECKV). This routine is inserted before the main
                        \ game code by elite-bcfs.asm, and it checks the
                        \ validity of the first two pages of the UU% routine,
                        \ which was copied to LE% above, and which contains a
                        \ checksum byte in CHECKbyt. We then return from the
                        \ subroutine using a tail call

ENDIF

.ENDBLOCK

