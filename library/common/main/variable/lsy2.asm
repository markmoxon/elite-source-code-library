IF _6502SP_VERSION OR _C64_VERSION \ Comment
\ ******************************************************************************
\
\       Name: LSY2
\       Type: Variable
\   Category: Drawing lines
\    Summary: The ball line heap for storing y-coordinates
\  Deep dive: The ball line heap
\
\ ******************************************************************************

ENDIF

.LSY2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 SKIP 78                \ The ball line heap for storing y-coordinates

ELIF _ELECTRON_VERSION

 SKIP 40                \ The ball line heap for storing y-coordinates

ELIF _6502SP_VERSION

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUB &8D, &77, &88, &77, &44, &BD, &A5, &AF   \ These bytes appear to be
  EQUB &77, &B5, &12, &0E, &70, &1B, &1B, &77   \ unused and just contain random
  EQUB &A7, &03, &A3, &BE, &07, &03, &77, &C4   \ workspace noise left over from
  EQUB &03, &05, &A8, &04, &1A, &1E, &04, &04   \ the BBC Micro assembly process
  EQUB &1E, &88, &79, &77, &44, &1E, &77, &19
  EQUB &12, &AB, &87, &98, &9E, &B8, &1C, &12
  EQUB &77, &C4, &05, &02, &19, &9B, &E4, &70
  EQUB &A5, &77, &12, &B2, &14, &03, &AB, &9B
  EQUB &C4, &07, &AE, &19, &04, &77, &16, &A5
  EQUB &77, &02, &19, &1E, &07, &02, &1B, &8D
  EQUB &77, &14, &18, &13, &93, &00, &1E, &B5
  EQUB &A7, &77, &C3, &03, &05, &A8, &04, &1A
  EQUB &1E, &04, &04, &1E, &88, &9B, &5F, &E4
  EQUB &77, &00, &8B, &1B, &77, &A0, &77, &07
  EQUB &16, &1E, &13, &9B, &77, &77, &77, &77
  EQUB &44, &10, &18, &18, &13, &77, &1B, &02
  EQUB &14, &1C, &77, &CD, &83, &4F, &57, &4E
  EQUB &5E, &4A, &49, &5F, &59, &5A, &44, &00
  EQUB &12, &1B, &1B, &77, &13, &88, &12, &77
  EQUB &CD, &9B, &E4, &77, &1F, &16, &AD, &77
  EQUB &8D, &05, &01, &93, &02, &04, &77, &00
  EQUB &12, &1B, &1B, &E5, &00, &12, &77, &04
  EQUB &1F, &B3, &1B, &77, &A5, &1A, &12, &1A
  EQUB &15, &A3, &9B, &00, &12, &77, &13, &1E
  EQUB &13, &77, &B4, &03, &77, &12, &0F, &07
  EQUB &12, &14, &03, &77, &C4, &44, &B5, &B9
  EQUB &10, &18, &1E, &13, &04, &9E, &11, &A7
  EQUB &13, &77, &8E, &03, &77, &16, &15, &8E
  EQUB &03, &77, &E4, &9B, &11, &AA, &77, &C4
  EQUB &1A, &18, &1A, &A1, &03, &77, &07, &B2
  EQUB &16, &8D, &77, &16, &14, &BE, &07, &03
  EQUB &77, &C3, &44, &19, &16, &01, &0E, &77

 ELIF _EXECUTIVE

  EQUB &A7, &03, &A3, &BE, &07, &03, &77, &C4   \ These bytes appear to be
  EQUB &03, &05, &A8, &04, &1A, &1E, &04, &04   \ unused and just contain random
  EQUB &1E, &88, &79, &77, &44, &1E, &77, &19   \ workspace noise left over from
  EQUB &12, &AB, &87, &98, &9E, &B8, &1C, &12   \ the BBC Micro assembly process
  EQUB &77, &C4, &05, &02, &19, &9B, &E4, &70
  EQUB &A5, &77, &12, &B2, &14, &03, &AB, &9B
  EQUB &C4, &07, &AE, &19, &04, &77, &16, &A5
  EQUB &77, &02, &19, &1E, &07, &02, &1B, &8D
  EQUB &77, &14, &18, &13, &93, &00, &1E, &B5
  EQUB &A7, &77, &C3, &03, &05, &A8, &04, &1A
  EQUB &1E, &04, &04, &1E, &88, &9B, &5F, &E4
  EQUB &77, &00, &8B, &1B, &77, &A0, &77, &07
  EQUB &16, &1E, &13, &9B, &77, &77, &77, &77
  EQUB &44, &10, &18, &18, &13, &77, &1B, &02
  EQUB &14, &1C, &77, &CD, &83, &4F, &57, &4E
  EQUB &5E, &4A, &49, &5F, &59, &5A, &44, &00
  EQUB &12, &1B, &1B, &77, &13, &88, &12, &77
  EQUB &CD, &9B, &E4, &77, &1F, &16, &AD, &77
  EQUB &8D, &05, &01, &93, &02, &04, &77, &00
  EQUB &12, &1B, &1B, &E5, &00, &12, &77, &04
  EQUB &1F, &B3, &1B, &77, &A5, &1A, &12, &1A
  EQUB &15, &A3, &9B, &00, &12, &77, &13, &1E
  EQUB &13, &77, &B4, &03, &77, &12, &0F, &07
  EQUB &12, &14, &03, &77, &C4, &44, &B5, &B9
  EQUB &10, &18, &1E, &13, &04, &9E, &11, &A7
  EQUB &13, &77, &8E, &03, &77, &16, &15, &8E
  EQUB &03, &77, &E4, &9B, &11, &AA, &77, &C4
  EQUB &1A, &18, &1A, &A1, &03, &77, &07, &B2
  EQUB &16, &8D, &77, &16, &14, &BE, &07, &03
  EQUB &77, &C3, &44, &19, &16, &01, &0E, &77
  EQUB &51, &25, &52, &77, &16, &04, &77, &07
  EQUB &16, &0E, &1A, &A1, &03, &83, &4F, &57

 ELIF _SOURCE_DISC

  EQUB &8D, &77, &88, &77, &44, &BD, &A5, &AF   \ These bytes appear to be
  EQUB &77, &B5, &12, &0E, &70, &1B, &1B, &77   \ unused and just contain random
  EQUB &A7, &03, &A3, &BE, &07, &03, &77, &C4   \ workspace noise left over from
  EQUB &03, &05, &A8, &04, &1A, &1E, &04, &04   \ the BBC Micro assembly process
  EQUB &1E, &88, &79, &77, &44, &1E, &77, &19
  EQUB &12, &AB, &87, &98, &9E, &B8, &1C, &12
  EQUB &77, &C4, &05, &02, &19, &9B, &E4, &70
  EQUB &A5, &77, &12, &B2, &14, &03, &AB, &9B
  EQUB &C4, &07, &AE, &19, &04, &77, &16, &A5
  EQUB &77, &02, &19, &1E, &07, &02, &1B, &8D
  EQUB &77, &14, &18, &13, &93, &00, &1E, &B5
  EQUB &A7, &77, &C3, &03, &05, &A8, &04, &1A
  EQUB &1E, &04, &04, &1E, &88, &9B, &5F, &E4
  EQUB &77, &00, &8B, &1B, &77, &A0, &77, &07
  EQUB &16, &1E, &13, &9B, &77, &77, &77, &77
  EQUB &44, &10, &18, &18, &13, &77, &1B, &02
  EQUB &14, &1C, &77, &CD, &83, &4F, &57, &4E
  EQUB &5E, &4A, &49, &5F, &59, &5A, &44, &00
  EQUB &12, &1B, &1B, &77, &13, &88, &12, &77
  EQUB &CD, &9B, &E4, &77, &1F, &16, &AD, &77
  EQUB &8D, &05, &01, &93, &02, &04, &77, &00
  EQUB &12, &1B, &1B, &E5, &00, &12, &77, &04
  EQUB &1F, &B3, &1B, &77, &A5, &1A, &12, &1A
  EQUB &15, &A3, &9B, &00, &12, &77, &13, &1E
  EQUB &13, &77, &B4, &03, &77, &12, &0F, &07
  EQUB &12, &14, &03, &77, &C4, &44, &B5, &B9
  EQUB &10, &18, &1E, &13, &04, &9E, &11, &A7
  EQUB &13, &77, &8E, &03, &77, &16, &15, &8E
  EQUB &03, &77, &E4, &9B, &11, &AA, &77, &C4
  EQUB &1A, &18, &1A, &A1, &03, &77, &07, &B2
  EQUB &16, &8D, &77, &16, &14, &BE, &07, &03
  EQUB &77, &C3, &44, &19, &16, &01, &0E, &77

 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing y-coordinates

