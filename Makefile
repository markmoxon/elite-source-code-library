BEEBASM?=beebasm
PYTHON?=python

# Global arguments

ifeq ($(commander), max)
  max-commander=TRUE
else
  max-commander=FALSE
endif

ifeq ($(encrypt), no)
  unencrypt=-u
  remove-checksums=TRUE
else
  unencrypt=
  remove-checksums=FALSE
endif

ifeq ($(match), no)
  match-original-binaries=FALSE
else
  match-original-binaries=TRUE
endif

# Cassette version

# A make command with no arguments will build the source disc variant with
# encrypted binaries, checksums enabled, the standard commander and crc32
# verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         source-disc (default)
#                         text-sources
#                         sth
#
#   disc=no             Build a version to load from cassette rather than disc
#
#   protect=no          Disable block-level tape protection code (disc=no only)
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=text-sources commander=max encrypt=no verify=no
#
# will build an unencrypted text sources variant with a maxed-out commander
# and no crc32 verification

ifeq ($(protect), no)
  protect-tape=
  prot=FALSE
else
  protect-tape=-p
  prot=TRUE
endif

ifeq ($(disc), no)
  tape-or-disc=-t
  build-for-disc=FALSE
else
  tape-or-disc=
  build-for-disc=TRUE
  protect-tape=
  prot=FALSE
endif

ifeq ($(variant-cassette), text-sources)
  var-cassette=2
  folder-cassette=/text-sources
  suffix-cassette=-from-text-sources
else ifeq ($(variant-cassette), source-disc)
  var-cassette=1
  folder-cassette=/source-disc
  suffix-cassette=-from-source-disc
else
  var-cassette=3
  suffix-cassette=-sth
  ifeq ($(disc), no)
    folder-cassette=/sth-for-tape
  else
    folder-cassette=/sth
  endif
endif

# 6502 Second Processor version

# A make command with no arguments will build the SNG45 variant with
# encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         sng45 (default)
#                         source-disc
#                         executive
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=source-disc commander=max encrypt=no match=no verify=no
#
# will build an unencrypted source disc variant with a maxed-out commander,
# no workspace noise and no crc32 verification

ifeq ($(variant-6502sp), source-disc)
  var-6502sp=1
  folder-6502sp=/source-disc
  suffix-6502sp=-from-source-disc
  boot-6502sp=-boot ELITE
else ifeq ($(variant-6502sp), executive)
  var-6502sp=3
  folder-6502sp=/executive
  suffix-6502sp=-executive
  boot-6502sp=-boot ELITE
else
  var-6502sp=2
  folder-6502sp=/sng45
  suffix-6502sp=-sng45
  boot-6502sp=-opt 2
endif

# Disc version

# A make command with no arguments will build the Stairway to Hell variant
# with encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         sth (default)
#                         ib-disc
#                         sideways-ram
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=ib-disc commander=max encrypt=no match=no verify=no
#
# will build an unencrypted Ian Bell disc variant with a maxed-out commander,
# no workspace noise and no crc32 verification

ifeq ($(variant-disc), ib-disc)
  var-disc=1
  folder-disc=/ib-disc
  suffix-disc=-ib-disc
  boot-disc=-boot ELITE2
else ifeq ($(variant-disc), sideways-ram)
  var-disc=3
  folder-disc=/sideways-ram
  suffix-disc=-sideways-ram
  boot-disc=-opt 3
else
  var-disc=2
  folder-disc=/sth
  suffix-disc=-sth
  boot-disc=-boot ELITE2
endif

# Master version

# A make command with no arguments will build the SNG47 variant with
# encrypted binaries, checksums enabled, the standard commander and
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         sng47 (default)
#                         compact
#
#   commander=max       Start with a maxed-out commander
#
#   encrypt=no          Disable encryption and checksum routines
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=compact commander=max encrypt=no match=no verify=no
#
# will build an unencrypted Master Compact variant with a maxed-out commander,
# no workspace noise and no crc32 verification

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

# A make command with no arguments will build the Ian Bell Superior Software
# variant with the standard commander and crc32 verification of the game
# binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         ib-superior (default)
#                         ib-acornsoft
#
#   commander=max       Start with a maxed-out commander
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=ib-acornsoft commander=max verify=no
#
# will build the Ian Bell Acornsoft variant with a maxed-out commander and
# no crc32 verification

ifeq ($(variant-electron), ib-acornsoft)
  var-electron=2
  folder-electron=/ib-acornsoft
  suffix-electron=-ib-acornsoft
else
  var-electron=1
  folder-electron=/ib-superior
  suffix-electron=-ib-superior
endif

# Elite-A

