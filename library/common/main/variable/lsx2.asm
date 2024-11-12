IF _6502SP_VERSION OR _C64_VERSION \ Comment
\ ******************************************************************************
\
\       Name: LSX2
\       Type: Variable
\   Category: Drawing lines
\    Summary: The ball line heap for storing x-coordinates
\  Deep dive: The ball line heap
\
\ ******************************************************************************

ENDIF

.LSX2

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 SKIP 78                \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _ELECTRON_VERSION

 SKIP 40                \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _6502SP_VERSION

IF _MATCH_ORIGINAL_BINARIES

 IF _SNG45

  EQUB &16, &01, &0E, &77, &1F, &16, &AD, &77   \ These bytes appear to be
  EQUB &A0, &A1, &77, &1C, &12, &12, &07, &94   \ unused and just contain random
  EQUB &C4, &44, &B5, &B9, &10, &18, &1E, &13   \ workspace noise left over from
  EQUB &04, &77, &18, &11, &11, &77, &E4, &05   \ the BBC Micro assembly process
  EQUB &77, &16, &04, &04, &77, &8E, &03, &77
  EQUB &A7, &77, &13, &12, &12, &07, &77, &04
  EQUB &07, &16, &BE, &77, &11, &AA, &77, &B8
  EQUB &19, &0E, &77, &0E, &12, &B9, &04, &77
  EQUB &B4, &00, &79, &77, &44, &00, &12, &1B
  EQUB &1B, &77, &C4, &04, &8C, &02, &16, &AC
  EQUB &88, &77, &1F, &16, &04, &77, &14, &1F
  EQUB &A8, &10, &AB, &9B, &8E, &05, &77, &15
  EQUB &18, &0E, &04, &77, &B9, &12, &77, &A5
  EQUB &16, &13, &0E, &77, &11, &AA, &87, &07
  EQUB &02, &04, &1F, &77, &05, &1E, &10, &1F
  EQUB &03, &9E, &C4, &1F, &18, &1A, &12, &77
  EQUB &04, &0E, &04, &03, &12, &1A, &77, &18
  EQUB &11, &77, &B5, &18, &8D, &77, &1A, &18
  EQUB &B5, &A3, &04, &9B, &4F, &5E, &49, &4A
  EQUB &1E, &5A, &77, &1F, &16, &AD, &77, &18
  EQUB &15, &03, &16, &A7, &93, &C4, &13, &12
  EQUB &11, &A1, &BE, &77, &07, &AE, &19, &04
  EQUB &77, &11, &AA, &77, &B5, &12, &1E, &05
  EQUB &77, &44, &1F, &1E, &AD, &77, &44, &00
  EQUB &AA, &1B, &13, &04, &9B, &C4, &A0, &8A
  EQUB &B2, &04, &77, &1C, &B4, &00, &77, &00
  EQUB &12, &70, &AD, &77, &10, &18, &03, &77
  EQUB &BC, &1A, &12, &B5, &94, &15, &02, &03
  EQUB &77, &B4, &03, &77, &00, &1F, &A2, &9B
  EQUB &1E, &11, &77, &44, &1E, &77, &03, &AF
  EQUB &19, &04, &1A, &8C, &77, &C4, &07, &AE
  EQUB &19, &04, &9E, &8E, &05, &77, &15, &16

 ELIF _EXECUTIVE

  EQUB &C4, &44, &B5, &B9, &10, &18, &1E, &13   \ These bytes appear to be
  EQUB &04, &77, &18, &11, &11, &77, &E4, &05   \ unused and just contain random
  EQUB &77, &16, &04, &04, &77, &8E, &03, &77   \ workspace noise left over from
  EQUB &A7, &77, &13, &12, &12, &07, &77, &04   \ the BBC Micro assembly process
  EQUB &07, &16, &BE, &77, &11, &AA, &77, &B8
  EQUB &19, &0E, &77, &0E, &12, &B9, &04, &77
  EQUB &B4, &00, &79, &77, &44, &00, &12, &1B
  EQUB &1B, &77, &C4, &04, &8C, &02, &16, &AC
  EQUB &88, &77, &1F, &16, &04, &77, &14, &1F
  EQUB &A8, &10, &AB, &9B, &8E, &05, &77, &15
  EQUB &18, &0E, &04, &77, &B9, &12, &77, &A5
  EQUB &16, &13, &0E, &77, &11, &AA, &87, &07
  EQUB &02, &04, &1F, &77, &05, &1E, &10, &1F
  EQUB &03, &9E, &C4, &1F, &18, &1A, &12, &77
  EQUB &04, &0E, &04, &03, &12, &1A, &77, &18
  EQUB &11, &77, &B5, &18, &8D, &77, &1A, &18
  EQUB &B5, &A3, &04, &9B, &4F, &5E, &49, &4A
  EQUB &1E, &5A, &77, &1F, &16, &AD, &77, &18
  EQUB &15, &03, &16, &A7, &93, &C4, &13, &12
  EQUB &11, &A1, &BE, &77, &07, &AE, &19, &04
  EQUB &77, &11, &AA, &77, &B5, &12, &1E, &05
  EQUB &77, &44, &1F, &1E, &AD, &77, &44, &00
  EQUB &AA, &1B, &13, &04, &9B, &C4, &A0, &8A
  EQUB &B2, &04, &77, &1C, &B4, &00, &77, &00
  EQUB &12, &70, &AD, &77, &10, &18, &03, &77
  EQUB &BC, &1A, &12, &B5, &94, &15, &02, &03
  EQUB &77, &B4, &03, &77, &00, &1F, &A2, &9B
  EQUB &1E, &11, &77, &44, &1E, &77, &03, &AF
  EQUB &19, &04, &1A, &8C, &77, &C4, &07, &AE
  EQUB &19, &04, &9E, &8E, &05, &77, &15, &16
  EQUB &8D, &77, &88, &77, &44, &BD, &A5, &AF
  EQUB &77, &B5, &12, &0E, &70, &1B, &1B, &77

 ELIF _SOURCE_DISC

  EQUB &16, &01, &0E, &77, &1F, &16, &AD, &77   \ These bytes appear to be
  EQUB &A0, &A1, &77, &1C, &12, &12, &07, &94   \ unused and just contain random
  EQUB &C4, &44, &B5, &B9, &10, &18, &1E, &13   \ workspace noise left over from
  EQUB &04, &77, &18, &11, &11, &77, &E4, &05   \ the BBC Micro assembly process
  EQUB &77, &16, &04, &04, &77, &8E, &03, &77
  EQUB &A7, &77, &13, &12, &12, &07, &77, &04
  EQUB &07, &16, &BE, &77, &11, &AA, &77, &B8
  EQUB &19, &0E, &77, &0E, &12, &B9, &04, &77
  EQUB &B4, &00, &79, &77, &44, &00, &12, &1B
  EQUB &1B, &77, &C4, &04, &8C, &02, &16, &AC
  EQUB &88, &77, &1F, &16, &04, &77, &14, &1F
  EQUB &A8, &10, &AB, &9B, &8E, &05, &77, &15
  EQUB &18, &0E, &04, &77, &B9, &12, &77, &A5
  EQUB &16, &13, &0E, &77, &11, &AA, &87, &07
  EQUB &02, &04, &1F, &77, &05, &1E, &10, &1F
  EQUB &03, &9E, &C4, &1F, &18, &1A, &12, &77
  EQUB &04, &0E, &04, &03, &12, &1A, &77, &18
  EQUB &11, &77, &B5, &18, &8D, &77, &1A, &18
  EQUB &B5, &A3, &04, &9B, &4F, &5E, &49, &4A
  EQUB &1E, &5A, &77, &1F, &16, &AD, &77, &18
  EQUB &15, &03, &16, &A7, &93, &C4, &13, &12
  EQUB &11, &A1, &BE, &77, &07, &AE, &19, &04
  EQUB &77, &11, &AA, &77, &B5, &12, &1E, &05
  EQUB &77, &44, &1F, &1E, &AD, &77, &44, &00
  EQUB &AA, &1B, &13, &04, &9B, &C4, &A0, &8A
  EQUB &B2, &04, &77, &1C, &B4, &00, &77, &00
  EQUB &12, &70, &AD, &77, &10, &18, &03, &77
  EQUB &BC, &1A, &12, &B5, &94, &15, &02, &03
  EQUB &77, &B4, &03, &77, &00, &1F, &A2, &9B
  EQUB &1E, &11, &77, &44, &1E, &77, &03, &AF
  EQUB &19, &04, &1A, &8C, &77, &C4, &07, &AE
  EQUB &19, &04, &9E, &8E, &05, &77, &15, &16

 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

