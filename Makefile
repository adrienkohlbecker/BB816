default:
	( cd software; acme --color --report report.txt --strict-segments -v -Wtype-mismatch main.a )
	( cd software; python bin2hex.py main.bin main.hex )
	cat software/report.txt

memtest:
	( cd software; acme --color --report report.txt --strict-segments -v -Wtype-mismatch examples/memtest.a )
	( cd software; python bin2hex.py main.bin main.hex  )
	cat software/report.txt

minipro:
	minipro --presence_check
	( cd software; minipro --device AT28C256 --pin_check --write  main.bin )

eeprom:
	( cd software; ./eeprom.sh )

.PHONY: schematics
schematics:
	pdfseparate -f 1 -l 1 hardware/breakout/breakout.pdf schematics/breakout.pdf
	convert -alpha remove -density 200 schematics/breakout.pdf schematics/breakout.png

	pdfseparate -f 1 -l 1 hardware/65C816.pdf schematics/main.pdf
	convert -alpha remove -density 200 schematics/main.pdf schematics/main.png
	pdfseparate -f 2 -l 2 hardware/65C816.pdf schematics/address_decoding.pdf
	convert -alpha remove -density 200 schematics/address_decoding.pdf schematics/address_decoding.png
	pdfseparate -f 3 -l 3 hardware/65C816.pdf schematics/memory.pdf
	convert -alpha remove -density 200 schematics/memory.pdf schematics/memory.png
	pdfseparate -f 4 -l 4 hardware/65C816.pdf schematics/debug_clock.pdf
	convert -alpha remove -density 200 schematics/debug_clock.pdf schematics/debug_clock.png
	pdfseparate -f 5 -l 5 hardware/65C816.pdf schematics/debug.pdf
	convert -alpha remove -density 200 schematics/debug.pdf schematics/debug.png
	pdfseparate -f 6 -l 6 hardware/65C816.pdf schematics/monitor.pdf
	convert -alpha remove -density 200 schematics/monitor.pdf schematics/monitor.png
	pdfseparate -f 7 -l 7 hardware/65C816.pdf schematics/gpio.pdf
	convert -alpha remove -density 200 schematics/gpio.pdf schematics/gpio.png
	pdfseparate -f 8 -l 8 hardware/65C816.pdf schematics/peripherals.pdf
	convert -alpha remove -density 200 schematics/peripherals.pdf schematics/peripherals.png
	pdfseparate -f 9 -l 9 hardware/65C816.pdf schematics/serial.pdf
	convert -alpha remove -density 200 schematics/serial.pdf schematics/serial.png
	pdfseparate -f 10 -l 10 hardware/65C816.pdf schematics/tester.pdf
	convert -alpha remove -density 200 schematics/tester.pdf schematics/tester.png

	rm schematics/*.pdf

.PHONY: thumbnails
thumbnails:
	python thumbnails/thumbnail.py
