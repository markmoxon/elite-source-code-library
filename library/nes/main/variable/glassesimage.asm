\ ******************************************************************************
\
\       Name: glassesImage
\       Type: Variable
\   Category: Status
\    Summary: Packed image data for the glasses, earrings and medallion that the
\             commander can wear
\  Deep dive: Displaying two-layer images
\             Image and data compression
\
\ ------------------------------------------------------------------------------
\
\ You can view the tiles that make up the glasses image here:
\
\ https://elite.bbcelite.com/images/source/nes/glassesImage_ppu.png
\
\ and you can see what the commander images look like with glasses, earrings and
\ medallion here:
\
\ https://elite.bbcelite.com/images/source/nes/allCommanderImages.png
\
\ ******************************************************************************

.glassesImage

 EQUB &02, &7F, &7B, &34, &17, &1F, &1F, &0F
 EQUB &03, &32, &0C, &08, &05, &12, &22, &E3
 EQUB &41, &80, &06, &80, &03, &FF, &BF, &7C
 EQUB &FC, &F4, &F8, &03, &C0, &80, &00, &21
 EQUB &08, &00, &31, &02, &23, &07, &32, &05
 EQUB &02, &03, &24, &02, &03, &20, &23, &70
 EQUB &50, &20, &03, &24, &20, &0A, &40, &0F
 EQUB &21, &01, &09, &20, &40, &30, &34, &28
 EQUB &14, &0F, &05, &22, &40, &22, &20, &10
 EQUB &33, &08, &04, &03, &07, &FF, &09, &35
 EQUB &02, &01, &06, &0A, &14, &78, &D0, &22
 EQUB &01, &22, &02, &32, &04, &08, &10, &60
 EQUB &32, &03, &01, &07, &21, &01, &06, &63
 EQUB &D5, &77, &5D, &32, &22, &1C, &02, &DD
 EQUB &22, &36, &32, &3E, &1C, &03, &60, &C0
 EQUB &06, &80, &40, &06, &3F

