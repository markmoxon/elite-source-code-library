\ ******************************************************************************
\
\       Name: wtable
\       Type: Variable
\   Category: Save and load
\    Summary: 6-bit to 7-bit nibble conversion table
IF _APPLE_VERSION
\  Deep dive: File operations with embedded Apple DOS
ENDIF
\
\ ------------------------------------------------------------------------------
\
IF _MASTER_VERSION
\ This table is not used in this version of Elite. It is left over from the
\ Apple II version.
\
ELIF _APPLE_VERSION
\ This table is identical to the NIBL table in Apple DOS 3.3.
\
\ The original DOS 3.3 source code for this table in is shown in the comments.
\
\ Elite uses different label names to the original DOS 3.3 source, but the code
\ is the same.
\
\ This code forms part of the RWTS ("read/write track-sector") layer from Apple
\ DOS, which was written by Randy Wigginton and Steve Wozniak. It implements the
\ low-level functions to read and write Apple disks, and is included in Elite so
\ the game can use the memory that's normally allocated to DOS for its own use.
\
ENDIF
\ ******************************************************************************

.wtable

 EQUD &9B9A9796         \ NIBL     DFB $96,$97,$9A
 EQUD &A69F9E9D         \          DFB $9B,$9D,$9E
 EQUD &ADACABA7         \          DFB $9F,$A6,$A7
 EQUD &B3B2AFAE         \          DFB $AB,$AC,$AD
 EQUD &B7B6B5B4         \          DFB $AE,$AF,$B2
 EQUD &BCBBBAB9         \          DFB $B3,$B4,$B5
 EQUD &CBBFBEBD         \          DFB $B6,$B7,$B9
 EQUD &D3CFCECD         \          DFB $BA,$BB,$BC
 EQUD &DAD9D7D6         \          DFB $BD,$BE,$BF
 EQUD &DEDDDCDB         \          DFB $CB,$CD,$CE
 EQUD &E7E6E5DF         \          DFB $CF,$D3,$D6
 EQUD &ECEBEAE9         \          DFB $D7,$D9,$DA
 EQUD &F2EFEEED         \          DFB $DB,$DC,$DD
 EQUD &F6F5F4F3         \          DFB $DE,$DF,$E5
 EQUD &FBFAF9F7         \          DFB $E6,$E7,$E9
 EQUD &FFFEFDFC         \          DFB $EA,$EB,$EC
                        \          DFB $ED,$EE,$EF
                        \          DFB $F2,$F3,$F4
                        \          DFB $F5,$F6,$F7
                        \          DFB $F9,$FA,$FB
                        \          DFB $FC,$FD,$FE
                        \          DFB $FF

