\ ******************************************************************************
\
\       Name: wantdials
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Show the dashboard on-screen
\
\ ******************************************************************************

.wantdials

 JSR BOX2               \ Draw a border box around the space view

 LDA #&91               \ Set abraxas = &91, so the colour of the lower part of
 STA abraxas            \ the screen is determined by screen RAM at &6400
                        \ (i.e. for when the dashboard is being shown)

 LDA #%11010000         \ Set bit 4 of caravanserai so that the lower part of
 STA caravanserai       \ the screen (the dashboard) is shown in multicolour
                        \ bitmap mode

 LDA DFLAG              \ If DFLAG is non-zero then the dashboard is already
 BNE nearlyxmas         \ being shown on-screen, so jump to nearlyxmas to skip
                        \ displaying the dashboard on-screen

                        \ We now copy the dashboard bitmap from the copy at
                        \ DSTORE% into the screen bitmap, so the dashboard
                        \ appears on-screen
                        \
                        \ The bitmap is seven character rows in size, which is
                        \ 7 * 40 * 7 = &8C0 bytes, so we need to copy this many
                        \ bytes from DSTORE% to the screen bitmap address of the
                        \ dashboard at DLOC%

 LDX #8                 \ Set X = 8 so we copy the first eight pages of the
                        \ dashboard bitmap from DSTORE% to screen memory

 LDA #LO(DSTORE%)       \ Set V(1 0) = DSTORE%
 STA V                  \
 LDA #HI(DSTORE%)       \ So V(1 0) points to the copy of the dashboard image
 STA V+1                \ and colour data at DSTORE%

 LDA #LO(DLOC%)         \ Set SC(1 0) = DLOC%
 STA SC                 \
 LDA #HI(DLOC%)         \ So SC(1 0) points to the address in the screen bitmap
 STA SC+1               \ of the start of the dashboard at DLOC%

 JSR mvblockK           \ Copy X pages from V(1 0) to SC(1 0), which copies all
                        \ eight pages of the dashboard bitmap from the copy at
                        \ DSTORE% into the screen bitmap

                        \ We have copied &800 bytes, so now for the other &C0
                        \ bytes

 LDY #&C0               \ Set Y = &C0 so we copy this many bytes

 LDX #1                 \ Set X = 1 so we copy this many bytes within just one
                        \ page

 JSR mvbllop            \ Copy Y bytes from V(1 0) to SC(1 0), so this copies
                        \ the rest of the dashboard bitmap to the screen

 JSR zonkscanners       \ Hide all ships on the scanner

 JSR DIALS              \ Call DIALS to update the dashboard

.nearlyxmas

 JSR BLUEBAND           \ Clear the borders along the edges of the space view,
                        \ to hide any sprites that might be lurking there

 JSR NOSPRITES          \ Call NOSPRITES to disable all sprites and remove them
                        \ from the screen

 LDA #&FF               \ Set DFLAG to &FF to indicate that the dashboard is now
 STA DFLAG              \ being shown on-screen

 RTS                    \ Return from the subroutine

