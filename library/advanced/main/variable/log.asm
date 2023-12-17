\ ******************************************************************************
\
\       Name: log
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (high byte)
\
\ ------------------------------------------------------------------------------
\
\ At byte n, the table contains the high byte of:
\
\   &2000 * log10(n) / log10(2) = 32 * 256 * log10(n) / log10(2)
\
\ where log10 is the logarithm to base 10. The change-of-base formula says that:
\
\   log2(n) = log10(n) / log10(2)
\
\ so byte n contains the high byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.log

IF _MATCH_ORIGINAL_BINARIES

IF _6502SP_VERSION \ Platform

 IF _SNG45

  EQUB &02             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ELIF _EXECUTIVE

  EQUB &DC             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ELIF _SOURCE_DISC

  EQUB &03             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ENDIF

ELIF _NES_VERSION

 EQUB &6C              \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

ELIF _MASTER_VERSION

 EQUB &00              \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Platform

 EQUB &00, &20, &32, &40, &4A, &52, &59
 EQUB &5F, &65, &6A, &6E, &72, &76, &79, &7D
 EQUB &80, &82, &85, &87, &8A, &8C, &8E, &90
 EQUB &92, &94, &96, &98, &99, &9B, &9D, &9E
 EQUB &A0, &A1, &A2, &A4, &A5, &A6, &A7, &A9
 EQUB &AA, &AB, &AC, &AD, &AE, &AF, &B0, &B1
 EQUB &B2, &B3, &B4, &B5, &B6, &B7, &B8, &B9
 EQUB &B9, &BA, &BB, &BC, &BD, &BD, &BE, &BF
 EQUB &BF, &C0, &C1, &C2, &C2, &C3, &C4, &C4
 EQUB &C5, &C6, &C6, &C7, &C7, &C8, &C9, &C9
 EQUB &CA, &CA, &CB, &CC, &CC, &CD, &CD, &CE
 EQUB &CE, &CF, &CF, &D0, &D0, &D1, &D1, &D2
 EQUB &D2, &D3, &D3, &D4, &D4, &D5, &D5, &D5
 EQUB &D6, &D6, &D7, &D7, &D8, &D8, &D9, &D9
 EQUB &D9, &DA, &DA, &DB, &DB, &DB, &DC, &DC
 EQUB &DD, &DD, &DD, &DE, &DE, &DE, &DF, &DF
 EQUB &E0, &E0, &E0, &E1, &E1, &E1, &E2, &E2
 EQUB &E2, &E3, &E3, &E3, &E4, &E4, &E4, &E5
 EQUB &E5, &E5, &E6, &E6, &E6, &E7, &E7, &E7
 EQUB &E7, &E8, &E8, &E8, &E9, &E9, &E9, &EA
 EQUB &EA, &EA, &EA, &EB, &EB, &EB, &EC, &EC
 EQUB &EC, &EC, &ED, &ED, &ED, &ED, &EE, &EE
 EQUB &EE, &EE, &EF, &EF, &EF, &EF, &F0, &F0
 EQUB &F0, &F1, &F1, &F1, &F1, &F1, &F2, &F2
 EQUB &F2, &F2, &F3, &F3, &F3, &F3, &F4, &F4
 EQUB &F4, &F4, &F5, &F5, &F5, &F5, &F5, &F6
 EQUB &F6, &F6, &F6, &F7, &F7, &F7, &F7, &F7
 EQUB &F8, &F8, &F8, &F8, &F9, &F9, &F9, &F9
 EQUB &F9, &FA, &FA, &FA, &FA, &FA, &FB, &FB
 EQUB &FB, &FB, &FB, &FC, &FC, &FC, &FC, &FC
 EQUB &FD, &FD, &FD, &FD, &FD, &FD, &FE, &FE
 EQUB &FE, &FE, &FE, &FF, &FF, &FF, &FF, &FF

ELIF _MASTER_VERSION

 EQUB &00, &20, &32, &40, &4A, &52, &59
 EQUB &60, &65, &6A, &6E, &72, &76, &79, &7D
 EQUB &80, &82, &85, &87, &8A, &8C, &8E, &90
 EQUB &92, &94, &96, &98, &99, &9B, &9D, &9E
 EQUB &A0, &A1, &A2, &A4, &A5, &A6, &A7, &A9
 EQUB &AA, &AB, &AC, &AD, &AE, &AF, &B0, &B1
 EQUB &B2, &B3, &B4, &B5, &B6, &B7, &B8, &B9
 EQUB &B9, &BA, &BB, &BC, &BD, &BD, &BE, &BF
 EQUB &C0, &C0, &C1, &C2, &C2, &C3, &C4, &C4
 EQUB &C5, &C6, &C6, &C7, &C7, &C8, &C9, &C9
 EQUB &CA, &CA, &CB, &CC, &CC, &CD, &CD, &CE
 EQUB &CE, &CF, &CF, &D0, &D0, &D1, &D1, &D2
 EQUB &D2, &D3, &D3, &D4, &D4, &D5, &D5, &D5
 EQUB &D6, &D6, &D7, &D7, &D8, &D8, &D9, &D9
 EQUB &D9, &DA, &DA, &DB, &DB, &DB, &DC, &DC
 EQUB &DD, &DD, &DD, &DE, &DE, &DE, &DF, &DF
 EQUB &E0, &E0, &E0, &E1, &E1, &E1, &E2, &E2
 EQUB &E2, &E3, &E3, &E3, &E4, &E4, &E4, &E5
 EQUB &E5, &E5, &E6, &E6, &E6, &E7, &E7, &E7
 EQUB &E7, &E8, &E8, &E8, &E9, &E9, &E9, &EA
 EQUB &EA, &EA, &EA, &EB, &EB, &EB, &EC, &EC
 EQUB &EC, &EC, &ED, &ED, &ED, &ED, &EE, &EE
 EQUB &EE, &EE, &EF, &EF, &EF, &EF, &F0, &F0
 EQUB &F0, &F1, &F1, &F1, &F1, &F1, &F2, &F2
 EQUB &F2, &F2, &F3, &F3, &F3, &F3, &F4, &F4
 EQUB &F4, &F4, &F5, &F5, &F5, &F5, &F5, &F6
 EQUB &F6, &F6, &F6, &F7, &F7, &F7, &F7, &F7
 EQUB &F8, &F8, &F8, &F8, &F9, &F9, &F9, &F9
 EQUB &F9, &FA, &FA, &FA, &FA, &FA, &FB, &FB
 EQUB &FB, &FB, &FB, &FC, &FC, &FC, &FC, &FC
 EQUB &FD, &FD, &FD, &FD, &FD, &FD, &FE, &FE
 EQUB &FE, &FE, &FE, &FF, &FF, &FF, &FF, &FF

ENDIF
 
ELSE

 SKIP 1

 FOR I%, 1, 255

  B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)

  EQUB B% DIV 256

 NEXT

ENDIF

