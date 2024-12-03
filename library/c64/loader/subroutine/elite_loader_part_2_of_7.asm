\ ******************************************************************************
\
\       Name: Elite loader (Part 2 of 7)
\       Type: Subroutine
\   Category: Loader
\    Summary: Copy the game data to their correct locations
\
\ ******************************************************************************

.U%

 LDX #&16               \ Set X = &16 so we copy 22 pages of data from LODATA
                        \ into &0700 to &1CFF

 LDA #0                 \ Set ZP(1 0) = &0700
 STA ZP
 LDA #&7
 STA ZP+1

 LDA #LO(LODATA)        \ Set (A ZP2) = LODATA
 STA ZP2
 LDA #HI(LODATA)

 JSR mvblock            \ Call mvblock to copy 22 pages of data from LODATA to
                        \ &0700, so this copies the following data:
                        \
                        \   * QQ18 to &0700, the text token table
                        \
                        \   * SNE to &0AC0, the sine lookup table
                        \
                        \   * ACT to &0AE0, the arctan lookup table
                        \
                        \   * FONT to $0B00, the game's text font
                        \
                        \   * TKN1 to $0E00, the extended token table
                        \
                        \ The data at TKN1 ends at &1CFF

 SEI                    \ Disable interrupts while we set the 6510 input/output
                        \ port register and configure the VIC-II chip

 LDA L1                 \ Set bits 0 to 2 of the 6510 port register at location
 AND #%11111000         \ L1 to %100 to set the input/output port to the
 ORA #%00000100         \ following:
 STA L1                 \
                        \   * LORAM = 0
                        \   * HIRAM = 0
                        \   * CHAREN = 1
                        \
                        \ and return from the subroutine using a tail call
                        \
                        \ This sets the entire 64K memory map to RAM
                        \
                        \ See the memory map at the top of page 265 in the
                        \ Programmer's Reference Guide

IF _GMA_RELEASE

 LDX #&29               \ Set X = &29 so we copy 41 pages of data from SHIPS
                        \ into D% (&D000 to &F8FF)
                        \
                        \ It isn't necessary to copy this number of pages, as
                        \ the ship data only takes up 32 pages of memory, and
                        \ the extra data that's copied from &F000 to &F8FF is
                        \ just ignored

ELIF _SOURCE_DISK

 LDX #&20               \ Set X = &20 so we copy 32 pages of data from SHIPS
                        \ to D% (&D000 to &EFFF)

ENDIF

 LDA #LO(D%)            \ Set ZP(1 0) = D% = &D000
 STA ZP
 LDA #HI(D%)
 STA ZP+1

 LDA #LO(SHIPS)         \ Set (A ZP2) = SHIPS
 STA ZP2
 LDA #HI(SHIPS)

 JSR mvblock            \ Call mvblock to copy X pages of data from SHIPS to D%
                        \ (&D000), so this copiesthe following data:
                        \
                        \   * XX21 to &D000, the ship blueprints
                        \
                        \ The data at XX21 ends at &EF8C

