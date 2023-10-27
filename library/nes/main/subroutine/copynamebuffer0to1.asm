\ ******************************************************************************
\
\       Name: CopyNameBuffer0To1
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Copy the contents of nametable buffer 0 to nametable buffer 1
\
\ ******************************************************************************

.CopyNameBuffer0To1

 LDY #0                 \ Set Y = 0 so we can use it as an index starting at 0,
                        \ and then counting down from 255 to 0

 LDX #16                \ The following loop also updates a counter in X that
                        \ counts down from 16 to 1 and back to 16 again, but it
                        \ isn't used anywhere, so presumably this is left over
                        \ from some functionality that was later removed

.copy1

 LDA nameBuffer0,Y      \ Copy the Y-th byte of nametable buffer 0 to nametable
 STA nameBuffer1,Y      \ buffer 1, so this copies the first 256 bytes as Y
                        \ counts down

 LDA nameBuffer0+256,Y  \ Copy byte 256, and bytes 511 to 255 into nametable
 STA nameBuffer1+256,Y  \ buffer 1 as Y counts down

 LDA nameBuffer0+512,Y  \ Copy byte 512, and bytes 767 to 511 into nametable
 STA nameBuffer1+512,Y  \ buffer 1 as Y counts down

 LDA nameBuffer0+768,Y  \ Copy byte 768, and bytes 1023 to 769 into nametable
 STA nameBuffer1+768,Y  \ buffer 1 as Y counts down

 JSR SetupPPUForIconBar \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 DEX                    \ Decrement the counter in X, wrapping it back up to 16
 BNE copy2              \ when it reaches 0
 LDX #16

.copy2

 DEY                    \ Decrement the index counter in Y

 BNE copy1              \ Loop back to copy1 to copy the next four bytes, until
                        \ we have copied the whole buffer

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries up to the
 STA lastPattern        \ first free pattern, for both bitplanes
 STA lastPattern+1

 RTS                    \ Return from the subroutine

