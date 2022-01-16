default:
	( cd software; acme --color --report report.txt --strict-segments -v -Wtype-mismatch main.a )
	cat software/report.txt

eeprom:
	(cd software; minipro -p AT28C256 -w main.bin)

.PHONY: schematics
schematics:
	pdfseparate -f 1 -l 1 hardware/65C816.pdf schematics/main.pdf
	convert -density 200 schematics/main.pdf schematics/main.png
	pdfseparate -f 2 -l 2 hardware/65C816.pdf schematics/clock.pdf
	convert -density 200 schematics/clock.pdf schematics/clock.png
	pdfseparate -f 3 -l 3 hardware/65C816.pdf schematics/debug.pdf
	convert -density 200 schematics/debug.pdf schematics/debug.png
	pdfseparate -f 4 -l 4 hardware/65C816.pdf schematics/reset.pdf
	convert -density 200 schematics/reset.pdf schematics/reset.png
	pdfseparate -f 5 -l 5 hardware/65C816.pdf schematics/tester.pdf
	convert -density 200 schematics/tester.pdf schematics/tester.png
	pdfseparate -f 6 -l 6 hardware/65C816.pdf schematics/glue.pdf
	convert -density 200 schematics/glue.pdf schematics/glue.png
	pdfseparate -f 7 -l 7 hardware/65C816.pdf schematics/memory.pdf
	convert -density 200 schematics/memory.pdf schematics/memory.png
	pdfseparate -f 8 -l 8 hardware/65C816.pdf schematics/address_decoding.pdf
	convert -density 200 schematics/address_decoding.pdf schematics/address_decoding.png
	rm hardware/65C816.pdf schematics/*.pdf

.PHONY: thumbnails
thumbnails:
	python thumbnails/thumbnail.py
