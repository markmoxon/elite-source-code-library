\ ******************************************************************************
\
\       Name: BAD
\       Type: Subroutine
\   Category: Status
\    Summary: Calculate how bad we have been
\
\ ------------------------------------------------------------------------------
\
\ Work out how bad we are from the amount of contraband in our hold. The
\ formula is:
\
\   (slaves + narcotics) * 2 + firearms
\
\ so slaves and narcotics are twice as illegal as firearms. The value in FIST
\ (our legal status) is set to at least this value whenever we launch from a
\ space station, and a FIST of 50 or more gives us fugitive status, so leaving a
\ station carrying 25 tonnes of slaves/narcotics, or 50 tonnes of firearms
\ across multiple trips, is enough to make us a fugitive.
\
\ Returns:
\
\   A                   A value that determines how bad we are from the amount
\                       of contraband in our hold
\
\ ******************************************************************************

.BAD

 LDA QQ20+3             \ Set A to the number of tonnes of slaves in the hold

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 ADC QQ20+6             \ Add the number of tonnes of narcotics in the hold

 ASL A                  \ Double the result and add the number of tonnes of
 ADC QQ20+10            \ firearms in the hold

 RTS                    \ Return from the subroutine

