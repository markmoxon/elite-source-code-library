.COL

IF _CASSETTE_VERSION OR _DISC_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment

 SKIP 1                 \ Temporary storage, used to store colour information
                        \ when drawing pixels in the dashboard

ELIF _ELECTRON_VERSION

 SKIP 1                 \ This byte is unused in the Electron version, as it
                        \ is used to store colour information when drawing
                        \ pixels in the dashboard, and the Electron's dashboard
                        \ is monochrome

ENDIF

