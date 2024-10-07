#!/usr/bin/env python
#
# ******************************************************************************
#
# COMMODORE 64 ELITE DECRYPTION SCRIPT
#
# Written by Mark Moxon
#
# This script removes encryption and checksums from the compiled binaries for
# the Commodore 64 version of Elite
#
# Files are saved using the decrypt.bin suffix so they don't overwrite any
# existing unprot.bin files, so they can be compared if required
#
# Run this script by changing directory to the repository's root folder and
# running the script with "python 2-build-files/elite-decrypt.py"
#
# You can decrypt specific releases by adding the following arguments, as in
# "python 2-build-files/elite-decrypt.py -rel2" for example:
#
#   -rel1   Decrypt the GMA85 NTSC release
#   -rel2   Decrypt the GMA85 PAL release
#   -rel3   Decrypt the version built by the source disc
#   -rel4   Decrypt the binaries already on the source disc
#
# If unspecified, the default is rel1
#
# ******************************************************************************

from __future__ import print_function
import sys

print()
print("Commodore 64 Elite decryption")

argv = sys.argv
release = 1
folder = "gma85"

for arg in argv[1:]:
    if arg == "-rel1":
        release = 1
        folder = "gma85-ntsc"
    if arg == "-rel2":
        release = 2
        folder = "gma85-pal"
    if arg == "-rel3":
        release = 3
        folder = "source-disc-build"
    if arg == "-rel4":
        release = 4
        folder = "source-disc-files"

# Configuration variables for scrambling code and calculating checksums
#
# Values must match those in 3-assembled-output/compile.txt
#
# If you alter the source code, then you should extract the correct values for
# the following variables and plug them into the following, otherwise the game
# will fail the checksum process and will hang on loading
#
# You can find the correct values for these variables by building your updated
# source, and then searching compile.txt for "elite-checksum.py", where the new
# values will be listed

if release == 1 or release == 2:

    # GMA85
    b = 0x1D00                  # B%
    g = 0x1D81                  # G%
    w = 0x4000                  # W%
    x = 0x7593                  # X%
    u = 0x75E4                  # U%
    v = 0x8660                  # V%
    hicode = "gma6"
    locode = "gma5"
    comlod = "gma4"

elif release == 3 or release == 4:

    # Source disc
    b = 0x1D00                  # B%
    g = 0x1D7E                  # G%
    w = 0x4000                  # W%
    x = 0x7601                  # X%
    u = 0x7655                  # U%
    v = 0x86cc                  # V%
    hicode = "HICODE"
    locode = "LOCODE"
    comlod = "COMLOD"

# Load assembled HICODE/gma6 file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/" + hicode + ".bin", "rb")

data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/" + hicode + ".bin")

# Do decryption

seed = 0x49

if release == 1 or release == 2:
    unscramble_from = 0x62D6 + 2  # len is 0x62E2
    unscramble_to = 2 - 1
else:
    unscramble_from = len(data_block) - 1
    unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/" + hicode + ".bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/" + hicode + ".decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/" + hicode + ".decrypted.bin")

# Load assembled LOCODE/gma5 file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/" + locode + ".bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/" + locode + ".bin")

# Do decryption

seed = 0x36

if release == 1 or release == 2:
    unscramble_from = 0x21D1 + 2  # len is 0x21D7
    unscramble_to = g - b - 1 + 2
else:
    unscramble_from = len(data_block) - 1
    unscramble_to = g - b - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/" + locode + ".bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/" + locode + ".decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/" + locode + ".decrypted.bin")

# Load assembled COMLOD/gma4 file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/" + comlod + ".bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/" + comlod + ".bin")

# Do decryption

seed = 0x8E

if release == 1 or release == 2:
    unscramble_from = 0x465A   # len is 0x4662
    unscramble_to = 0x35E4 - 1 + 2
else:
    unscramble_from = len(data_block) - 1
    unscramble_to = u - w - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

seed = 0x6C

if release == 1 or release == 2:
    unscramble_from = 0x3593 + 2 - 4
    unscramble_to = 2 - 1
else:
    unscramble_from = x - w + 1
    unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/" + comlod + ".bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/" + comlod + ".decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/" + comlod + ".decrypted.bin")
print()
