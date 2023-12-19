\ ******************************************************************************
\
\       Name: logoBallImage
\       Type: Variable
\   Category: Start and end
\    Summary: Packed image data for the ball at the bottom of the big Elite logo
\             shown on the Start screen
\  Deep dive: Image and data compression
\
\ ------------------------------------------------------------------------------
\
\ You can view the tiles that make up the big logo ball image here:
\
\ https://www.bbcelite.com/images/source/nes/logoBallImage_ppu.png
\
\ and you can see what the full big logo looks like on-screen here (the ball is
\ at the bottom of the logo):
\
\ https://www.bbcelite.com/images/nes/general/start.png
\
\ ******************************************************************************

.logoBallImage

 EQUB &35, &51, &38, &3F, &11, &0B, &03, &21
 EQUB &0C, &02, &21, &0E, &04, &20, &40, &00
 EQUB &80, &0C, &0D, &13, &3F

