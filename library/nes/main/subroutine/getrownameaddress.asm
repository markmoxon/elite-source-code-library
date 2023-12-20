\ ******************************************************************************
\
\       Name: GetRowNameAddress
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Get the addresses in the nametable buffers for the start of a
\             given character row
\
\ ------------------------------------------------------------------------------
\
\ This routine returns the index of the start of a text row in the nametable
\ buffers. Character row 0 (i.e. YC = 0) is mapped to the second row on-screen,
\ as the first row is taken up by the box edge.
\
\ It's also worth noting that the first column in the nametable is column 1, not
\ column 0, as the screen has a horizontal scroll of 8, so the leftmost tile
\ on each row is scrolled around to the right side. This means that in terms of
\ tiles, column 1 is the left edge of the screen, then columns 2 to 31 form the
\ body of the screen, and column 0 is the right edge of the screen.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   YC                  The text row
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   SC(1 0)             The address in nametable buffer 0 for the start of the
\                       row
\
\   SC2(1 0)            The address in nametable buffer 1 for the start of the
\                       row
\
\ ******************************************************************************

.GetRowNameAddress

 LDA #0                 \ Set SC+1 = 0, for use at the top byte of SC(1 0) in
 STA SC+1               \ the calculation below

 LDA YC                 \ If YC = 0, then we need to return the address of the
 BEQ grow1              \ start of the top character row (i.e. the second row
                        \ on-screen), so jump to grow1

 LDA YC                 \ Set A = YC + 1
 CLC                    \
 ADC #1                 \ So this is the nametable row number for text row YC,
                        \ as nametable row 0 is taken up by the top box edge

 ASL A                  \ Set SC(1 0) = (SC+1 A) << 5 + 1
 ASL A                  \             = (0 A) << 5 + 1
 ASL A                  \             = (YC + 1) * 32 + 1
 ASL A                  \
 ROL SC+1               \ This sets SC(1 0) to the offset within the nametable
 SEC                    \ of the start of the relevant row, as there are 32
 ROL A                  \ tiles on each row
 ROL SC+1               \
 STA SC                 \ The YC + 1 part skips the top on-screen row to start
                        \ just below the top box edge, and the final + 1 takes
                        \ care of the horizontal scrolling, which makes the
                        \ first column number 1 rather than 0
                        \
                        \ The final ROL SC+1 also clears the C flag, as we know
                        \ bits 1 to 7 of SC+1 were clear before the rotation

 STA SC2                \ Set the low byte of SC2(1 0) to the low byte of
                        \ SC(1 0), as the addresses of the two nametable buffers
                        \ only differ in the high bytes

 LDA SC+1               \ Set SC(1 0) = SC(1 0) + nameBuffer0
 ADC #HI(nameBuffer0)   \
 STA SC+1               \ So SC(1 0) now points to the row's address in
                        \ nametable buffer 0 (this addition works because we
                        \ know that the C flag is clear and the low byte of
                        \ nameBuffer0 is zero)
                        \
                        \ This addition will never overflow, as we know SC+1 is
                        \ in the range 0 to 3, so this also clears the C flag

                        \ Each nametable buffer is 1024 bytes in size, which is
                        \ four pages of 256 bytes, and nametable buffer 1 is
                        \ straight after nametable buffer 0 in memory, so we can
                        \ calculate the row's address in nametable buffer 1 in
                        \ SC2(1 0) by simply adding 4 to the high byte

 ADC #4                 \ Set SC2(1 0) = SC(1 0) + (4 0)
 STA SC2+1              \
                        \ So SC2(1 0) now points to the row's address in
                        \ nametable buffer 1 (this addition works because we
                        \ know that the C flag is clear

 RTS                    \ Return from the subroutine

.grow1

                        \ If we get here then we want to return the address of
                        \ the top character row (as YC = ), which is actually
                        \ the second on-screen row (row 1), as the first row is
                        \ taken up by the top of the box

 LDA #HI(nameBuffer0+1*32+1)    \ Set SC(1 0) to the address of the tile in
 STA SC+1                       \ column 1 on tile row 1 in nametable buffer 0
 LDA #LO(nameBuffer0+1*32+1)
 STA SC

 LDA #HI(nameBuffer1+1*32+1)    \ Set SC(1 0) to the address of the tile in
 STA SC2+1                      \ column 1 on tile row 1 in nametable buffer 1
 LDA #LO(nameBuffer1+1*32+1)
 STA SC2

 RTS                    \ Return from the subroutine

