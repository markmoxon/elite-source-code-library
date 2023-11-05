\ ******************************************************************************
\
\       Name: fadeColours
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Lookup table that converts a NES colour to the same colour but
\             with a smaller brightness value
\  Deep dive: Views and view types in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Colours on the NES are stored as hue and value, using an HSV model but without
\ the saturation. Specifically the hue (i.e. blue, red etc.) is stored in the
\ low nibble, while the value (i.e. the brightness) is stored in bits 4 and 5
\ of the high nibble. Bits 6 and 7 are unused and are always zero.
\
\ This means that given a colour value in hexadecimal, it is in the form &vh
\ where v is the value (brightness) and h is the hue. We can therefore alter the
\ brightness of a colour by increasing or decreasing the high nibble between
\ 0 and 3, with &0h being the darkest and &3h being the brightest.
\
\ The NES only supports 54 of the 64 possible colours in this scheme, with
\ colours &vE and &vF all being black, as well as &0D. The convention is to use
\ &0F for all these variants of black.
\
\ Given a colour &vh, the table entry at fadeColours + &vh contains the same
\ colour but with a reduced brightness in &v. Specifically, it returns the
\ colour with a brightness of &v - 1. We can therefore use this table to fade a
\ colour to black, which will take up to four steps depending on the brightness
\ of the starting colour. See the FadeColours routine for an example.
\
\ ******************************************************************************

.fadeColours

 EQUB &0F, &0F, &0F, &0F    \ Fade colours with value &0v to black (&0F)
 EQUB &0F, &0F, &0F, &0F
 EQUB &0F, &0F, &0F, &0F
 EQUB &0F, &0F, &0F, &0F

 EQUB &00, &01, &02, &03    \ Fade colours with value &1v to &0v
 EQUB &04, &05, &06, &07
 EQUB &08, &09, &0A, &0B
 EQUB &0C, &0F, &0F, &0F

 EQUB &10, &11, &12, &13    \ Fade colours with value &2v to &1v
 EQUB &14, &15, &16, &17
 EQUB &18, &19, &1A, &1B
 EQUB &1C, &0F, &0F, &0F

 EQUB &20, &21, &22, &23    \ Fade colours with value &3v to &2v
 EQUB &24, &25, &26, &27
 EQUB &28, &29, &2A, &2B
 EQUB &2C, &0F, &0F, &0F

