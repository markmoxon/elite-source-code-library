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
\ The following routines from the S.BCODES and S.COMLODS BBC BASIC source file
\ are implemented in the elite-checksum.py script. This file is purely for
\ reference and is not used in the build process.
\
\ ******************************************************************************

\ ******************************************************************************
\
\       Name: S.BCODES encryption
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Encrypts LOCODE and HICODE
\
\ ******************************************************************************

 KEY1 = &36             \ The seed for encrypting LOCODE from G% to R%-1, where
                        \ LOCODE = ELTA-C

 KEY2 = &49             \ The seed for encrypting HICODE from R% to F%-1, where
                        \ HICODE = ELTD-K

                        \ These four variables come from the build process:
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
                        \
                        \ These three variables are calculated by S.BCODES when
                        \ loading the binary files into memory in order to
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
                        \
                        \ We can therefore convert an in-game address to a local
                        \ S.BCODES address by adding L%-B%
                        \
                        \ This code encrypts as follows:
                        \
                        \   G% to R% with KEY1 (i.e. L%+G%-B% to U% in local
                        \                            memory)
                        \
                        \   R% to F% with KEY2 (i.e. U% to V% in local memory)

 LDA U%                 \ Store the contents of the byte at U% on the stack,
 PHA                    \ so we can restore it below

 LDA #KEY1              \ Set the byte at U% to KEY1, so we can work up from
 STA U%                 \ L% to U% to encrypt LOCODE, ending with the correct
                        \ seed (which we can then use to "unzip" the encrypted
                        \ data in the opposite direction, from U% to L%)

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

\ ******************************************************************************
\
\       Name: S.COMLODS encryption
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Encrypts COMLOD
\
\ ******************************************************************************

 KEY3 = &8E             \ The seed for encrypting COMLOD from U% to V%, which is
                        \ the second block of data, after the decryption routine

 KEY4 = &6C             \ The seed for encrypting COMLOD from W% to X%, which is
                        \ the first block of data, before the decryption routine

                        \ These four variables come from the build process:
                        \
                        \ U% is the address in the COMLOD code of the start of
                        \ the second data block, just after the decryption
                        \ routine
                        \
                        \ V% is the address of the end of the COMLOD code
                        \
                        \ W% is the of the start of the COMLOD code
                        \
                        \ X% is the address in the COMLOD code of the end of the
                        \ first data block, just after the decryption routine
                        \
                        \ These two variables are calculated by S.COMLODS when
                        \ loading the binary files into memory in order to
                        \ encrypt them
                        \
                        \ O2% is the address of the COMLOD file when loaded into
                        \ local memory by S.COMLODS
                        \
                        \ P2% is the address of the COMLOD file when loaded by
                        \ the game
                        \
                        \ We can therefore convert an in-game address to a local
                        \ S.BCODES address by adding O2%-P2%
                        \
                        \ This code encrypts as follows:
                        \
                        \   U% to V% with KEY3 (i.e. U%+O2%-P2% to V%+O2%-P2%
                        \                            in local memory)
                        \
                        \   W% to X% with KEY4 (i.e. W%+O2%-P2% to X%+O2%-P2%
                        \                            in local memory)

.ZP

 LDA #KEY3              \ Set A = KEY3 to use below, and label this instruction
                        \ and the next one to use as temporary storage, which
                        \ has the side effect of overwriting the key number as
                        \ we do the encryption, thus erasing a very big clue

.ZP2

 STA V%+O2%-P2%         \ Set the byte at V% to KEY3, so we can work up from
                        \ U% to V% to encrypt the second block of data after the
                        \ decryption routine, ending with the correct seed
                        \ (which we can then use to "unzip" the encrypted data
                        \ in the opposite direction, from V% to U%)

 LDA #0                 \ Set ZP = 0, so (ZP+1 Y) will equal ZP(1 0) + Y
 STA ZP

 LDY #LO(U%+O2%-P2%)    \ Set (ZP+1 Y) to the address in local memory of the
 LDA #HI(U%+O2%-P2%)    \ start of the code that we want to encrypt (i.e. U% in
 STA ZP+1               \ the loader, or the first byte after the decryption
                        \ routine)

 LDA #LO(V%+O2%-P2%)    \ Set ZP2(1 0) to the address in local memory of the
 STA ZP2                \ end of the code that we want to encrypt (i.e. V% at
 LDA #HI(V%+O2%-P2%)    \ the end of the loader)
 STA ZP2+1

 JSR WUMP               \ Encrypt from (ZP+1 Y) up to ZP2(1 0), i.e. from U% up
                        \ to V% in the loader

 LDA X%+O2%-P2%         \ Store the contents of the byte at X% on the stack,
 PHA                    \ so we can restore it below

 LDA #KEY4              \ Set the byte at X% to KEY4, so we can work up from
 STA X%+O2%-P2%         \ W% to X% to encrypt the first block of data before the
                        \ decryption routine, ending with the correct seed
                        \ (which we can then use to "unzip" the encrypted data
                        \ in the opposite direction, from X% to W%)
 

 LDA #0                 \ Set ZP = 0, so (ZP+1 Y) will equal ZP(1 0) + Y
 STA ZP

 LDY #LO(W%+O2%-P2%)    \ Set (ZP+1 Y) to the address in local memory of the
 LDA #HI(W%+O2%-P2%)    \ start of the code that we want to encrypt (i.e. W% in
 STA ZP+1               \ the loader, or the first byte of the loader)

 LDA #LO(X%+O2%-P2%)    \ Set ZP2(1 0) to the address in local memory of the
 STA ZP2                \ end of the code that we want to encrypt (i.e. X% just
 LDA #HI(X%+O2%-P2%)    \ before the decryption routine)
 STA ZP2+1

 JSR WUMP               \ Encrypt from (ZP+1 Y) up to ZP2(1 0), i.e. from W% up
                        \ to X% in the loader

 PLA                    \ Restore the byte at X%, which we corrupted above
 STA X%+O2%-P2%

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
