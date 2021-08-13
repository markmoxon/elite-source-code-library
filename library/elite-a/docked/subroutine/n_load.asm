\ ******************************************************************************
\
\       Name: n_load
\       Type: Subroutine
\   Category: Buying ships
\    Summary: Load the name and flight characteristics for the current ship type
\  Deep dive: Buying and flying ships in Elite-A
\
\ ******************************************************************************

.n_load

 LDY cmdr_type          \ Set Y to the type of our current ship, which is stored
                        \ in new_type

 LDX new_offsets,Y      \ Set X to the offset, measured from new_ships, for this
                        \ ship's details block, so X now points to the offset of
                        \ the first character of the ship's type in the
                        \ new_ships table, as well as the first byte of flight
                        \ characteristics data in new_details

 LDY #0                 \ We now want to do two things:
                        \
                        \   * Update extended text token 132 in the QQ18 table
                        \     with the name of the ship type, so that printing
                        \     token 132 always shows the current ship type
                        \
                        \   * Copy the flight characteristics of the specified
                        \     ship type from the new_details table to our
                        \     current ship data block, which is stored between
                        \     new_pulse and new_max
                        \
                        \ We can do these two at the same time in one loop, so
                        \ set a counter in Y to count through the above

.n_lname

 CPY #9                 \ If Y >= 9, jump to n_linfo to skip copying the name,
 BCS n_linfo            \ as the ship type contains a maximum of 9 characters or
                        \ tokens, and there are more than 9 bytes of flight
                        \ characteristics data

 LDA new_ships,X        \ Set A to the character/token we want to fetch from
                        \ the new_ships table

 EOR #35                \ Tokens in the new_ships table are stored as token
                        \ numbers that are not EOR'd with 35, but the extended
                        \ text token table at QQ18 expects all tokens to be
                        \ obfuscated, so we add the obfuscation here

 STA new_name,Y         \ Store the obfuscated character/token into extended
                        \ text token 132 at the Y-th character of new_name

.n_linfo

                        \ We now want to copy the flight characteristics data
                        \ for this ship type

 LDA new_details,X      \ Set A to the flight characteristic byte we want to
                        \ fetch from the new_details table

 STA new_pulse,Y        \ And store it in the Y-th byte of the new_pulse block
                        \ to set our current ship accordingly

 INX                    \ Increment the offset so we can fetch the next
                        \ character (for the name) and the next byte (for the
                        \ flight characteristics)

 INY                    \ Increment the loop counter

 CPY #13                \ If Y < 13 then we still have data to copy, so loop
 BNE n_lname            \ back to n_lname until we have copied 9 characters from
                        \ the name and 13 bytes of flight characteristics

 LDA new_max            \ Set the minimum roll/pitch rate in new_min to 255 -
 EOR #%11111110         \ the maximum roll/pitch rate, which we can achieve
 STA new_min            \ by EOR'ing with %11111110

 LDY #11                \ We now work our way through the equipment that takes
                        \ up space in the hold, and reduce the amount of free
                        \ space for each item on the list that is fitted. The
                        \ items that take up space are defined in the count_offs
                        \ table, so set a counter in Y so we can work our way
                        \ through the table, checking each of the items in turn

.count_lasers

 LDX count_offs,Y       \ Set X to the Y-th entry in the count_offs table, which
                        \ contains offsets from LASER for each of the equipment
                        \ items that take up space in the hold

 LDA LASER,X            \ Check whether we have this item fitted, by testing
 BEQ count_sys          \ whether LASER+X is zero, and if it is, then this item
                        \ is not fitted, so skip the following instruction

 DEC new_hold           \ The item at offset X is fitted, so decrement the free
                        \ space in new_hold

.count_sys

 DEY                    \ Decrement the loop counter in Y

 BPL count_lasers       \ Loop back to process the next item of equipment until
                        \ we have checked them all and reduced the free space
                        \ accordingly

 RTS                    \ Return from the subroutine

