IF _6502SP_VERSION \ Comment
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

 SKIP 78                \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ELIF _ELECTRON_VERSION

 SKIP 40                \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

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

 SKIP 256               \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

ELIF _MASTER_VERSION

 SKIP 256               \ The ball line heap for storing y-coordinates (see the
                        \ deep dive on "The ball line heap" for details)

ENDIF

