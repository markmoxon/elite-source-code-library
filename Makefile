BEEBASM?=beebasm
PYTHON?=python

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
all: cassette disc 6502sp master electron elite-a nes
ifneq ($(verify), no)
	@$(PYTHON) versions/cassette/2-build-files/crc32.py versions/cassette/4-reference-binaries$(folder_cassette) versions/cassette/3-assembled-output
	@$(PYTHON) versions/disc/2-build-files/crc32.py versions/disc/4-reference-binaries$(folder_disc) versions/disc/3-assembled-output
	@$(PYTHON) versions/6502sp/2-build-files/crc32.py versions/6502sp/4-reference-binaries$(folder_6502sp) versions/6502sp/3-assembled-output
	@$(PYTHON) versions/master/2-build-files/crc32.py versions/master/4-reference-binaries$(folder_master) versions/master/3-assembled-output
	@$(PYTHON) versions/electron/2-build-files/crc32.py versions/electron/4-reference-binaries$(folder_electron) versions/electron/3-assembled-output
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries$(folder_elite-a) versions/elite-a/3-assembled-output
	@$(PYTHON) versions/nes/2-build-files/crc32.py versions/nes/4-reference-binaries$(folder_nes) versions/nes/3-assembled-output
endif

include versions/cassette/Makefile
include versions/disc/Makefile
include versions/6502sp/Makefile
include versions/master/Makefile
include versions/electron/Makefile
include versions/elite-a/Makefile
include versions/nes/Makefile
