\ ******************************************************************************
\
\       Name: logL
\       Type: Variable
\   Category: Maths (Arithmetic)
\    Summary: Binary logarithm table (low byte)
\
\ ------------------------------------------------------------------------------
\
\ Byte n contains the low byte of:
\
\   32 * log2(n) * 256
\
\ ******************************************************************************

.logL

IF _MATCH_ORIGINAL_BINARIES

IF _6502SP_VERSION \ Platform

 IF _SNG45

  EQUB &99             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ELIF _EXECUTIVE

  EQUB &08             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ELIF _SOURCE_DISC

  EQUB &85             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ENDIF

ELIF _NES_VERSION

 EQUB &0D              \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

ELIF _MASTER_VERSION

 IF _SNG47

  EQUB &60             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ELIF _COMPACT

  EQUB &A9             \ This byte appears to be unused and just contains
                       \ random workspace noise left over from the BBC Micro
                       \ assembly process

 ENDIF

ENDIF

IF _6502SP_VERSION OR _NES_VERSION \ Platform

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

ELIF _MASTER_VERSION

 EQUB &00, &00, &B8, &00, &4D, &B8, &D6
 EQUB &00, &70, &4D, &B4, &B8, &6A, &D6, &05
 EQUB &00, &CC, &70, &EF, &4D, &8E, &B4, &C1
 EQUB &B8, &9A, &6A, &28, &D6, &75, &05, &89
 EQUB &00, &6C, &CC, &23, &70, &B4, &EF, &22
 EQUB &4D, &71, &8E, &A4, &B4, &BD, &C1, &BF
 EQUB &B8, &AC, &9A, &85, &6A, &4B, &28, &01
 EQUB &D6, &A7, &75, &3F, &05, &C9, &89, &46
 EQUB &00, &B7, &6C, &1D, &CC, &79, &23, &CB
 EQUB &70, &13, &B4, &52, &EF, &8A, &22, &B9
 EQUB &4D, &E0, &71, &00, &8E, &1A, &A4, &2D
 EQUB &B4, &39, &BD, &40, &C1, &41, &BF, &3C
 EQUB &B8, &32, &AC, &24, &9A, &10, &85, &F8
 EQUB &6A, &DB, &4B, &BA, &28, &95, &01, &6C
 EQUB &D6, &3F, &A7, &0E, &75, &DA, &3F, &A2
 EQUB &05, &67, &C9, &29, &89, &E8, &46, &A3
 EQUB &00, &5C, &B7, &12, &6C, &C5, &1D, &75
 EQUB &CC, &23, &79, &CE, &23, &77, &CB, &1E
 EQUB &70, &C2, &13, &64, &B4, &03, &52, &A1
 EQUB &EF, &3D, &8A, &D6, &22, &6E, &B9, &03
 EQUB &4D, &97, &E0, &29, &71, &B9, &00, &47
 EQUB &8E, &D4, &1A, &5F, &A4, &E8, &2D, &70
 EQUB &B4, &F7, &39, &7B, &BD, &FF, &40, &81
 EQUB &C1, &01, &41, &80, &BF, &FE, &3C, &7A
 EQUB &B8, &F5, &32, &6F, &AC, &E8, &24, &5F
 EQUB &9A, &D5, &10, &4A, &85, &BE, &F8, &31
 EQUB &6A, &A3, &DB, &13, &4B, &83, &BA, &F1
 EQUB &28, &5F, &95, &CB, &01, &36, &6C, &A1
 EQUB &D6, &0A, &3F, &73, &A7, &DB, &0E, &42
 EQUB &75, &A7, &DA, &0C, &3F, &71, &A2, &D4
 EQUB &05, &36, &67, &98, &C9, &F9, &29, &59
 EQUB &89, &B8, &E8, &17, &46, &75, &A3, &D2

ENDIF
 
ELSE

 SKIP 1

 FOR I%, 1, 255

  B% = INT(&2000 * LOG(I%) / LOG(2) + 0.5)

  EQUB B% MOD 256

 NEXT

ENDIF

