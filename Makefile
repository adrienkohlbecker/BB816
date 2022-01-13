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
	rm hardware/{65C816,main,clock,debug,reset,tester}.pdf
	imageoptim hardware/{main,clock,debug,reset,tester}.png

thumbnails:
	python thumbnails/thumbnail.py
