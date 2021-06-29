\ ******************************************************************************
\
\       Name: cargo_mtok
\       Type: Subroutine
\   Category: Text
\    Summary: Print the name of a specific cargo item
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the cargo item whose name we want to print
\                       (where 0 = food, 1 = textiles, and so on up to 16 for
\                       alien items)
\
\                       See QQ23 for a list of market item numbers and their
\                       storage units
\
\ ******************************************************************************

.cargo_mtok

 ADC #208               \ Add 208 to the value in A, so when we fall through
                        \ into MESS, we print recursive token 48 + A as an
                        \ in-flight token, which will be in the range 48
                        \ ("FOOD") to 64 ("ALIEN ITEMS")

