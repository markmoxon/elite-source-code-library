\ ******************************************************************************
\
\       Name: date
\       Type: Variable
\   Category: Loader
\    Summary: A date image that is included into the source disk binaries (this
\             is just random noise in the relased game)
\
\ ******************************************************************************

.date

IF _SOURCE_DISK

 INCBIN "versions/c64/1-source-files/images/C.DATE4.bin"

ELIF _GMA_RELEASE

  EQUB &33, &8D, &49, &EA, &53, &29, &2C, &2F   \ These bytes appear to be
  EQUB &87, &C4, &A0, &70, &96, &90, &B3, &38   \ unused and just contain random
  EQUB &B9, &53, &9A, &91, &AE, &2E, &70, &F8   \ workspace noise left over from
  EQUB &C8, &1B, &7C, &A1, &D1, &37, &2B, &4C   \ the BBC Micro assembly process
  EQUB &97, &F3, &4F, &73, &AD, &D2, &39, &71   \
  EQUB &4D, &EE, &F5, &D3, &4F, &E7, &C7, &F5   \ They contain part of the
  EQUB &FE, &05, &D3, &4F, &68, &88, &35, &F9   \ encrypted HICODE binary, from
  EQUB &00, &D3, &4F, &27, &4A, &38, &F6, &FD   \ file offset &1C8A to &1D89,
  EQUB &D6, &26, &CB, &1B, &BC, &ED, &0B, &33   \ from when it was assembled in
  EQUB &E9, &F0, &D3, &4F, &62, &85, &38, &F1   \ memory
  EQUB &F8, &D3, &4F, &30, &56, &3B, &05, &0C
  EQUB &D3, &4F, &68, &90, &98, &CB, &B7, &34
  EQUB &ED, &01, &08, &D3, &4F, &07, &2F, &3D
  EQUB &D1, &D8, &D3, &4F, &62, &83, &36, &DB
  EQUB &E2, &DB, &2B, &07, &71, &1A, &93, &4F
  EQUB &F8, &34, &D4, &33, &6F, &51, &CE, &D5
  EQUB &EA, &66, &8D, &AF, &37, &04, &2B, &FE
  EQUB &D7, &03, &2A, &F7, &D0, &06, &0D, &DB
  EQUB &AD, &A5, &2F, &CE, &A4, &2E, &CE, &A3
  EQUB &4D, &06, &60, &D2, &5B, &BC, &9D, &13
  EQUB &4F, &A8, &CD, &3A, &F7, &1E, &3E, &17
  EQUB &F4, &FB, &DD, &B2, &4C, &97, &35, &EA
  EQUB &45, &C9, &E9, &B0, &2F, &8B, &12, &F7
  EQUB &B6, &8B, &AB, &45, &C9, &E9, &B0, &06
  EQUB &BB, &0B, &36, &E2, &B7, &AB, &CF, &E3
  EQUB &EA, &D9, &29, &A2, &F1, &8F, &B5, &D3
  EQUB &8A, &CE, &F1, &8F, &75, &C4, &14, &0B
  EQUB &56, &0A, &E0, &2B, &35, &E6, &BC, &0C
  EQUB &30, &EA, &44, &96, &1B, &AE, &8A, &EA
  EQUB &0B, &0C, &86, &44, &96, &38, &2C, &36
  EQUB &D3, &4F, &29, &50, &D3, &05, &45, &C9
  EQUB &E9, &B0, &E9, &19, &B5, &0B, &FB, &B9

ENDIF