# A make command with no arguments will build the released variant with
# the standard commander and crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         released (default)
#                         source-disc
#                         bug-fix
#
#   commander=max       Start with a maxed-out commander
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=bug-fix commander=max verify=no
#
# will build the bug-fix variant with a maxed-out commander and no crc32
# verification

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

# NES version

# A make command with no arguments will build the PAL variant with
# the standard commander and crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         pal (default)
#                         ntsc
#
#   commander=max       Start with a maxed-out commander
#
#   match=no            Do not attempt to match the original game binaries
#                       (i.e. omit workspace noise)
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=ntsc commander=max match=no verify=no
#
# will build an NTSC variant with a maxed-out commander, no workspace noise
# and no crc32 verification

ifeq ($(variant-nes), ntsc)
  var-nes=1
  folder-nes=/ntsc
  suffix-nes=-ntsc
else
  var-nes=2
  folder-nes=/pal
  suffix-nes=-pal
endif

# The following variables are written into elite-build-options.asm so they can be
# passed to BeebAsm:
#
# _REMOVE_CHECKSUMS
#   TRUE  = Disable checksums
#   FALSE = Enable checksums
#
# _MATCH_ORIGINAL_BINARIES (for disc, 6502SP, Master, NES versions only)
#   TRUE  = Match binaries to released version (i.e. fill workspaces with noise)
#   FALSE = Zero-fill workspaces
#
# _MAX_COMMANDER
#   TRUE  = Maxed-out commander
#   FALSE = Standard commander
#
# _VERSION
#   1 = BBC Micro cassette
#   2 = BBC Micro disc
#   3 = BBC Micro with 6502 Second Processor
#   4 = BBC Master
#   5 = Electron
#   6 = Elite-A
#   7 = NES
#
# _VARIANT (for cassette version)
#   1 = Source disc
#   2 = Text sources
#   3 = Stairway to Hell (default)
#
# _VARIANT (for disc version)
#   1 = Ian Bell's game disc
#   2 = Stairway to Hell (default)
#   3 = BBC Micro Sideways RAM version
#
# _VARIANT (for 6502SP version)
#   1 = Source disc
#   2 = SNG45 (default)
#   3 = Executive version
#
# _VARIANT (for Master version)
#   1 = SNG47 (default)
#   2 = Master Compact
#
# _VARIANT (for Electron version)
#   1 = Ian Bell's Superior Software UEF (default)
#   2 = Ian Bell's Acornsoft UEF
#
# _VARIANT (for Elite-A)
#   1 = Released version (default)
#   2 = Source disc
#   3 = Bug fix
#
# _VARIANT (for NES)
#   1 = NTSC (default)
#   2 = PAL

.PHONY:all
all:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _DISC=$(build-for-disc) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _PROT=$(prot) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py $(unencrypt) $(tape-or-disc) $(protect-tape) -rel$(var-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -opt 3 -title "E L I T E"

	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-disc) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-text-tokens.asm -v > versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-missile.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader1.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader2.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader3.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader-sideways-ram.asm -v >> versions/disc/3-assembled-output/compile.txt
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
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd $(boot-disc) -title "E L I T E"

	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd $(boot-6502sp) -title "E L I T E"

	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"

	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"

	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"

	echo _VERSION=7 > versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-nes) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-header.asm -v > versions/nes/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-common.asm -v >> versions/nes/3-assembled-output/compile.txt
	cat versions/nes/3-assembled-output/header.bin versions/nes/3-assembled-output/bank0.bin versions/nes/3-assembled-output/bank1.bin versions/nes/3-assembled-output/bank2.bin versions/nes/3-assembled-output/bank3.bin versions/nes/3-assembled-output/bank4.bin versions/nes/3-assembled-output/bank5.bin versions/nes/3-assembled-output/bank6.bin versions/nes/3-assembled-output/bank7.bin > versions/nes/3-assembled-output/elite.bin
	cp versions/nes/3-assembled-output/elite.bin versions/nes/5-compiled-game-discs/ELITE$(suffix-nes).NES

ifneq ($(verify), no)
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder-cassette) versions/cassette/3-assembled-output
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder-disc) versions/disc/3-assembled-output
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder-6502sp) versions/6502sp/3-assembled-output
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder-master) versions/master/3-assembled-output
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder-electron) versions/electron/3-assembled-output
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder-elite-a) versions/elite-a/3-assembled-output
	@$(PYTHON) versions/nes/2-build-files/crc32.py versions/nes/4-reference-binaries$(folder-nes) versions/nes/3-assembled-output
endif

