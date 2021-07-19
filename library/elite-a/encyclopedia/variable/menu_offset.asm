\ ******************************************************************************
\
\       Name: menu_offset
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Table containing token numbers for the first item in each menu
\
\ ------------------------------------------------------------------------------
\
\ Text tokens for the menu system can be found in the msg_3 table.
\
\ The menus are as follows:
\
\   0 = Encyclopedia Galactica
\   1 = Ships A-G
\   2 = Ships I-W
\   3 = Controls
\   4 = Equipment
\
\ ******************************************************************************

.menu_offset

 EQUB 2                 \ Menu 0: First item is text token 2:
                        \
                        \   "SHIPS {all caps}A-G{sentence case}"

 EQUB 7                 \ Menu 1: First item is text token 7:
                        \
                        \   "ADDER"

 EQUB 21                \ Menu 2: First item is text token 21:
                        \
                        \   "KRAIT"

 EQUB 91                \ Menu 3: First item is text token 91:
                        \
                        \   "FLIGHT"

 EQUB 95                \ Menu 4: First item is text token 95:
                        \
                        \   "{standard tokens, sentence case}
                        \    MISSILE{extended tokens}"

