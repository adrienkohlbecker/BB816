import sys
from intelhex import IntelHex

h = IntelHex()

fin = sys.argv[1]
fout = sys.argv[2]

h.loadbin(fin, 0x8000)
h.tofile(fout, format='hex', byte_count=64)