.PHONY:cassette
cassette:
	echo _VERSION=1 > versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-cassette) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _DISC=$(build-for-disc) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	echo _PROT=$(prot) >> versions/cassette/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-source.asm -v > versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-bcfs.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-loader.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-readme.asm -v >> versions/cassette/3-assembled-output/compile.txt
	$(PYTHON) versions/cassette/2-build-files/elite-checksum.py $(unencrypt) $(tape-or-disc) $(protect-tape) -rel$(var-cassette)
	$(BEEBASM) -i versions/cassette/1-source-files/main-sources/elite-disc.asm -do versions/cassette/5-compiled-game-discs/elite-cassette$(suffix-cassette).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder-cassette) versions/cassette/3-assembled-output

.PHONY:disc
disc:
	echo _VERSION=2 > versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-disc) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/disc/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-text-tokens.asm -v > versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-missile.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader1.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader2.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader3.asm -v >> versions/disc/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-loader-sideways-ram.asm -v >> versions/disc/3-assembled-output/compile.txt
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
	$(PYTHON) versions/disc/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-disc)
	$(BEEBASM) -i versions/disc/1-source-files/main-sources/elite-disc.asm -do versions/disc/5-compiled-game-discs/elite-disc$(suffix-disc).ssd $(boot-disc) -title "E L I T E"
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder-disc) versions/disc/3-assembled-output

.PHONY:6502sp
6502sp:
	echo _VERSION=3 > versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-6502sp) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/6502sp/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-source.asm -v > versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-bcfs.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-z.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader1.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-loader2.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-readme.asm -v >> versions/6502sp/3-assembled-output/compile.txt
	$(PYTHON) versions/6502sp/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-6502sp)
	$(BEEBASM) -i versions/6502sp/1-source-files/main-sources/elite-disc.asm -do versions/6502sp/5-compiled-game-discs/elite-6502sp$(suffix-6502sp).ssd $(boot-6502sp) -title "E L I T E"
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder-6502sp) versions/6502sp/3-assembled-output

.PHONY:master
master:
	echo _VERSION=4 > versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-master) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/master/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-loader.asm -v > versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-source.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-data.asm -v >> versions/master/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-readme.asm -v >> versions/master/3-assembled-output/compile.txt
	$(PYTHON) versions/master/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-master)
	$(BEEBASM) -i versions/master/1-source-files/main-sources/elite-disc.asm $(boot-master) -do versions/master/5-compiled-game-discs/elite-master$(suffix-master).ssd -title "E L I T E"
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder-master) versions/master/3-assembled-output

.PHONY:electron
electron:
	echo _VERSION=5 > versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-electron) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/electron/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-source.asm -v > versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-bcfs.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-loader.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-readme.asm -v >> versions/electron/3-assembled-output/compile.txt
	$(PYTHON) versions/electron/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-electron)
	$(BEEBASM) -i versions/electron/1-source-files/main-sources/elite-disc.asm -do versions/electron/5-compiled-game-discs/elite-electron$(suffix-electron).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder-electron) versions/electron/3-assembled-output

.PHONY:elite-a
elite-a:
	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _REMOVE_CHECKSUMS=$(remove-checksums) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py $(unencrypt) -rel$(var-elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix-elite-a).ssd -opt 3 -title "E L I T E"
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder-elite-a) versions/elite-a/3-assembled-output

.PHONY:nes
nes:
	echo _VERSION=7 > versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(var-nes) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MATCH_ORIGINAL_BINARIES=$(match-original-binaries) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	echo _MAX_COMMANDER=$(max-commander) >> versions/nes/1-source-files/main-sources/elite-build-options.asm
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-header.asm -v > versions/nes/3-assembled-output/compile.txt
	$(BEEBASM) -i versions/nes/1-source-files/main-sources/elite-source-common.asm -v >> versions/nes/3-assembled-output/compile.txt
	cat versions/nes/3-assembled-output/header.bin versions/nes/3-assembled-output/bank0.bin versions/nes/3-assembled-output/bank1.bin versions/nes/3-assembled-output/bank2.bin versions/nes/3-assembled-output/bank3.bin versions/nes/3-assembled-output/bank4.bin versions/nes/3-assembled-output/bank5.bin versions/nes/3-assembled-output/bank6.bin versions/nes/3-assembled-output/bank7.bin > versions/nes/3-assembled-output/elite.bin
	cp versions/nes/3-assembled-output/elite.bin versions/nes/5-compiled-game-discs/ELITE$(suffix-nes).NES
	@$(PYTHON) versions/nes/2-build-files/crc32.py versions/nes/4-reference-binaries$(folder-nes) versions/nes/3-assembled-output
