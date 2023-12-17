\ ******************************************************************************
\
\       Name: logL
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (low byte)
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
\ so byte n contains the low byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.logL

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUB &86              \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 ELIF _EXECUTIVE

  EQUB &FF              \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 ELIF _SOURCE_DISC

  EQUB &00              \ This byte appears to be unused and just contains
                        \ random workspace noise left over from the BBC Micro
                        \ assembly process

 ENDIF

 EQUB &00, &00, &B8, &00, &4D, &B8, &D5
 EQUB &FF, &70, &4D, &B3, &B8, &6A, &D5, &05
 EQUB &00, &CC, &70, &EF, &4D, &8D, &B3, &C1
 EQUB &B8, &9A, &6A, &28, &D5, &74, &05, &88
 EQUB &00, &6B, &CC, &23, &70, &B3, &EF, &22
 EQUB &4D, &71, &8D, &A3, &B3, &BD, &C1, &BF
 EQUB &B8, &AB, &9A, &84, &6A, &4B, &28, &00
 EQUB &D5, &A7, &74, &3E, &05, &C8, &88, &45
 EQUB &FF, &B7, &6B, &1D, &CC, &79, &23, &CA
 EQUB &70, &13, &B3, &52, &EF, &89, &22, &B8
 EQUB &4D, &E0, &71, &00, &8D, &19, &A3, &2C
 EQUB &B3, &39, &BD, &3F, &C1, &40, &BF, &3C
 EQUB &B8, &32, &AB, &23, &9A, &10, &84, &F7
 EQUB &6A, &DB, &4B, &BA, &28, &94, &00, &6B
 EQUB &D5, &3E, &A7, &0E, &74, &DA, &3E, &A2
 EQUB &05, &67, &C8, &29, &88, &E7, &45, &A3
 EQUB &00, &5B, &B7, &11, &6B, &C4, &1D, &75
 EQUB &CC, &23, &79, &CE, &23, &77, &CA, &1D
 EQUB &70, &C1, &13, &63, &B3, &03, &52, &A1
 EQUB &EF, &3C, &89, &D6, &22, &6D, &B8, &03
 EQUB &4D, &96, &E0, &28, &71, &B8, &00, &47
 EQUB &8D, &D4, &19, &5F, &A3, &E8, &2C, &70
 EQUB &B3, &F6, &39, &7B, &BD, &FE, &3F, &80
 EQUB &C1, &01, &40, &80, &BF, &FD, &3C, &7A
 EQUB &B8, &F5, &32, &6F, &AB, &E7, &23, &5F
 EQUB &9A, &D5, &10, &4A, &84, &BE, &F7, &31
 EQUB &6A, &A2, &DB, &13, &4B, &82, &BA, &F1
 EQUB &28, &5E, &94, &CB, &00, &36, &6B, &A0
 EQUB &D5, &0A, &3E, &73, &A7, &DA, &0E, &41
 EQUB &74, &A7, &DA, &0C, &3E, &70, &A2, &D3
 EQUB &05, &36, &67, &98, &C8, &F8, &29, &59
 EQUB &88, &B8, &E7, &16, &45, &74, &A3, &D1

ELSE

 SKIP 1

 FOR I%, 1, 255

  EQUB INT(&2000 * LOG(I%) / LOG(2) + 0.5) MOD 256

 NEXT

ENDIF

