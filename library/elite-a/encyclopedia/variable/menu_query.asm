\ ******************************************************************************
\
\       Name: menu_query
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Table containing token numbers for each menu's query prompt
\  Deep dive: The Encyclopedia Galactica
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

.menu_query

 EQUB 6                 \ Menu 0: Query prompt is text token 6:
                        \
                        \   "INFORMATION"

 EQUB 67                \ Menu 1: Query prompt is text token 67:
                        \
                        \   " SHIP"

 EQUB 67                \ Menu 2: Query prompt is text token 67:
                        \
                        \   " SHIP"

 EQUB 5                 \ Menu 3: Query prompt is text token 5:
                        \
                        \   "CONTROLS"

 EQUB 4                 \ Menu 4: Query prompt is text token 4:
                        \
                        \   "EQUIPMENT"

