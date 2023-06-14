\ ******************************************************************************
\
\       Name: BEGIN
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Decrypt the loader code using a rolling EOR that uses the
\             decryption routine itself to seed the decryption
\
\ ******************************************************************************

.BEGIN

                        \ Note that the following copy protection code is
                        \ skipped in the unprotected version built here, as the
                        \ binaries are not encrypted and therefore do not need
                        \ to be decrypted
                        \
                        \ Instead, the execution address for the ELITE2 binary
                        \ points to ENTRY rather than BEGIN

 LDX p1c+1              \ Set X to the comparison value from the CMP instruction
                        \ below, which has the value p1d - BEGIN, which we use
                        \ as the offset of the first byte to decrypt (so we
                        \ decrypt from p1d onwards)

.p1

 LDA BEGIN              \ Fetch the first byte from BEGIN to act as the initial
                        \ seed for the rolling EOR process (this address gets
                        \ modified by the following to work through the whole
                        \ decryption routine)

.p1a

 EOR BEGIN,X            \ Set A = A EOR the X-th byte of the loader

 STA BEGIN,X            \ Store the decrypted byte in the X-th byte the loader

 INX                    \ Increment the pointer

 BNE p1a                \ Loop back until we have decrypted to the end of the
                        \ page

.p1b

 INC p1+1               \ Increment the low byte of the argument to the LDA
                        \ instruction at p1 above, so this would change it from
                        \ LDA BEGIN to LDA BEGIN+1, for example (so the next
                        \ time we do the EOR, we choose the next byte of the
                        \ decryption routine as the initial seed)

 BEQ p1d                \ If it equals zero (so the LDA BEGIN has worked itself
                        \ to LDA BEGIN+255 and round again to LDA BEGIN), jump
                        \ down to p1d as we have finally finished decrypting
                        \ the code

 LDA p1+1               \ Fetch the newly incremented low byte of the argument
                        \ to the LDA instruction at p1 above

.p1c

 CMP #(p1d - BEGIN)     \ If we have used all the bytes from the decryption
 BEQ p1b                \ routine as seeds, skip one byte and then continue on
                        \ to keep using seeds until we have done the whole page.
                        \ This means we decrypt using the following seeds:
                        \
                        \   * The contents of BEGIN
                        \   * The contents of BEGIN+1
                        \   * The contents of BEGIN+2
                        \   ...
                        \   * The contents of p1d-1
                        \   * The contents of p1d+1
                        \   ...
                        \   * The contents of BEGIN+254
                        \   * The contents of BEGIN+255
                        \
                        \ and then we are done

 JMP BEGIN              \ Otherwise look up to BEGIN to do another decryption
                        \ run, but using the next byte of the decryption routine
                        \ as the seed

.p1d

                        \ From this point on, the code is encrypted by
                        \ elite-checksum.py

 BIT BYTEV+1            \ If the high byte of BYTEV does not have bit 7 set (so
 BPL BEGIN              \ BYTEV is less than &8000, i.e. it's pointing to user
                        \ RAM rather than the ROM routine), then jump up to
                        \ BEGIN to hang machine, as it has presumably been
                        \ changed by someone trying to crack the game

                        \ Otherwise fall through into the now-decrypted loader
                        \ code to get on with loading the game

