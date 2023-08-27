.Yx2M1

IF NOT(_NES_VERSION)

 SKIP 1                 \ This is used to store the number of pixel rows in the
                        \ space view minus 1, which is also the y-coordinate of
                        \ the bottom pixel row of the space view (it is set to
                        \ 191 in the RES2 routine)

ELIF _NES_VERSION

 SKIP 1                 \ The height of the drawable part of the screen in
                        \ pixels minus 1, often used when calculating the
                        \ y-coordinate of the bottom pixel row of the space view

ENDIF

