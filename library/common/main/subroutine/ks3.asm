\ ******************************************************************************
\
\       Name: KS3
\       Type: Subroutine
\   Category: Universe
\    Summary: Set the SLSP ship line heap pointer after shuffling ship slots
\
\ ------------------------------------------------------------------------------
\
\ The final part of the KILLSHP routine, called after we have shuffled the ship
\ slots and sorted out our missiles. This simply sets SLSP to the new bottom of
\ the ship line heap.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   P(1 0)              Points to the ship line heap of the ship in the last
\                       occupied slot (i.e. it points to the bottom of the
\                       descending heap)
\
\ ******************************************************************************

.KS3

 LDA P                  \ After shuffling the ship slots, P(1 0) will point to
 STA SLSP               \ the new bottom of the ship line heap, so store this in
 LDA P+1                \ SLSP(1 0), which stores the bottom of the heap
 STA SLSP+1

 RTS                    \ Return from the subroutine

