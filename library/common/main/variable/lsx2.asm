IF _6502SP_VERSION \ Comment
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

ENDIF

