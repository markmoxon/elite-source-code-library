BEEBASM?=beebasm
PYTHON?=python

# Cassette version

# You can set the release that gets built by adding 'release=<rel>' to
# the make command, where <rel> is one of:
#
#   source-disc
#   text-sources
#
# So, for example:
#
#   make encrypt verify release=text-sources
#
# will build the version from the text sources on Ian Bell's site. If you
# omit the release parameter, it will build the source disc version.

ifeq ($(release-cassette), text-sources)
  rel-cassette=2
  folder-cassette=/text-sources
  suffix-cassette=-from-text-sources
else
  rel-cassette=1
  folder-cassette=/source-disc
  suffix-cassette=-from-source-disc
endif

# 6502 Second Processor version

# You can set the release that gets built by adding 'release-6502sp=<rel>' to
# the make command, where <rel> is one of:
#
#   source-disc
#   sng45
#   executive
#
# So, for example:
#
#   make encrypt verify release-6502sp=executive
#
# will build the Executive version. If you omit the release-6502sp parameter,
# it will build the SNG45 version.

ifeq ($(release-6502sp), source-disc)
  rel-6502sp=1
  folder-6502sp=/source-disc
  suffix-6502sp=-from-source-disc
else ifeq ($(release-6502sp), executive)
  rel-6502sp=3
  folder-6502sp=/executive
  suffix-6502sp=-executive
else
  rel-6502sp=2
  folder-6502sp=/sng45
  suffix-6502sp=-sng45
endif

# Disc version

# You can set the release that gets built by adding 'release-disc=<rel>' to
# the make command, where <rel> is one of:
#
#   ib-disc
#   sth
#
# So, for example:
#
#   make encrypt verify release-disc=ib-disc
#
# will build the version from the game disc on Ian Bell's site. If you omit
# the release-disc parameter, it will build the Stairway to Hell version.

ifeq ($(release-disc), ib-disc)
  rel-disc=1
  folder-disc=/ib-disc
  suffix-disc=-ib-disc
else
  rel-disc=2
  folder-disc=/sth
  suffix-disc=-sth
endif

# Master version

# You can set the release that gets built by adding 'release-master=<rel>' to
# the make command, where <rel> is one of:
#
#   sng47
#   compact
#
# So, for example:
#
#   make encrypt verify release-master=compact
#
# will build the Master Compact version. If you omit the release-master
# parameter, it will build the SNG47 version.

ifeq ($(release-master), compact)
  rel-master=2
  folder-master=/compact
  suffix-master=-compact
  boot-master=-opt 2
else
  rel-master=1
  folder-master=/sng47
  suffix-master=-sng47
  boot-master=-boot M128Elt
endif

# Electron version

rel-electron=1
folder-electron=/sth
suffix-electron=-sth

# Elite-A

# You can set the release that gets built by adding 'release=<rel>' to
# the make command, where <rel> is one of:
#
#   released
#   patched
#   bug-fix
#
# So, for example:
#
#   make encrypt verify release=patched
#
# will build the patched version. If you omit the release parameter,
# it will build the released version.

ifeq ($(release-elite-a), source-disc)
  rel-elite-a=2
  folder-elite-a=/source-disc
  suffix-elite-a=-from-source-disc
else ifeq ($(release-elite-a), bug-fix)
  rel-elite-a=3
  folder-elite-a=/bug-fix
  suffix-elite-a=-bug-fix
else
  rel-elite-a=1
  folder-elite-a=/released
  suffix-elite-a=-released
endif

# The following variables are written into elite-header.h.asm so they can be
# passed to BeebAsm:
#
# _REMOVE_CHECKSUMS
#   TRUE  = Disable checksums, max commander
#   FALSE = Enable checksums, standard commander
#
# _MATCH_EXTRACTED_BINARIES (for disc, 6502SP, Master versions)
#   TRUE  = Match binaries to release version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# _VERSION
#   1 = BBC Micro cassette
#   2 = BBC Micro disc
#   3 = BBC Micro with 6502 Second Processor
#	4 = BBC Master
#	5 = Electron
#   6 = Elite-A
#
# _RELEASE (for cassette version)
#   1 = Source disc (default)
#
# _RELEASE (for disc version)
#   1 = Ian Bell's game disc
#   2 = Stairway to Hell version (default)
#
# _RELEASE (for 6502SP version)
#   1 = Source disc
#   2 = SNG45 (default)
#	3 = Executive version
#
# _RELEASE (for Master version)
#   1 = SNG47 (default)
#
# _RELEASE (for Electron version)
#   1 = Stairway to Hell version (default)
#
# _RELEASE (for Elite-A)
#   1 = Released version (default)
#   2 = Source disc
#

