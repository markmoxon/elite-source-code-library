\ ******************************************************************************
\
\       Name: TINA
\       Type: Workspace
\    Address: &0B00 to &0BFF
\   Category: Workspaces
\    Summary: The code block for the TINA hook
\  Deep dive: The TINA hook
\
\ ------------------------------------------------------------------------------
\
\ To use the TINA hook, this workspace should start with "TINA" and then be
\ followed by code that executes on the I/O processor before the main game code
\ terminates.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   TINA+4              The code to run if the TINA hook is enabled
\
\ ******************************************************************************

 ORG &0B00

.TINA

 SKIP 256

 PRINT "TINA workspace (I/O processor) from ", ~ZP, "to ", ~P%-1, "inclusive"

