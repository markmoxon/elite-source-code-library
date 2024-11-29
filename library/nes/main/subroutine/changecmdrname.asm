\ ******************************************************************************
\
\       Name: ChangeCmdrName
\       Type: Subroutine
\   Category: Save and load
\    Summary: Process changing the commander name
\
\ ******************************************************************************

.ChangeCmdrName

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 INC YC                 \ Move the text cursor to row 22

 LDA #8                 \ Print extended token 8 ("{single cap}NEW NAME: ")
 JSR DETOK_b2

 LDY #6                 \ We start by copying the current commander's name from
                        \ NAME to the buffer at INWK+5, which is where the
                        \ InputName routine expects to find the current name to
                        \ edit, so set a counter in Y for seven characters

 STY inputNameSize      \ Set inputNameSize = 6 so we fetch a name with a
                        \ maximum size of 7 characters in the call to InputName
                        \ below

.cnme1

 LDA NAME,Y             \ Copy the Y-th character from NAME to the Y-th
 STA INWK+5,Y           \ character of the buffer at INWK+5

 DEY                    \ Decrement the loop counter

 BPL cnme1              \ Loop back until we have copied all seven characters
                        \ of the name

 JSR InputName          \ Get a new commander name from the controller into
                        \ INWK+5, where the name will be terminated by ASCII 13

 LDA INWK+5             \ If the first character of the entered name is ASCII 13
 CMP #13                \ then no name was entered, so jump to cnme5 to return
 BEQ cnme5              \ from the subroutine

 LDY #0                 \ Otherwise we now calculate the length of the entered
                        \ name by working along the entered string until we find
                        \ the ASCII 13 character, so set a length counter in Y
                        \ to store the name length as we loop through the name

.cnme2

 LDA INWK+5,Y           \ If the Y-th character of the name is ASCII 13 then we
 CMP #13                \ have found the end of the name, so jump to cnme6 to
 BEQ cnme6              \ pad out the rest of the name with spaces before
                        \ returning to cnme3 below

 INY                    \ Otherwise increment the counter in Y to move along by
                        \ one character

 CPY #7                 \ If Y <> 7 then we haven't gone past the seventh
 BNE cnme2              \ character yet (the commander name has a maximum length
                        \ of 7), so loop back to check the next character

 DEY                    \ Otherwise Y = 7 and we just went past the end of the
                        \ name, so decrement Y to a value of 6 so we can use it
                        \ as a counter in the following loop

                        \ We now copy the name that was entered into the current
                        \ commander file at NAME, to change the commander name

.cnme3

 LDA INWK+5,Y           \ Copy the Y-th character from INWK+5 to the Y-th
 STA NAME,Y             \ character of NAME

 DEY                    \ Decrement the loop counter

 BPL cnme3              \ Loop back until we have copied all seven characters
                        \ of the name (leaving Y with a value of -1)

                        \ We now check whether the entered name matches the
                        \ cheat commander name for the chosen language, and if
                        \ it does, we apply cheat mode

 LDA COK                \ If bit 7 of COK is set, then cheat mode has already
 BMI cnme5              \ been applied, so jump to cnme5

 INY                    \ Set Y = 0 so we can loop through the entered name,
                        \ checking each character against the cheat name

 LDX languageIndex      \ Set X to the index of the chosen language, so this is
                        \ the index of the first character of the cheat name for
                        \ the chosen language, as the table at cheatCmdrName
                        \ interleaves the characters from each of the four
                        \ languages so that the cheat name for language X starts
                        \ at cheatCmdrName + X, with each character being four
                        \ bytes on from the previous one
                        \
                        \ Presumably this is an attempt to hide the cheat names
                        \ from anyone casually browsing through the game binary

.cnme4

 LDA NAME,Y             \ Set A to the Y-th character of the new commander name

 CMP cheatCmdrName,X    \ If the character in A does not match the X-th
 BNE cnme5              \ character of the cheat name for the chosen language,
                        \ jump to cnme5 to skip applying cheat mode

 INX                    \ Set X = X + 4
 INX                    \
 INX                    \ So X now points to the next character of the cheat
 INX                    \ name for the chosen language

 INY                    \ Increment Y to move on to the next character in the
                        \ name

 CPY #7                 \ Loop back to check the next character until we have
 BNE cnme4              \ checked all seven characters

                        \ If we get here then the new commander name matches the
                        \ cheat name for the chosen language (so if this is
                        \ English, then the new name is "CHEATER", for example),
                        \ so now we apply cheat mode

 LDA #%10000000         \ Set bit 7 of COK to record that cheat mode has been
 STA COK                \ applied to this commander, so we can't apply it again,
                        \ and we can't change our commander name either (so once
                        \ you cheat, you have to own it)

 LDA #&A0               \ Set CASH(0 1 2 3) = CASH(0 1 2 3) + &000186A0
 CLC                    \
 ADC CASH+3             \ So this adds 100000 to our cash reserves, giving us
 STA CASH+3             \ an extra 10,000.0 credits
 LDA #&86
 ADC CASH+2
 STA CASH+2
 LDA CASH+1
 ADC #1
 STA CASH+1
 LDA CASH
 ADC #0
 STA CASH

.cnme5

 JSR CLYNS              \ Clear the bottom two text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 JMP DrawMessageInNMI   \ Configure the NMI to update the in-flight message part
                        \ of the screen (which is the same as the part that the
                        \ call to CLYNS just cleared), returning from the
                        \ subroutine using a tail call

.cnme6

                        \ If we get here then the entered name does not use all
                        \ seven characters, so we pad the name out with spaces
                        \
                        \ We get here with Y set to the index of the ASCII 13
                        \ string terminator, so we can simply fill from that
                        \ position to the end of the string

 LDA #' '               \ Set the Y-th character of the name at INWK+5 to a
 STA INWK+5,Y           \ space

 CPY #6                 \ If Y = 6 then we have reached the end of the string,
 BEQ cnme3              \ so jump to cnme3 with Y = 6 to continue processing the
                        \ new name

 INY                    \ Increment Y to point to the next character along

 BNE cnme6              \ Jump back to cnme6 to keep filling the name with
                        \ spaces (this BNE is effectively a JMP as Y is never
                        \ zero)

