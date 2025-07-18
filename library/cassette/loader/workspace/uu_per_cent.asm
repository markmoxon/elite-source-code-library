\ ******************************************************************************
\
\       Name: UU%
\       Type: Workspace
\    Address: &0B00
\   Category: Workspaces
\    Summary: Marker for a block that is moved as part of the obfuscation
\
\ ------------------------------------------------------------------------------
\
\ The code from here to the end of the file gets copied to &0B00 (LE%) by part
\ 3. It is called from the end of part 4, via ENTRY2 in part 5 below.
\
\ ******************************************************************************

.UU%

 Q% = P% - LE%

 ORG LE%                \ Set the assembly address to LE%

