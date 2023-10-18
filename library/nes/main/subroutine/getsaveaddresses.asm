\ ******************************************************************************
\
\       Name: GetSaveAddresses
\       Type: Subroutine
\   Category: Save and load
\    Summary: Fetch the addresses of the three saved parts for a specific save
\             slot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the save slot
\
\ ******************************************************************************

.GetSaveAddresses

 ASL A                  \ Set X = A * 2
 TAX                    \
                        \ So we can use X as an index into the saveSlotAddr
                        \ tables, which contain two-byte addresses

 LDA saveSlotAddr1,X    \ Set the following:
 STA SC                 \
 LDA saveSlotAddr2,X    \   SC(1 0) = X-th address from saveSlotAddr1, i.e. the
 STA Q                  \             address of the first saved part for slot X
 LDA saveSlotAddr3,X    \
 STA S                  \   Q(1 0) = X-th address from saveSlotAddr2, i.e. the
 LDA saveSlotAddr1+1,X  \            address of the second saved part for slot X
 STA SC+1               \
 LDA saveSlotAddr2+1,X  \   S(1 0) = X-th address from saveSlotAddr3, i.e. the
 STA Q+1                \            address of the third saved part for slot X
 LDA saveSlotAddr3+1,X
 STA S+1

 RTS                    \ Return from the subroutine

