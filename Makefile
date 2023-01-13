BEEBASM?=beebasm
PYTHON?=python

# Cassette version

# You can set the variant that gets built by adding 'variant=<rel>' to
# the make command, where <rel> is one of:
#
#   source-disc
#   text-sources
#
# So, for example:
#
#   make encrypt verify variant=text-sources
#
# will build the variant from the text sources on Ian Bell's site. If you
# omit the variant parameter, it will build the source disc variant.

ifeq ($(variant-cassette), text-sources)
  var-cassette=2
  folder-cassette=/text-sources
  suffix-cassette=-from-text-sources
else
  var-cassette=1
  folder-cassette=/source-disc
  suffix-cassette=-from-source-disc
endif

# 6502 Second Processor version

# You can set the variant that gets built by adding 'var-6502sp=<rel>' to
# the make command, where <rel> is one of:
#
#   source-disc
#   sng45
#   executive
#
# So, for example:
#
#   make encrypt verify var-6502sp=executive
#
# will build the Executive version. If you omit the var-6502sp parameter,
# it will build the SNG45 variant.

ifeq ($(variant-6502sp), source-disc)
  var-6502sp=1
  folder-6502sp=/source-disc
  suffix-6502sp=-from-source-disc
else ifeq ($(variant-6502sp), executive)
  var-6502sp=3
  folder-6502sp=/executive
  suffix-6502sp=-executive
else
  var-6502sp=2
  folder-6502sp=/sng45
  suffix-6502sp=-sng45
endif

# Disc version

# You can set the variant that gets built by adding 'var-disc=<rel>' to
# the make command, where <rel> is one of:
#
#   ib-disc
#   sth
#
# So, for example:
#
#   make encrypt verify var-disc=ib-disc
#
# will build the variant from the game disc on Ian Bell's site. If you omit
# the var-disc parameter, it will build the Stairway to Hell variant.

ifeq ($(variant-disc), ib-disc)
  var-disc=1
  folder-disc=/ib-disc
  suffix-disc=-ib-disc
else
  var-disc=2
  folder-disc=/sth
  suffix-disc=-sth
endif

# Master version

# You can set the variant that gets built by adding 'var-master=<rel>' to
# the make command, where <rel> is one of:
#
#   sng47
#   compact
#
# So, for example:
#
#   make encrypt verify var-master=compact
#
# will build the Master Compact version. If you omit the var-master
# parameter, it will build the SNG47 version.

ifeq ($(variant-master), compact)
  var-master=2
  folder-master=/compact
  suffix-master=-compact
  boot-master=-opt 2
else
  var-master=1
  folder-master=/sng47
  suffix-master=-sng47
  boot-master=-boot M128Elt
endif

# Electron version

variant-electron=1
folder-electron=/sth
suffix-electron=-sth

# Elite-A

# You can set the variant that gets built by adding 'variant=<rel>' to
# the make command, where <rel> is one of:
#
#   released
#   patched
#   bug-fix
#
# So, for example:
#
#   make encrypt verify variant=patched
#
# will build the patched version. If you omit the variant parameter,
# it will build the released version.

ifeq ($(variant-elite-a), source-disc)
  var-elite-a=2
  folder-elite-a=/source-disc
  suffix-elite-a=-from-source-disc
else ifeq ($(variant-elite-a), bug-fix)
  var-elite-a=3
  folder-elite-a=/bug-fix
  suffix-elite-a=-bug-fix
else
  var-elite-a=1
  folder-elite-a=/released
  suffix-elite-a=-released
endif

# The following variables are written into elite-build-options.asm so they can be
# passed to BeebAsm:
#
# _REMOVE_CHECKSUMS
#   TRUE  = Disable checksums, max commander
#   FALSE = Enable checksums, standard commander
#
# _MATCH_ORIGINAL_BINARIES (for disc, 6502SP, Master versions)
#   TRUE  = Match binaries to released version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# _VERSION
#   1 = BBC Micro cassette
#   2 = BBC Micro disc
#   3 = BBC Micro with 6502 Second Processor
#   4 = BBC Master
#   5 = Electron
#   6 = Elite-A
#
# _VARIANT (for cassette version)
#   1 = Source disc (default)
#
# _VARIANT (for disc version)
#   1 = Ian Bell's game disc
#   2 = Stairway to Hell (default)
#
# _VARIANT (for 6502SP version)
#   1 = Source disc
#   2 = SNG45 (default)
#   3 = Executive version
#
# _VARIANT (for Master version)
#   1 = SNG47 (default)
#
# _VARIANT (for Electron version)
#   1 = Stairway to Hell (default)
#
# _VARIANT (for Elite-A)
#   1 = Released version (default)
#   2 = Source disc
#

.PHONY:build
build:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -u -rel$(var-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"

	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-disc) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=FALSE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -u -rel$(var-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"

	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=FALSE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -u -rel$(var-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"

	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=FALSE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -u -rel$(var-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"

	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=TRUE >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -u -rel$(variant-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"

	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -u -rel$(var-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"

.PHONY:encrypt
encrypt:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -rel$(var-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"

	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-disc) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -rel$(var-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"

	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -rel$(var-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"

	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -rel$(var-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"

	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -rel$(variant-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"

	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -rel$(var-elite-a)
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
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py -rel$(var-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -boot ELTdata -title "E L I T E"
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder-cassette) versions/cassette/3-assembled-output

.PHONY:disc
disc:
	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-disc) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/disc/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py -rel$(var-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd -boot ELITE2 -title "E L I T E"
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder-disc) versions/disc/3-assembled-output

.PHONY:6502sp
6502sp:
	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py -rel$(var-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd -boot ELITE -title "E L I T E"
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder-6502sp) versions/6502sp/3-assembled-output

.PHONY:master
master:
	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py -rel$(var-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder-master) versions/master/3-assembled-output

.PHONY:electron
electron:
	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py -rel$(variant-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder-electron) versions/electron/3-assembled-output

.PHONY:elite-a
elite-a:
	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=FALSE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=TRUE >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py -rel$(var-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder-elite-a) versions/elite-a/3-assembled-output
