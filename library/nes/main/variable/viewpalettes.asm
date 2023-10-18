\ ******************************************************************************
\
\       Name: viewPalettes
\       Type: Variable
\   Category: Drawing the screen
\    Summary: The palettes to use for the different views
\
\ ******************************************************************************

.viewPalettes

 EQUB &0F, &2C, &0F, &2C    \ Palette 0: Space view, Game Over screen
 EQUB &0F, &28, &00, &1A
 EQUB &0F, &10, &00, &16
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &1C, &22, &28
 EQUB &0F, &16, &28, &27
 EQUB &0F, &15, &20, &25

 EQUB &0F, &38, &38, &38    \ Palette 1: Market Price
 EQUB &0F, &10, &06, &1A
 EQUB &0F, &22, &00, &28
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &10, &15
 EQUB &0F, &10, &0F, &1C
 EQUB &0F, &06, &28, &25
 EQUB &0F, &15, &20, &25

 EQUB &0F, &2C, &0F, &2C    \ Palette 2: Title screen
 EQUB &0F, &28, &00, &1A
 EQUB &0F, &10, &00, &16
 EQUB &0F, &10, &00, &3A
 EQUB &0F, &38, &10, &15
 EQUB &0F, &1C, &10, &28
 EQUB &0F, &06, &10, &27
 EQUB &0F, &00, &10, &25

 EQUB &0F, &2C, &0F, &2C    \ Palette 3: Short-range Chart
 EQUB &0F, &10, &1A, &28
 EQUB &0F, &10, &00, &16
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &1C, &22, &28
 EQUB &0F, &06, &28, &27
 EQUB &0F, &15, &20, &25

 EQUB &0F, &2C, &0F, &2C    \ Palette 4: Long-range Chart
 EQUB &0F, &20, &28, &25
 EQUB &0F, &10, &00, &16
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &1C, &22, &28
 EQUB &0F, &06, &28, &27
 EQUB &0F, &15, &20, &25

 EQUB &0F, &28, &10, &06    \ Palette 5: Equip Ship
 EQUB &0F, &10, &00, &1A
 EQUB &0F, &0C, &1C, &2C
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &0C, &1C, &2C
 EQUB &0F, &18, &28, &38
 EQUB &0F, &25, &35, &25
 EQUB &0F, &15, &20, &25

 EQUB &0F, &2A, &00, &06    \ Palette 6: Data on System
 EQUB &0F, &20, &00, &2A
 EQUB &0F, &10, &00, &20
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &27, &28, &17
 EQUB &0F, &06, &28, &27
 EQUB &0F, &15, &20, &25

 EQUB &0F, &28, &0F, &25    \ Palette 7: Save and load
 EQUB &0F, &10, &06, &1A
 EQUB &0F, &10, &0F, &1A
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &18, &28, &38
 EQUB &0F, &06, &2C, &2C
 EQUB &0F, &15, &20, &25

 EQUB &0F, &1C, &10, &30    \ Palette 8: Inventory, Status Mode
 EQUB &0F, &20, &00, &2A
 EQUB &0F, &2A, &00, &06
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &0F, &10, &30
 EQUB &0F, &17, &27, &37
 EQUB &0F, &0F, &28, &38
 EQUB &0F, &15, &25, &25

 EQUB &0F, &1C, &2C, &3C    \ Palette 9: Start screen
 EQUB &0F, &38, &11, &11
 EQUB &0F, &16, &00, &20
 EQUB &0F, &2B, &00, &25
 EQUB &0F, &10, &1A, &25
 EQUB &0F, &08, &18, &27
 EQUB &0F, &0F, &28, &38
 EQUB &0F, &00, &10, &30

 EQUB &0F, &2C, &0F, &2C    \ Palette 10: Mission briefings
 EQUB &0F, &10, &28, &1A
 EQUB &0F, &10, &00, &16
 EQUB &0F, &10, &00, &1C
 EQUB &0F, &38, &2A, &15
 EQUB &0F, &1C, &22, &28
 EQUB &0F, &06, &28, &27
 EQUB &0F, &15, &20, &25

