\ ******************************************************************************
\
\       Name: GetHeadshotType_b4
\       Type: Subroutine
\   Category: Status
\    Summary: Call the GetHeadshotType routine in ROM bank 4
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ******************************************************************************

.GetHeadshotType_b4

 LDA currentBank        \ Fetch the number of the ROM bank that is currently
 PHA                    \ paged into memory at &8000 and store it on the stack

 LDA #4                 \ Page ROM bank 4 into memory at &8000
 JSR SetBank

 JSR GetHeadshotType    \ Call GetHeadshotType, now that it is paged into memory

 JMP ResetBank          \ Fetch the previous ROM bank number from the stack and
                        \ page that bank back into memory at &8000, returning
                        \ from the subroutine using a tail call