.PHONY:build
build:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-cassette) >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -u -rel$(rel-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"

	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-disc) >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-text-tokens.asm -v > versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-missile.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader1.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader2.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader3.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-flight.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-docked.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-a.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-b.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-c.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-d.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-e.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-f.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-g.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-h.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-i.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-j.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-k.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-l.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-m.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-n.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-o.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-p.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-readme.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -u -rel$(rel-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"

	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -u -rel$(rel-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"

	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-master) >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=FALSE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -u -rel$(rel-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"

	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-electron) >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -u -rel$(rel-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"

	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-text-tokens.asm -v > versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-missile.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-docked.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-flight.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-encyclopedia.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-parasite.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-io-processor.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-loader.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-a.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-b.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-c.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-d.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-e.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-f.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-g.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-h.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-i.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-j.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-k.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-l.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-m.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-n.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-o.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-p.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-q.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-r.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-s.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-t.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-u.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-v.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-w.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-readme.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -u -rel$(rel-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"

.PHONY:encrypt
encrypt:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-cassette) >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -rel$(rel-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"

	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-disc) >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-text-tokens.asm -v > versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-missile.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader1.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader2.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader3.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-flight.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-docked.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-a.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-b.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-c.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-d.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-e.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-f.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-g.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-h.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-i.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-j.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-k.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-l.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-m.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-n.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-o.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-p.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-readme.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -rel$(rel-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"

	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -rel$(rel-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"

	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-master) >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -rel$(rel-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"

	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-electron) >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -rel$(rel-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"

	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-text-tokens.asm -v > versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-missile.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-docked.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-flight.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-encyclopedia.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-parasite.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-io-processor.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-loader.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-a.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-b.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-c.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-d.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-e.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-f.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-g.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-h.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-i.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-j.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-k.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-l.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-m.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-n.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-o.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-p.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-q.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-r.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-s.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-t.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-u.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-v.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-w.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-readme.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -rel$(rel-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"

.PHONY:verify
verify:
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder-cassette) versions/cassette/3-assembled-output
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder-disc) versions/disc/3-assembled-output
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder-6502sp) versions/6502sp/3-assembled-output
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder-master) versions/master/3-assembled-output
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder-electron) versions/electron/3-assembled-output
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder-elite-a) versions/elite-a/3-assembled-output

.PHONY:cassette
cassette:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-cassette) >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/cassette/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -rel$(rel-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder-cassette) versions/cassette/3-assembled-output

.PHONY:disc
disc:
	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-disc) >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/disc/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-text-tokens.asm -v > versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-missile.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader1.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader2.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader3.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-flight.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-source-docked.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-a.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-b.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-c.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-d.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-e.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-f.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-g.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-h.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-i.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-j.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-k.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-l.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-m.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-n.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-o.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-ships-p.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-readme.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -rel$(rel-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder-disc) versions/disc/3-assembled-output

.PHONY:6502sp
6502sp:
	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/6502sp/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -rel$(rel-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder-6502sp) versions/6502sp/3-assembled-output

.PHONY:master
master:
	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-master) >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/master/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -rel$(rel-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder-master) versions/master/3-assembled-output

.PHONY:electron
electron:
	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-electron) >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/electron/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -rel$(rel-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder-electron) versions/electron/3-assembled-output

.PHONY:elite-a
elite-a:
	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _RELEASE=$(rel-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	echo _MATCH_EXTRACTED_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-header.h.asm
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-text-tokens.asm -v > versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-missile.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-docked.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-flight.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-source-encyclopedia.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-parasite.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-6502sp-io-processor.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-loader.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-a.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-b.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-c.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-d.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-e.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-f.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-g.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-h.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-i.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-j.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-k.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-l.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-m.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-n.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-o.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-p.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-q.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-r.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-s.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-t.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-u.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-v.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-ships-w.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-readme.asm -v >> versions/elite-a/3-assembled-output/compile.txt
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -rel$(rel-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder-elite-a) versions/elite-a/3-assembled-output
