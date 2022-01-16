default:
	( cd software; acme --color --report report.txt --strict-segments -v -Wtype-mismatch main.a )
	cat software/report.txt

eeprom:
	(cd software; minipro -p AT28C256 -w main.bin)

schematics:
	pdfseparate -f 1 -l 1 hardware/65C816.pdf hardware/main.pdf
	convert -density 200 hardware/main.pdf hardware/main.png
	pdfseparate -f 2 -l 2 hardware/65C816.pdf hardware/clock.pdf
	convert -density 200 hardware/clock.pdf hardware/clock.png
	pdfseparate -f 3 -l 3 hardware/65C816.pdf hardware/debug.pdf
	convert -density 200 hardware/debug.pdf hardware/debug.png
	pdfseparate -f 4 -l 4 hardware/65C816.pdf hardware/reset.pdf
	convert -density 200 hardware/reset.pdf hardware/reset.png
	pdfseparate -f 5 -l 5 hardware/65C816.pdf hardware/tester.pdf
	convert -density 200 hardware/tester.pdf hardware/tester.png
	pdfseparate -f 6 -l 6 hardware/65C816.pdf hardware/memory.pdf
	convert -density 200 hardware/memory.pdf hardware/memory.png
	pdfseparate -f 7 -l 7 hardware/65C816.pdf hardware/address_decoding.pdf
	convert -density 200 hardware/address_decoding.pdf hardware/address_decoding.png
	rm hardware/{65C816,main,clock,debug,reset,tester,memory,address_decoding}.pdf

.PHONY: thumbnails
thumbnails:
	python thumbnails/thumbnail.py
