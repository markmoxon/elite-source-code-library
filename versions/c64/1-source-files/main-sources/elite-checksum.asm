\ ******************************************************************************
\
\ COMMODORE 64 ELITE ENCRYPTION SOURCE
\
\ Commodore 64 Elite was written by Ian Bell and David Braben and is copyright
\ D. Braben and I. Bell 1985
\
\ The code on this site is identical to the source discs released on Ian Bell's
\ personal website at http://www.elitehomepage.org/ (it's just been reformatted
\ to be more readable)
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://elite.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://elite.bbcelite.com/deep_dives
\
\ ******************************************************************************
\
\ The following routines from the S.BCODES BBC BASIC source file are implemented
\ in the elite-checksum.py script. This file is purely for reference and is
\ not used in the build process.
\
\ ******************************************************************************

 KEY1 = &36             \ The seed for encrypting LOCODE from L% to U%-1, where
                        \ LOCODE = ELTA-C

 KEY2 = &49             \ The seed for encrypting HICODE from U% to B%-1, where
                        \ HICODE = ELTD-K

 ORG &0070

 LDA U%                 \ Store the contents of the byte at U% on the stack,
 PHA                    \ so we can restore it below

 LDA #KEY1              \ Set the byte at U% to KEY1, so we can work up from
 STA U%                 \ L% to U% to encrypt LOCODE, ending with the correct
                        \ seed (which we can then use to "unzip" the encrypted
                        \ data in the opposite direction, from U% to L%)

                        \ These three variables come from the build process:
                        \
                        \ G% is the address in the main game code of the ELTA
                        \ file, just after the end of the decryption routine
                        \
                        \ B% is the address in the main game code of the start
                        \ of the LOCODE file
                        \
                        \ R% is the address in the main game code of the first
                        \ byte of ELTD
                        \
                        \ F% is the address in the main game code of the last
                        \ byte of ELTK (i.e. after the C.COMUDAT music data but
                        \ before the C.THEME music data)

                        \ These two variables are calculated by S.BCODES when
                        \ loading the binary files into memory in otder to
                        \ encrypt them
                        \
                        \ L% is the address in local memory in S.BCODES where we
                        \ load the ELTA-K files
                        \
                        \ U% is the address in local memory in S.BCODES of the
                        \ first byte of ELTD
                        \
                        \ V% is the address in local memory in S.BCODES of the
                        \ last byte of ELTK

 LDA #0                 \ Set ZP = 0, so (ZP+1 Y) will equal ZP(1 0) + Y
 STA ZP

 LDY #LO(L%+G%-B%)      \ Set (ZP+1 Y) to the address in local memory of the
 LDA #HI(L%+G%-B%)      \ start of the code that we want to encrypt (i.e. G% in
 STA ZP+1               \ the main game code, or the first byte of ELTA)

 LDA #LO(U%)            \ Set ZP2(1 0) to U%, the address in local memory of the
 STA ZP2                \ end of the code that we want to encrypt (i.e. R% in
 LDA #HI(U%)            \ the main game code, or the first byte of ELTD)
 STA ZP2+1

 JSR WUMP               \ Encrypt from (ZP+1 Y) up to ZP2(1 0), i.e. from G% up
                        \ to R% in the main game code

 PLA                    \ Restore the byte at U%, which we corrupted above
 STA U%

 LDA #KEY2              \ Set the byte at V% to KEY2, so we can work up from
 STA V%                 \ U% to V% to encrypt HICODE, ending with the correct
                        \ seed (which we can then use to "unzip" the encrypted
                        \ data in the opposite direction, from V% to U%)

 LDY #LO(U%)            \ Set (ZP+1 Y) to U%, the address in local memory of the
 LDA #HI(U%)            \ start of the code that we want to encrypt (i.e. R% in
 STA ZP+1               \ the main game code, or the first byte of ELTD)

 LDA #LO(V%)            \ Set ZP2(1 0) to V%, the address in local memory of the
 STA ZP2                \ end of the code that we want to encrypt (i.e. F% in
 LDA #HI(V%)            \ the main game code, or the byte after C.COMUDAT)
 STA ZP2+1

 JSR WUMP               \ Encrypt from (ZP+1 Y) up to ZP2(1 0), i.e. from R% up
                        \ to F% in the main game code

 LDA #0                 \ Zero the byte at V% to hide the seed
 STA V%

 RTS                    \ Return from the subroutine

.WUMP

                        \ This routine encrypts from (ZP+1 Y) up to ZP2(1 0)
                        \
                        \ This is the same as ZP2(1 0) down to ZP(1 0) + Y 

 LDA (ZP),Y             \ If Y = 255, jump to WUMP2 to add the bytes across the
 CLC                    \ page boundary and jump back to WUMP3
 INY                    \
 BEQ WUMP2              \ Otherwise add byte Y+1 of ZP(1 0) to byte Y of ZP(1 0)
 ADC (ZP),Y
 DEY
 STA (ZP),Y

.WUMP3

 INY                    \ Increment Y to point to the next byte to encrypt

 CPY ZP2                \ If we haven't reached ZP2(1 0), loop back to WUMP to
 BNE WUMP               \ encrypt the next byte
 LDA ZP+1
 CMP ZP2+1
 BNE WUMP

 RTS                    \ Otherwise we have reached ZP2(1 0), so return from the
                        \ subroutine

.WUMP2

                        \ If we get here then Y has just been incremented from
                        \ 255 to 0

 INC ZP+1               \ Increment ZP(1 0) to point to the next page

 ADC (ZP),Y             \ Add byte 0 of the new page to byte 255 of the old page
 DEC ZP+1               \ (C is still clear from above)
 DEY
 STA (ZP),Y
 INC ZP+1

 BNE WUMP3              \ Jump to WUMP3 to continue encrypting the new page
