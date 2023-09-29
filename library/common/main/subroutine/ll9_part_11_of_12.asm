\ ******************************************************************************
\
\       Name: LL9 (Part 11 of 12)
\       Type: Subroutine
\   Category: Drawing ships
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\    Summary: Draw ship: Add all visible edges to the ship line heap
ELIF _MASTER_VERSION
\    Summary: Draw ship: Loop back for the next edge
ENDIF
\  Deep dive: Drawing ships
\
IF NOT(_NES_VERSION)
\ ------------------------------------------------------------------------------
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ This part adds all the visible edges to the ship line heap, so we can draw
\ them in part 12.
\
ENDIF
IF NOT(_NES_VERSION)
\ Other entry points:
\
\   LL81+2              Draw the contents of the ship line heap, used to draw
\                       the ship as a dot from SHPPT
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group A: The cassette, disc and 6502SP versions add all the lines in a ship to the heap and then draw them all in one go, whereas the Master version erases and draws lines as they are added to the ship line heap

.LL80

 LDY U                  \ Fetch the ship line heap pointer, which points to the
                        \ next free byte on the heap, into Y

 LDA XX15               \ Add X1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+1             \ Add Y1 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+2             \ Add X2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 LDA XX15+3             \ Add Y2 to the end of the heap
 STA (XX19),Y

 INY                    \ Increment the heap pointer

 STY U                  \ Store the updated ship line heap pointer in U

 CPY T1                 \ If Y >= T1 then we have reached the maximum number of
 BCS LL81               \ edge lines that we can store in the ship line heap, so
                        \ skip to LL81 so we don't loop back for the next edge

ENDIF

.LL78

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Master: See group A

 INC XX17               \ Increment the edge counter to point to the next edge

 LDY XX17               \ If Y >= XX20, which contains the number of edges in
 CPY XX20               \ the blueprint, jump to LL81 as we have processed all
 BCS LL81               \ the edges and don't need to loop back for the next one

 LDY #0                 \ Set Y to point to byte #0 again, ready for the next
                        \ edge

ELIF _MASTER_VERSION

 LDA LSNUM              \ If LSNUM >= CNT, skip to LL81 so we don't loop back
 CMP CNT                \ for the next edge (CNT was set to the maximum heap
 BCS LL81               \ size for this ship in part 10, so this checks whether
                        \ we have just run out of space in the ship line heap,
                        \ and stops drawing edges if we have)

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Minor

 LDA V                  \ Increment V by 4 so V(1 0) points to the data for the
 ADC #4                 \ next edge
 STA V

 BCC ll81               \ If the above addition didn't overflow, jump to ll81 to
                        \ skip the following instruction

 INC V+1                \ Otherwise increment the high byte of V(1 0), as we
                        \ just moved the V(1 0) pointer past a page boundary

.ll81

ELIF _MASTER_VERSION

 LDA V                  \ Increment V by 4 so V(1 0) points to the data for the
 CLC                    \ next edge
 ADC #4
 STA V

 BCC P%+4               \ If the above addition didn't overflow, skip the
                        \ following instruction

 INC V+1                \ Otherwise increment the high byte of V(1 0), as we
                        \ just moved the V(1 0) pointer past a page boundary

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _NES_VERSION \ Master: See group A

 JMP LL75               \ Loop back to LL75 to process the next edge

ELIF _MASTER_VERSION

 INC XX17               \ Increment the edge counter to point to the next edge

 LDY XX17               \ If Y < XX20, which contains the number of edges in
 CPY XX20               \ the blueprint, loop back to LL75 to process the next
 BCC LL75               \ edge

ENDIF

.LL81

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group A

                        \ We have finished adding lines to the ship line heap,
                        \ so now we need to set the first byte of the heap to
                        \ the number of bytes stored there

 LDA U                  \ Fetch the ship line heap pointer from U into A, which
                        \ points to the end of the heap, and therefore contains
                        \ the heap size

ELIF _MASTER_VERSION

 JMP LSCLR              \ Jump down to part 12 below to draw any remaining lines
                        \ from the old ship that are still in the ship line heap

ELIF _NES_VERSION

 LDA U                  \ This instruction is left over from the other versions
                        \ of Elite and has no effect
                        \
                        \ It would fetch the ship line heap pointer from U, but
                        \ the NES version does not have a ship line heap as the
                        \ screen is redrawn for every frame

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ Minor

 LDY #0                 \ Store A as the first byte of the ship line heap, so
 STA (XX19),Y           \ the heap is now correctly set up

ELIF _6502SP_VERSION

 STA (XX19)             \ Store A as the first byte of the ship line heap, so
                        \ the heap is now correctly set up

ENDIF

