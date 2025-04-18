\ ******************************************************************************
\
\       Name: cdump
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Colour RAM colour data for the dashboard
\  Deep dive: Colouring the Commodore 64 bitmap screen
\
\ ------------------------------------------------------------------------------
\
\ The sdump and cdump variables contain screen and colour RAM that sets the
\ default colours for the dashboard.
\
\ ******************************************************************************

.cdump

 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &05, &05, &05, &05
 EQUB &05, &05, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &05, &05
 EQUB &05, &05, &05, &05, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &0F, &0F, &07, &07
 EQUB &07, &07, &0D, &0D, &0D, &0D, &0D, &0D
 EQUB &0D, &03, &03, &03, &03, &03, &0D, &0D
 EQUB &0D, &0D, &0D, &0D, &0D, &0D, &07, &07
 EQUB &07, &07, &05, &05, &00, &00, &00, &00

