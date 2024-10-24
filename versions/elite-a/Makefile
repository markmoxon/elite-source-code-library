BEEBASM?=beebasm
PYTHON?=python

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
#
# The following variables are written into elite-build-options.asm depending on
# the above arguments, so they can be passed to BeebAsm:
#
# _VERSION
#   6 = Elite-A
#
# _VARIANT
#   1 = Released version (default)
#   2 = Source disc
#   3 = Bug fix
#
# _MAX_COMMANDER
#   TRUE  = Maxed-out commander
#   FALSE = Standard commander
#
# The verify argument is passed to the crc32.py script, rather than BeebAsm

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

ifeq ($(variant-elite-a), source-disc)
  variant-number_elite-a=2
  folder_elite-a=source-disc
  suffix_elite-a=-from-source-disc
else ifeq ($(variant-elite-a), bug-fix)
  variant-number_elite-a=3
  folder_elite-a=bug-fix
  suffix_elite-a=-bug-fix
else
  variant-number_elite-a=1
  folder_elite-a=released
  suffix_elite-a=-released
endif

.PHONY:elite-a
elite-a:
	echo _VERSION=6 > versions/elite-a/1-source-files/main-sources/elite-build-options.asm
	echo _VARIANT=$(variant-number_elite-a) >> versions/elite-a/1-source-files/main-sources/elite-build-options.asm
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
	$(PYTHON) versions/elite-a/2-build-files/elite-checksum.py $(unencrypt) -rel$(variant-number_elite-a)
	$(BEEBASM) -i versions/elite-a/1-source-files/main-sources/elite-disc.asm -do versions/elite-a/5-compiled-game-discs/elite-a$(suffix_elite-a).ssd -opt 3 -title "E L I T E"
ifneq ($(verify), no)
	@$(PYTHON) versions/elite-a/2-build-files/crc32.py versions/elite-a/4-reference-binaries/$(folder_elite-a) versions/elite-a/3-assembled-output
endif

.PHONY:b2-elite-a
b2-elite-a:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "versions/elite-a/5-compiled-game-discs/elite-a$(suffix_elite-a).ssd" "http://localhost:48075/run/b2?name=elite-a$(suffix_elite-a).ssd"
