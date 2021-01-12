\ ******************************************************************************
\
\       Name: B%
\       Type: Variable
\   Category: Screen mode
IF _CASSETTE_VERSION OR _DISC_VERSION
\    Summary: VDU commands for setting the square mode 4 screen
ELIF _6502SP_VERSION
\    Summary: VDU commands for setting the square mode 1 screen
ENDIF
\
\ ------------------------------------------------------------------------------
\
\ This block contains the bytes that get written by OSWRCH in part 2 to set up
\ the screen mode (this is equivalent to using the VDU statement in BASIC).
\
IF _CASSETTE_VERSION OR _DISC_VERSION
\ It defines the whole screen using a square, monochrome mode 4 configuration;
\ the mode 5 part for the dashboard is implemented in the IRQ1 routine.
\
\ The top part of Elite's screen mode is based on mode 4 but with the following
\ differences:
\
\   * 32 columns, 31 rows (256 x 248 pixels) rather than 40, 32
\
\   * The horizontal sync position is at character 45 rather than 49, which
\     pushes the screen to the right (which centres it as it's not as wide as
\     the normal screen modes)
\
\   * Screen memory goes from &6000 to &7EFF, which leaves another whole page
\     for code (i.e. 256 bytes) after the end of the screen. This is where the
\     Python ship blueprint slots in
ELIF _6502SP_VERSION
\ It defines the whole screen using a square, monochrome mode 1 configuration;
\ the mode 2 part for the dashboard is implemented in the IRQ1 routine.
\
\ The top part of Elite's screen mode is based on mode 1 but with the following
\ differences:
\
\   * 64 columns, 31 rows (256 x 248 pixels) rather than 80, 32
\
\   * The horizontal sync position is at character 90 rather than 98, which
\     pushes the screen to the right (which centres it as it's not as wide as
\     the normal screen modes)
\
\   * Screen memory goes from &4000 to &7EFF
ENDIF
\
\   * The text window is 1 row high and 13 columns wide, and is at (2, 16)
\
\   * There's a large, fast-blinking cursor
\
IF _CASSETTE_VERSION OR _DISC_VERSION
\ This almost-square mode 4 variant makes life a lot easier when drawing to the
\ screen, as there are 256 pixels on each row (or, to put it in screen memory
\ terms, there's one page of memory per row of pixels). For more details of the
\ screen mode, see the deep dive on "Drawing monochrome pixels in mode 4".
\
\ There is also an interrupt-driven routine that switches the bytes-per-pixel
\ setting from that of mode 4 to that of mode 5, when the raster reaches the
\ split between the space view and the dashboard. See the deep dive on "The
\ split-screen mode" for details.
ELIF _6502SP_VERSION
\ This almost-square mode 1 variant makes life a lot easier when drawing to the
\ screen, as there are 256 pixels on each row (or, to put it in screen memory
\ terms, there are two pages of memory per row of pixels).
\
\ There is also an interrupt-driven routine that switches the bytes-per-pixel
\ setting from that of mode 1 to that of mode 2, when the raster reaches the
\ split between the space view and the dashboard. See the deep dive on "The
\ split-screen mode" for details.
ENDIF
\
\ ******************************************************************************

.B%

IF _CASSETTE_VERSION OR _DISC_VERSION

 EQUB 22, 4             \ Switch to screen mode 4

ELIF _6502SP_VERSION

 EQUB 22, 1             \ Switch to screen mode 1

ENDIF

 EQUB 28                \ Define a text window as follows:
 EQUB 2, 17, 15, 16     \
                        \   * Left = 2
                        \   * Right = 15
                        \   * Top = 16
                        \   * Bottom = 17
                        \
                        \ i.e. 1 row high, 13 columns wide at (2, 16)

 EQUB 23, 0, 6, 31      \ Set 6845 register R6 = 31
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "vertical displayed" register, and sets
                        \ the number of displayed character rows to 31. For
IF _CASSETTE_VERSION OR _DISC_VERSION
                        \ comparison, this value is 32 for standard modes 4 and
                        \ 5, but we claw back the last row for storing code just
ELIF _6502SP_VERSION
                        \ comparison, this value is 32 for standard modes 1 and
                        \ 2, but we claw back the last row for storing code just
ENDIF
                        \ above the end of screen memory

IF _CASSETTE_VERSION OR _DISC_VERSION

 EQUB 23, 0, 12, &0C    \ Set 6845 register R12 = &0C and R13 = &00
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This sets 6845 registers (R12 R13) = &0C00 to point
 EQUB 23, 0, 13, &00    \ to the start of screen memory in terms of character
 EQUB 0, 0, 0           \ rows. There are 8 pixel lines in each character row,
 EQUB 0, 0, 0           \ so to get the actual address of the start of screen
                        \ memory, we multiply by 8:
                        \
                        \   &0C00 * 8 = &6000
                        \
                        \ So this sets the start of screen memory to &6000

ELIF _6502SP_VERSION

 EQUB 23, 0, 12, &08    \ Set 6845 register R12 = &08 and R13 = &00
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This sets 6845 registers (R12 R13) = &0800 to point
 EQUB 23, 0, 13, &00    \ to the start of screen memory in terms of character
 EQUB 0, 0, 0           \ rows. There are 8 pixel lines in each character row,
 EQUB 0, 0, 0           \ so to get the actual address of the start of screen
                        \ memory, we multiply by 8:
                        \
                        \   &0800 * 8 = &4000
                        \
                        \ So this sets the start of screen memory to &4000

ENDIF

IF _CASSETTE_VERSION OR _DISC_VERSION

 EQUB 23, 0, 1, 32      \ Set 6845 register R1 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "horizontal displayed" register, which
                        \ defines the number of character blocks per horizontal
                        \ character row. For comparison, this value is 40 for
                        \ modes 4 and 5, but our custom screen is not as wide at
                        \ only 32 character blocks across

 EQUB 23, 0, 2, 45      \ Set 6845 register R2 = 45
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "horizontal sync position" register, which
                        \ defines the position of the horizontal sync pulse on
                        \ the horizontal line in terms of character widths from
                        \ the left-hand side of the screen. For comparison this
                        \ is 49 for modes 4 and 5, but needs to be adjusted for
                        \ our custom screen's width

ELIF _6502SP_VERSION

 EQUB 23, 0, 1, 64      \ Set 6845 register R1 = 64
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "horizontal displayed" register, which
                        \ defines the number of character blocks per horizontal
                        \ character row. For comparison, this value is 80 for
                        \ modes 1 and 2, but our custom screen is not as wide at
                        \ only 64 character blocks across

 EQUB 23, 0, 2, 90      \ Set 6845 register R2 = 90
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "horizontal sync position" register, which
                        \ defines the position of the horizontal sync pulse on
                        \ the horizontal line in terms of character widths from
                        \ the left-hand side of the screen. For comparison this
                        \ is 98 for modes 1 and 2, but needs to be adjusted for
                        \ our custom screen's width

ENDIF

 EQUB 23, 0, 10, 32     \ Set 6845 register R10 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "cursor start" register, which sets the
                        \ cursor start line at 0 with a fast blink rate

IF _6502SP_VERSION

 EQUB 23, 0, &87, 34    \ Set 6845 register R7 = 34
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "vertical sync position" register, which
                        \ defines the row number where the vertical sync pulse
                        \ is fired. This is aleady set to 34 for mode 1 and 2,
                        \ so I'm not sure what this VDU sequence does,
                        \ especially as the register number has bit 7 set (it's
                        \ &87 rather than 7). More investigation needed!

ENDIF

