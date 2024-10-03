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
#   -rel1   Decrypt the GMA85 release
#   -rel2   Decrypt the version from the source disc
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
        folder = "gma85"
    if arg == "-rel2":
        release = 2
        folder = "source-disc-build"
    if arg == "-rel3":
        release = 3
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

if release == 2 or release == 3:

    # Source disc
    b = 0x1D00                  # B%
    g = 0x1D7E                  # G%
    u = 0x7655                  # U%
    v = 0x86cc                  # V%
    w = 0x4000                  # W%
    x = 0x7601                  # X%

# Load assembled HICODE file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/HICODE.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/HICODE.bin")

# Do decryption

seed = 0x49
unscramble_from = len(data_block) - 1
unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/HICODE.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/HICODE.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/HICODE.decrypted.bin")

# Load assembled LOCODE file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/LOCODE.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/LOCODE.bin")

# Do decryption

seed = 0x36
unscramble_from = len(data_block) - 1
unscramble_to = g - b - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

print("[ Decrypt ] 4-reference-binaries/" + folder + "/LOCODE.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/LOCODE.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/LOCODE.decrypted.bin")

# Load assembled COMLOD file

data_block = bytearray()

elite_file = open("4-reference-binaries/" + folder + "/COMLOD.bin", "rb")
data_block.extend(elite_file.read())
elite_file.close()

print()
print("[ Read    ] 4-reference-binaries/" + folder + "/COMLOD.bin")

# Do decryption

seed = 0x8E
unscramble_from = len(data_block) - 1
unscramble_to = u - w - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new

seed = 0x6C
unscramble_from = x - w - 1
unscramble_to = 0 - 1

updated_seed = seed

for n in range(unscramble_from, unscramble_to, -1):
    new = (data_block[n] - updated_seed) % 256
    data_block[n] = new
    updated_seed = new


print("[ Decrypt ] 4-reference-binaries/" + folder + "/COMLOD.bin")

# Save decrypted file

output_file = open("4-reference-binaries/" + folder + "/COMLOD.decrypted.bin", "wb")
output_file.write(data_block)
output_file.close()

print("[ Save    ] 4-reference-binaries/" + folder + "/COMLOD.decrypted.bin")
print()
