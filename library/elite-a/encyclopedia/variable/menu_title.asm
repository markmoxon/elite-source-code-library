\ ******************************************************************************
\
\       Name: menu_title
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Table containing text token numbers for each menu's title
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

.menu_title

 EQUB 1                 \ Menu 0: Title is text token 1:
                        \
                        \   "ENCYCLOPEDIA GALACTICA"

 EQUB 2                 \ Menu 1: Title is text token 2:
                        \
                        \   "SHIPS {all caps}A-G{sentence case}"

 EQUB 3                 \ Menu 2: Title is text token 3:
                        \
                        \   "SHIPS {all caps}I-W{sentence case}"

 EQUB 5                 \ Menu 3: Title is text token 5:
                        \
                        \   "CONTROLS"

 EQUB 4                 \ Menu 4: Title is text token 4:
                        \
                        \   "EQUIPMENT"