ELIF _MASTER_VERSION OR _APPLE_VERSION

 SKIP 256               \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _C64_VERSION

IF _MATCH_ORIGINAL_BINARIES

 IF _GMA85_NTSC OR _GMA86_PAL

  EQUB &76, &85, &9C, &A5, &8B, &85, &9A, &A5   \ These bytes appear to be
  EQUB &8D, &20, &0C, &9A, &B0, &D2, &85, &6F   \ unused and just contain random
  EQUB &A5, &9C, &85, &70, &A5, &6B, &85, &9B   \ workspace noise left over from
  EQUB &A5, &72, &85, &9C, &A5, &85, &85, &9A   \ the BBC Micro assembly process
  EQUB &A5, &87, &20, &0C, &9A, &B0, &B9, &85
  EQUB &6B, &A5, &9C, &85, &6C, &A5, &6D, &85
  EQUB &9B, &A5, &74, &85, &9C, &A5, &88, &85
  EQUB &9A, &A5, &8A, &20, &0C, &9A, &B0, &A0
  EQUB &85, &6D, &A5, &9C, &85, &6E, &A5, &71
  EQUB &85, &9A, &A5, &6B, &20, &EA, &39, &85
  EQUB &BB, &A5, &72, &45, &6C, &85, &9C, &A5
  EQUB &73, &85, &9A, &A5, &6D, &20, &EA, &39
  EQUB &85, &9A, &A5, &BB, &85, &9B, &A5, &74
  EQUB &45, &6E, &20, &0C, &9A, &85, &BB, &A5
  EQUB &75, &85, &9A, &A5, &6F, &20, &EA, &39
  EQUB &85, &9A, &A5, &BB, &85, &9B, &A5, &70
  EQUB &45, &76, &20, &0C, &9A, &48, &98, &4A
  EQUB &4A, &AA, &68, &24, &9C, &30, &02, &A9
  EQUB &00, &95, &35, &C8, &C4, &AE, &B0, &FE
  EQUB &4C, &F2, &9B, &A4, &47, &A6, &48, &A5
  EQUB &4B, &85, &47, &A5, &4C, &85, &48, &84
  EQUB &4B, &86, &4C, &A4, &49, &A6, &4A, &A5
  EQUB &51, &85, &49, &A5, &52, &85, &4A, &84
  EQUB &51, &86, &52, &A4, &4F, &A6, &50, &A5
  EQUB &53, &85, &4F, &A5, &54, &85, &50, &84
  EQUB &53, &86, &54, &A0, &08, &B1, &57, &85
  EQUB &AE, &A5, &57, &18, &69, &14, &85, &5B
  EQUB &A5, &58, &69, &00, &85, &5C, &A0, &00
  EQUB &84, &AA, &84, &9F, &B1, &5B, &85, &6B
  EQUB &C8, &B1, &5B, &85, &6D, &C8, &B1, &5B
  EQUB &85, &6F, &C8, &B1, &5B, &85, &BB, &29
  EQUB &1F, &C5, &AD, &90, &FB, &C8, &B1, &5B

 ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISC_FILES

  EQUB &60, &6D, &A5, &8A, &85, &6E, &A5, &8B   \ These bytes appear to be
  EQUB &85, &6F, &A5, &8D, &85, &70, &4C, &40   \ unused and just contain random
  EQUB &A5, &46, &85, &46, &8B, &46, &88, &A2   \ workspace noise left over from
  EQUB &01, &A5, &71, &85, &6B, &A5, &73, &85   \ the BBC Micro assembly process
  EQUB &6D, &A5, &75, &CA, &30, &FE, &46, &6B
  EQUB &46, &6D, &4A, &CA, &10, &F8, &85, &9B
  EQUB &A5, &76, &85, &9C, &A5, &8B, &85, &9A
  EQUB &A5, &8D, &20, &0C, &A3, &B0, &D2, &85
  EQUB &6F, &A5, &9C, &85, &70, &A5, &6B, &85
  EQUB &9B, &A5, &72, &85, &9C, &A5, &85, &85
  EQUB &9A, &A5, &87, &20, &0C, &A3, &B0, &B9
  EQUB &85, &6B, &A5, &9C, &85, &6C, &A5, &6D
  EQUB &85, &9B, &A5, &74, &85, &9C, &A5, &88
  EQUB &85, &9A, &A5, &8A, &20, &0C, &A3, &B0
  EQUB &A0, &85, &6D, &A5, &9C, &85, &6E, &A5
  EQUB &71, &85, &9A, &A5, &6B, &20, &E7, &39
  EQUB &85, &BB, &A5, &72, &45, &6C, &85, &9C
  EQUB &A5, &73, &85, &9A, &A5, &6D, &20, &E7
  EQUB &39, &85, &9A, &A5, &BB, &85, &9B, &A5
  EQUB &74, &45, &6E, &20, &0C, &A3, &85, &BB
  EQUB &A5, &75, &85, &9A, &A5, &6F, &20, &E7
  EQUB &39, &85, &9A, &A5, &BB, &85, &9B, &A5
  EQUB &70, &45, &76, &20, &0C, &A3, &48, &98
  EQUB &4A, &4A, &AA, &68, &24, &9C, &30, &02
  EQUB &A9, &00, &95, &35, &C8, &C4, &AE, &B0
  EQUB &FE, &4C, &F2, &A4, &A4, &47, &A6, &48
  EQUB &A5, &4B, &85, &47, &A5, &4C, &85, &48
  EQUB &84, &4B, &86, &4C, &A4, &49, &A6, &4A
  EQUB &A5, &51, &85, &49, &A5, &52, &85, &4A
  EQUB &84, &51, &86, &52, &A4, &4F, &A6, &50
  EQUB &A5, &53, &85, &4F, &A5, &54, &85, &50
  EQUB &84, &53, &86, &54, &A0, &08, &B1, &57

 ENDIF

ELSE

 SKIP 256               \ The ball line heap for storing x-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

ENDIF

