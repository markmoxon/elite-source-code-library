\ ******************************************************************************
\
\       Name: lowerCase
\       Type: Variable
\   Category: Text
\    Summary: Lookup table for converting letters to lower case
\
\ ******************************************************************************

.lowerCase

 FOR I%, 0, 31

  EQUB I%

 NEXT

 EQUS " !$/$%&'()*+,-./0123456789:;%*>?`abcdef"
 EQUS "ghijklmnopqrstuvwxyz{|};+`abcdefghijklm"
 EQUS "nopqrstuvwxyz{|}~"

 EQUB 127

