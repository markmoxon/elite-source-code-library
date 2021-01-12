\ ******************************************************************************
\
\ DISC ELITE DISC IMAGE SCRIPT
\
\ Elite was written by Ian Bell and David Braben and is copyright Acornsoft 1984
\
\ The code on this site is identical to the version released on Ian Bell's
\ personal website at http://www.elitehomepage.org/
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://www.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following SSD disc image:
\
\   * elite-disc.ssd
\
\ This can be loaded into an emulator or a real BBC Micro.
\
\ ******************************************************************************

INCLUDE "versions/disc/sources/elite-header.h.asm"

PUTFILE "versions/disc/extracted/ELITE2.bin", "ELITE2", &2F00, &2F00
PUTFILE "versions/disc/extracted/ELITE3.bin", "ELITE3", &5700, &5700
PUTFILE "versions/disc/extracted/ELITE4.bin", "ELITE4", &1900, &197B

PUTFILE "versions/disc/output/D.CODE.bin", "D.CODE", &11E3, &11E3
PUTFILE "versions/disc/output/T.CODE.bin", "T.CODE", &11E3, &11E3

PUTFILE "versions/disc/extracted/D.MOA.bin", "D.MOA", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOB.bin", "D.MOB", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOC.bin", "D.MOC", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOD.bin", "D.MOD", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOE.bin", "D.MOE", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOF.bin", "D.MOF", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOG.bin", "D.MOG", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOH.bin", "D.MOH", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOI.bin", "D.MOI", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOJ.bin", "D.MOJ", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOK.bin", "D.MOK", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOL.bin", "D.MOL", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOM.bin", "D.MOM", &5600, &5600
PUTFILE "versions/disc/extracted/D.MON.bin", "D.MON", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOO.bin", "D.MOO", &5600, &5600
PUTFILE "versions/disc/extracted/D.MOP.bin", "D.MOP", &5600, &5600