ENDIF

ELIF _MASTER_VERSION OR _APPLE_VERSION

 SKIP 256               \ The ball line heap for storing y-coordinates

ELIF _C64_VERSION

IF _MATCH_ORIGINAL_BINARIES

 IF _GMA_RELEASE

  EQUB &85, &2E, &29, &0F, &AA, &B5, &35, &D0   \ These bytes appear to be
  EQUB &FE, &A5, &2E, &4A, &4A, &4A, &4A, &AA   \ unused and just contain random
  EQUB &B5, &35, &D0, &FE, &C8, &B1, &5B, &85   \ workspace noise left over from
  EQUB &2E, &29, &0F, &AA, &B5, &35, &D0, &FE   \ the BBC Micro assembly process
  EQUB &A5, &2E, &4A, &4A, &4A, &4A, &AA, &B5
  EQUB &35, &D0, &FE, &4C, &8E, &9D, &A5, &BB
  EQUB &85, &6C, &0A, &85, &6E, &0A, &85, &70
  EQUB &20, &2C, &9A, &A5, &0B, &85, &6D, &45
  EQUB &72, &30, &FE, &18, &A5, &71, &65, &09
  EQUB &85, &6B, &A5, &0A, &69, &00, &85, &6C
  EQUB &4C, &B3, &9D, &A5, &09, &38, &E5, &71
  EQUB &85, &6B, &A5, &0A, &E9, &00, &85, &6C
  EQUB &B0, &FE, &49, &FF, &85, &6C, &A9, &01
  EQUB &E5, &6B, &85, &6B, &90, &02, &E6, &6C
  EQUB &A5, &6D, &49, &80, &85, &6D, &A5, &0E
  EQUB &85, &70, &45, &74, &30, &FE, &18, &A5
  EQUB &73, &65, &0C, &85, &6E, &A5, &0D, &69
  EQUB &00, &85, &6F, &4C, &EE, &9D, &A5, &0C
  EQUB &38, &E5, &73, &85, &6E, &A5, &0D, &E9
  EQUB &00, &85, &6F, &B0, &FE, &49, &FF, &85
  EQUB &6F, &A5, &6E, &49, &FF, &69, &01, &85
  EQUB &6E, &A5, &70, &49, &80, &85, &70, &90
  EQUB &FE, &E6, &6F, &A5, &76, &30, &FE, &A5
  EQUB &75, &18, &65, &0F, &85, &BB, &A5, &10
  EQUB &69, &00, &85, &99, &4C, &27, &9E, &A6
  EQUB &9A, &F0, &FE, &A2, &00, &4A, &E8, &C5
  EQUB &9A, &B0, &FA, &86, &9C, &20, &AF, &99
  EQUB &A6, &9C, &A5, &9B, &0A, &26, &99, &30
  EQUB &FE, &CA, &D0, &F8, &85, &9B, &60, &A9
  EQUB &32, &85, &9B, &85, &99, &60, &A9, &80
  EQUB &38, &E5, &9B, &9D, &00, &01, &E8, &A9
  EQUB &00, &E5, &99, &9D, &00, &01, &4C, &61

 ELIF _SOURCE_DISK

  EQUB &85, &AE, &A5, &57, &18, &69, &14, &85   \ These bytes appear to be
  EQUB &5B, &A5, &58, &69, &00, &85, &5C, &A0   \ unused and just contain random
  EQUB &00, &84, &AA, &84, &9F, &B1, &5B, &85   \ workspace noise left over from
  EQUB &6B, &C8, &B1, &5B, &85, &6D, &C8, &B1   \ the BBC Micro assembly process
  EQUB &5B, &85, &6F, &C8, &B1, &5B, &85, &BB
  EQUB &29, &1F, &C5, &AD, &90, &FB, &C8, &B1
  EQUB &5B, &85, &2E, &29, &0F, &AA, &B5, &35
  EQUB &D0, &FE, &A5, &2E, &4A, &4A, &4A, &4A
  EQUB &AA, &B5, &35, &D0, &FE, &C8, &B1, &5B
  EQUB &85, &2E, &29, &0F, &AA, &B5, &35, &D0
  EQUB &FE, &A5, &2E, &4A, &4A, &4A, &4A, &AA
  EQUB &B5, &35, &D0, &FE, &4C, &8E, &A6, &A5
  EQUB &BB, &85, &6C, &0A, &85, &6E, &0A, &85
  EQUB &70, &20, &2C, &A3, &A5, &0B, &85, &6D
  EQUB &45, &72, &30, &FE, &18, &A5, &71, &65
  EQUB &09, &85, &6B, &A5, &0A, &69, &00, &85
  EQUB &6C, &4C, &B3, &A6, &A5, &09, &38, &E5
  EQUB &71, &85, &6B, &A5, &0A, &E9, &00, &85
  EQUB &6C, &B0, &FE, &49, &FF, &85, &6C, &A9
  EQUB &01, &E5, &6B, &85, &6B, &90, &02, &E6
  EQUB &6C, &A5, &6D, &49, &80, &85, &6D, &A5
  EQUB &0E, &85, &70, &45, &74, &30, &FE, &18
  EQUB &A5, &73, &65, &0C, &85, &6E, &A5, &0D
  EQUB &69, &00, &85, &6F, &4C, &EE, &A6, &A5
  EQUB &0C, &38, &E5, &73, &85, &6E, &A5, &0D
  EQUB &E9, &00, &85, &6F, &B0, &FE, &49, &FF
  EQUB &85, &6F, &A5, &6E, &49, &FF, &69, &01
  EQUB &85, &6E, &A5, &70, &49, &80, &85, &70
  EQUB &90, &FE, &E6, &6F, &A5, &76, &30, &FE
  EQUB &A5, &75, &18, &65, &0F, &85, &BB, &A5
  EQUB &10, &69, &00, &85, &99, &4C, &27, &A7
  EQUB &A6, &9A, &F0, &FE, &A2, &00, &4A, &E8

 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing y-coordinates

ENDIF

ENDIF

