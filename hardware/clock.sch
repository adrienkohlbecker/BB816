EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 3
Title "Clock module"
Date "2021-07-20"
Rev "A"
Comp ""
Comment1 ""
Comment2 "https://github.com/adrienkohlbecker/65C816"
Comment3 "Licensed under CERN-OHL-W v2"
Comment4 "Copyright © 2021 Adrien Kohlbecker"
$EndDescr
$Comp
L power:GND #PWR026
U 1 1 61988E4B
P 850 1700
F 0 "#PWR026" H 850 1450 50  0001 C CNN
F 1 "GND" H 855 1527 50  0000 C CNN
F 2 "" H 850 1700 50  0001 C CNN
F 3 "" H 850 1700 50  0001 C CNN
	1    850  1700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR034
U 1 1 61988E51
P 1350 1850
F 0 "#PWR034" H 1350 1600 50  0001 C CNN
F 1 "GND" H 1355 1677 50  0000 C CNN
F 2 "" H 1350 1850 50  0001 C CNN
F 3 "" H 1350 1850 50  0001 C CNN
	1    1350 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	850  1300 850  1050
Wire Wire Line
	850  1050 1350 1050
Wire Wire Line
	1350 1050 1350 1000
Wire Wire Line
	1350 1050 1350 1150
Connection ~ 1350 1050
Wire Wire Line
	1350 1350 1350 1500
Wire Wire Line
	1450 1500 1350 1500
Connection ~ 1350 1500
Wire Wire Line
	1350 1500 1350 1650
$Comp
L keyboard:SW_Push SW1
U 1 1 61988E45
P 850 1500
F 0 "SW1" V 896 1452 50  0000 R CNN
F 1 "Pulse" V 805 1452 50  0000 R CNN
F 2 "" H 850 1700 50  0001 C CNN
F 3 "" H 850 1700 50  0001 C CNN
	1    850  1500
	0    -1   -1   0   
$EndComp
Wire Wire Line
	750  5700 1200 5700
Wire Wire Line
	1650 5700 1650 6150
Connection ~ 1650 6150
Wire Wire Line
	1650 6150 1650 6700
NoConn ~ 2250 6700
NoConn ~ 2250 6150
NoConn ~ 1350 6150
$Comp
L power:VCC #PWR033
U 1 1 61988E60
P 1350 800
F 0 "#PWR033" H 1350 650 50  0001 C CNN
F 1 "VCC" H 1365 973 50  0000 C CNN
F 2 "" H 1350 800 50  0001 C CNN
F 3 "" H 1350 800 50  0001 C CNN
	1    1350 800 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR039
U 1 1 619C5C3A
P 1200 5700
F 0 "#PWR039" H 1200 5550 50  0001 C CNN
F 1 "VCC" H 1215 5873 50  0000 C CNN
F 2 "" H 1200 5700 50  0001 C CNN
F 3 "" H 1200 5700 50  0001 C CNN
	1    1200 5700
	1    0    0    -1  
$EndComp
Connection ~ 1200 5700
Wire Wire Line
	1200 5700 1650 5700
$Comp
L power:VCC #PWR040
U 1 1 619C64C3
P 3450 6400
F 0 "#PWR040" H 3450 6250 50  0001 C CNN
F 1 "VCC" H 3465 6573 50  0000 C CNN
F 2 "" H 3450 6400 50  0001 C CNN
F 3 "" H 3450 6400 50  0001 C CNN
	1    3450 6400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR041
U 1 1 619C6A95
P 3450 7400
F 0 "#PWR041" H 3450 7150 50  0001 C CNN
F 1 "GND" H 3455 7227 50  0000 C CNN
F 2 "" H 3450 7400 50  0001 C CNN
F 3 "" H 3450 7400 50  0001 C CNN
	1    3450 7400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS74 U11
U 3 1 619C8D73
P 4150 6900
F 0 "U11" H 3950 7250 50  0000 C CNN
F 1 "74HC74" H 4350 7250 50  0000 C CNN
F 2 "" H 4150 6900 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 4150 6900 50  0001 C CNN
	3    4150 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3450 6400 4150 6400
Connection ~ 3450 6400
Wire Wire Line
	4150 6400 4150 6500
Wire Wire Line
	3450 7400 4150 7400
Wire Wire Line
	4150 7400 4150 7300
Connection ~ 3450 7400
$Comp
L 74xx:74LS14 U10
U 7 1 619B316E
P 3450 6900
F 0 "U10" H 3250 7250 50  0000 C CNN
F 1 "74HC14" H 3650 7250 50  0000 C CNN
F 2 "" H 3450 6900 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 3450 6900 50  0001 C CNN
	7    3450 6900
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 6 1 619B2620
P 1950 6700
F 0 "U10" H 1950 7017 50  0000 C CNN
F 1 "74HC14" H 1950 6926 50  0000 C CNN
F 2 "" H 1950 6700 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1950 6700 50  0001 C CNN
	6    1950 6700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 5 1 619B1A71
P 1950 6150
F 0 "U10" H 1950 6467 50  0000 C CNN
F 1 "74HC14" H 1950 6376 50  0000 C CNN
F 2 "" H 1950 6150 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1950 6150 50  0001 C CNN
	5    1950 6150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 4 1 619B03E9
P 1050 6150
F 0 "U10" H 1050 6467 50  0000 C CNN
F 1 "74HC14" H 1050 6376 50  0000 C CNN
F 2 "" H 1050 6150 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1050 6150 50  0001 C CNN
	4    1050 6150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 1 1 61988E2D
P 1750 1500
F 0 "U10" H 1750 1817 50  0000 C CNN
F 1 "74HC14" H 1750 1726 50  0000 C CNN
F 2 "" H 1750 1500 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1750 1500 50  0001 C CNN
	1    1750 1500
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C14
U 1 1 61988E33
P 1350 1750
F 0 "C14" H 1442 1796 50  0000 L CNN
F 1 "2.2u" H 1442 1705 50  0000 L CNN
F 2 "" H 1350 1750 50  0001 C CNN
F 3 "~" H 1350 1750 50  0001 C CNN
	1    1350 1750
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R6
U 1 1 61988E39
P 1350 1250
F 0 "R6" H 1409 1296 50  0000 L CNN
F 1 "10k" H 1409 1205 50  0000 L CNN
F 2 "" H 1350 1250 50  0001 C CNN
F 3 "~" H 1350 1250 50  0001 C CNN
	1    1350 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R5
U 1 1 61988E3F
P 1350 900
F 0 "R5" H 1409 946 50  0000 L CNN
F 1 "2.2k" H 1409 855 50  0000 L CNN
F 2 "" H 1350 900 50  0001 C CNN
F 3 "~" H 1350 900 50  0001 C CNN
	1    1350 900 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR044
U 1 1 618CDAE8
P 850 3300
F 0 "#PWR044" H 850 3050 50  0001 C CNN
F 1 "GND" H 855 3127 50  0000 C CNN
F 2 "" H 850 3300 50  0001 C CNN
F 3 "" H 850 3300 50  0001 C CNN
	1    850  3300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR046
U 1 1 618CDAEE
P 1350 3450
F 0 "#PWR046" H 1350 3200 50  0001 C CNN
F 1 "GND" H 1355 3277 50  0000 C CNN
F 2 "" H 1350 3450 50  0001 C CNN
F 3 "" H 1350 3450 50  0001 C CNN
	1    1350 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	850  2900 850  2650
Wire Wire Line
	850  2650 1350 2650
Wire Wire Line
	1350 2650 1350 2600
Wire Wire Line
	1350 2650 1350 2750
Connection ~ 1350 2650
Wire Wire Line
	1350 2950 1350 3100
Wire Wire Line
	1450 3100 1350 3100
Connection ~ 1350 3100
Wire Wire Line
	1350 3100 1350 3250
$Comp
L keyboard:SW_Push SW2
U 1 1 618CDAFD
P 850 3100
F 0 "SW2" V 896 3052 50  0000 R CNN
F 1 "Mode" V 805 3052 50  0000 R CNN
F 2 "" H 850 3300 50  0001 C CNN
F 3 "" H 850 3300 50  0001 C CNN
	1    850  3100
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR045
U 1 1 618CDB03
P 1350 2400
F 0 "#PWR045" H 1350 2250 50  0001 C CNN
F 1 "VCC" H 1365 2573 50  0000 C CNN
F 2 "" H 1350 2400 50  0001 C CNN
F 3 "" H 1350 2400 50  0001 C CNN
	1    1350 2400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 3 1 618CDB09
P 1750 3100
F 0 "U10" H 1750 3417 50  0000 C CNN
F 1 "74HC14" H 1750 3326 50  0000 C CNN
F 2 "" H 1750 3100 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1750 3100 50  0001 C CNN
	3    1750 3100
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C20
U 1 1 618CDB0F
P 1350 3350
F 0 "C20" H 1442 3396 50  0000 L CNN
F 1 "2.2u" H 1442 3305 50  0000 L CNN
F 2 "" H 1350 3350 50  0001 C CNN
F 3 "~" H 1350 3350 50  0001 C CNN
	1    1350 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R8
U 1 1 618CDB15
P 1350 2850
F 0 "R8" H 1409 2896 50  0000 L CNN
F 1 "10k" H 1409 2805 50  0000 L CNN
F 2 "" H 1350 2850 50  0001 C CNN
F 3 "~" H 1350 2850 50  0001 C CNN
	1    1350 2850
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R7
U 1 1 618CDB1B
P 1350 2500
F 0 "R7" H 1409 2546 50  0000 L CNN
F 1 "2.2k" H 1409 2455 50  0000 L CNN
F 2 "" H 1350 2500 50  0001 C CNN
F 3 "~" H 1350 2500 50  0001 C CNN
	1    1350 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR047
U 1 1 618D1E97
P 850 4850
F 0 "#PWR047" H 850 4600 50  0001 C CNN
F 1 "GND" H 855 4677 50  0000 C CNN
F 2 "" H 850 4850 50  0001 C CNN
F 3 "" H 850 4850 50  0001 C CNN
	1    850  4850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR049
U 1 1 618D1E9D
P 1350 5000
F 0 "#PWR049" H 1350 4750 50  0001 C CNN
F 1 "GND" H 1355 4827 50  0000 C CNN
F 2 "" H 1350 5000 50  0001 C CNN
F 3 "" H 1350 5000 50  0001 C CNN
	1    1350 5000
	1    0    0    -1  
$EndComp
Wire Wire Line
	850  4450 850  4200
Wire Wire Line
	850  4200 1350 4200
Wire Wire Line
	1350 4200 1350 4150
Wire Wire Line
	1350 4200 1350 4300
Connection ~ 1350 4200
Wire Wire Line
	1350 4500 1350 4650
Wire Wire Line
	1450 4650 1350 4650
Connection ~ 1350 4650
Wire Wire Line
	1350 4650 1350 4800
$Comp
L keyboard:SW_Push SW3
U 1 1 618D1EAC
P 850 4650
F 0 "SW3" V 896 4602 50  0000 R CNN
F 1 "Speed" V 805 4602 50  0000 R CNN
F 2 "" H 850 4850 50  0001 C CNN
F 3 "" H 850 4850 50  0001 C CNN
	1    850  4650
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR048
U 1 1 618D1EB2
P 1350 3950
F 0 "#PWR048" H 1350 3800 50  0001 C CNN
F 1 "VCC" H 1365 4123 50  0000 C CNN
F 2 "" H 1350 3950 50  0001 C CNN
F 3 "" H 1350 3950 50  0001 C CNN
	1    1350 3950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS14 U10
U 2 1 618D1EB8
P 1750 4650
F 0 "U10" H 1750 4967 50  0000 C CNN
F 1 "74HC14" H 1750 4876 50  0000 C CNN
F 2 "" H 1750 4650 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc14.pdf" H 1750 4650 50  0001 C CNN
	2    1750 4650
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C21
U 1 1 618D1EBE
P 1350 4900
F 0 "C21" H 1442 4946 50  0000 L CNN
F 1 "2.2u" H 1442 4855 50  0000 L CNN
F 2 "" H 1350 4900 50  0001 C CNN
F 3 "~" H 1350 4900 50  0001 C CNN
	1    1350 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R10
U 1 1 618D1EC4
P 1350 4400
F 0 "R10" H 1409 4446 50  0000 L CNN
F 1 "10k" H 1409 4355 50  0000 L CNN
F 2 "" H 1350 4400 50  0001 C CNN
F 3 "~" H 1350 4400 50  0001 C CNN
	1    1350 4400
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R9
U 1 1 618D1ECA
P 1350 4050
F 0 "R9" H 1409 4096 50  0000 L CNN
F 1 "2.2k" H 1409 4005 50  0000 L CNN
F 2 "" H 1350 4050 50  0001 C CNN
F 3 "~" H 1350 4050 50  0001 C CNN
	1    1350 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	750  5700 750  6150
$Comp
L 74xx:74LS74 U12
U 3 1 61981BA3
P 4850 6900
F 0 "U12" H 4650 7250 50  0000 C CNN
F 1 "74HC74" H 5050 7250 50  0000 C CNN
F 2 "" H 4850 6900 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 4850 6900 50  0001 C CNN
	3    4850 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 6400 4850 6400
Wire Wire Line
	4850 6400 4850 6500
Connection ~ 4150 6400
Wire Wire Line
	4850 7300 4850 7400
Wire Wire Line
	4850 7400 4150 7400
Connection ~ 4150 7400
Text Label 2300 1500 2    50   ~ 0
PULSE
Wire Wire Line
	2300 1500 2050 1500
Text Label 2300 3100 2    50   ~ 0
MODE
Wire Wire Line
	2300 3100 2050 3100
Text Label 2300 4650 2    50   ~ 0
SPEED
Wire Wire Line
	2300 4650 2050 4650
Wire Wire Line
	5750 1850 5850 1850
$Comp
L Switch:SW_DIP_x04 SW4
U 1 1 6190529C
P 3650 1250
F 0 "SW4" H 3650 900 50  0000 C CNN
F 1 "SW_DIP_x04" H 3650 1000 50  0000 C CNN
F 2 "" H 3650 1250 50  0001 C CNN
F 3 "~" H 3650 1250 50  0001 C CNN
	1    3650 1250
	1    0    0    1   
$EndComp
Wire Wire Line
	4450 1950 4750 1950
Wire Wire Line
	4450 2250 4450 1950
Wire Wire Line
	3750 2250 4450 2250
$Comp
L power:GND #PWR059
U 1 1 61A700E6
P 4300 2000
F 0 "#PWR059" H 4300 1750 50  0001 C CNN
F 1 "GND" H 4305 1827 50  0000 C CNN
F 2 "" H 4300 2000 50  0001 C CNN
F 3 "" H 4300 2000 50  0001 C CNN
	1    4300 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 1150 4750 1150
Connection ~ 4300 1150
Wire Wire Line
	4300 1600 4300 1150
Wire Wire Line
	4200 1250 4750 1250
Connection ~ 4200 1250
Wire Wire Line
	4200 1600 4200 1250
Wire Wire Line
	4100 1350 4750 1350
Connection ~ 4100 1350
Wire Wire Line
	4100 1600 4100 1350
Wire Wire Line
	4000 1450 4750 1450
Connection ~ 4000 1450
Wire Wire Line
	4000 1600 4000 1450
Wire Wire Line
	3950 1150 4300 1150
Wire Wire Line
	3950 1250 4200 1250
Wire Wire Line
	3950 1350 4100 1350
Wire Wire Line
	3950 1450 4000 1450
$Comp
L Device:R_Network04 RN7
U 1 1 61A3C7A6
P 4100 1800
F 0 "RN7" H 4450 1750 50  0000 R CNN
F 1 "10k" H 4450 1850 50  0000 R CNN
F 2 "Resistor_THT:R_Array_SIP5" V 4375 1800 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 4100 1800 50  0001 C CNN
	1    4100 1800
	-1   0    0    1   
$EndComp
Connection ~ 3250 1150
Wire Wire Line
	3250 1150 3250 1250
Wire Wire Line
	3250 1100 3250 1150
Wire Wire Line
	3350 1150 3250 1150
Connection ~ 3250 1250
Wire Wire Line
	3250 1250 3250 1350
Wire Wire Line
	3250 1250 3350 1250
Connection ~ 3250 1350
Wire Wire Line
	3250 1350 3250 1450
Wire Wire Line
	3350 1350 3250 1350
$Comp
L power:VCC #PWR058
U 1 1 6197B6C8
P 3250 1100
F 0 "#PWR058" H 3250 950 50  0001 C CNN
F 1 "VCC" H 3265 1273 50  0000 C CNN
F 2 "" H 3250 1100 50  0001 C CNN
F 3 "" H 3250 1100 50  0001 C CNN
	1    3250 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 1450 3350 1450
Wire Wire Line
	4550 2600 4550 1650
Wire Wire Line
	4550 1650 4750 1650
NoConn ~ 5750 1150
NoConn ~ 5750 1250
NoConn ~ 5750 1350
NoConn ~ 5750 1450
NoConn ~ 5750 1650
Wire Wire Line
	4700 2050 4750 2050
Wire Wire Line
	4700 2100 4700 2050
$Comp
L power:GND #PWR061
U 1 1 61935649
P 4700 2100
F 0 "#PWR061" H 4700 1850 50  0001 C CNN
F 1 "GND" H 4705 1927 50  0000 C CNN
F 2 "" H 4700 2100 50  0001 C CNN
F 3 "" H 4700 2100 50  0001 C CNN
	1    4700 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	4700 1850 4700 1800
Wire Wire Line
	4750 1850 4700 1850
$Comp
L power:VCC #PWR060
U 1 1 6192B262
P 4700 1800
F 0 "#PWR060" H 4700 1650 50  0001 C CNN
F 1 "VCC" H 4800 1900 50  0000 C CNN
F 2 "" H 4700 1800 50  0001 C CNN
F 3 "" H 4700 1800 50  0001 C CNN
	1    4700 1800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR063
U 1 1 61926608
P 5250 2350
F 0 "#PWR063" H 5250 2100 50  0001 C CNN
F 1 "GND" H 5255 2177 50  0000 C CNN
F 2 "" H 5250 2350 50  0001 C CNN
F 3 "" H 5250 2350 50  0001 C CNN
	1    5250 2350
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR062
U 1 1 61925F2A
P 5250 850
F 0 "#PWR062" H 5250 700 50  0001 C CNN
F 1 "VCC" H 5265 1023 50  0000 C CNN
F 2 "" H 5250 850 50  0001 C CNN
F 3 "" H 5250 850 50  0001 C CNN
	1    5250 850 
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 2600 4550 2600
Wire Wire Line
	5850 1850 5850 2600
$Comp
L 74xx:74LS193 U14
U 1 1 618E8A39
P 5250 1550
F 0 "U14" H 5000 2100 50  0000 C CNN
F 1 "74HC193" H 5500 2100 50  0000 C CNN
F 2 "" H 5250 1550 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/cd54hc193.pdf" H 5250 1550 50  0001 C CNN
	1    5250 1550
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:CXO_DIP14 X1
U 1 1 6194C461
P 3450 2250
F 0 "X1" H 3200 2500 50  0000 L CNN
F 1 "20MHz" H 3550 2500 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-14" H 3900 1900 50  0001 C CNN
F 3 "https://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 3350 2250 50  0001 C CNN
	1    3450 2250
	1    0    0    -1  
$EndComp
NoConn ~ 3150 2250
$Comp
L power:VCC #PWR031
U 1 1 6194CB6E
P 3450 1950
F 0 "#PWR031" H 3450 1800 50  0001 C CNN
F 1 "VCC" H 3465 2123 50  0000 C CNN
F 2 "" H 3450 1950 50  0001 C CNN
F 3 "" H 3450 1950 50  0001 C CNN
	1    3450 1950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR032
U 1 1 6194D3A8
P 3450 2550
F 0 "#PWR032" H 3450 2300 50  0001 C CNN
F 1 "GND" H 3455 2377 50  0000 C CNN
F 2 "" H 3450 2550 50  0001 C CNN
F 3 "" H 3450 2550 50  0001 C CNN
	1    3450 2550
	1    0    0    -1  
$EndComp
Text Label 6700 750  0    50   ~ 0
CLK
Wire Wire Line
	6700 950  6950 950 
Wire Wire Line
	6700 750  6950 750 
Text Label 6700 750  0    50   ~ 0
CLK
Text Label 6700 950  0    50   ~ 0
~CLK
Text HLabel 6950 950  2    50   Output ~ 0
~CLK
Text HLabel 6950 750  2    50   Output ~ 0
CLK
Connection ~ 6650 6250
Connection ~ 6650 6050
Wire Wire Line
	6650 6250 7050 6250
Wire Wire Line
	7050 6050 6650 6050
$Comp
L Device:CP_Small C?
U 1 1 61A2CB14
P 6650 6150
AR Path="/61A2CB14" Ref="C?"  Part="1" 
AR Path="/6188A63E/61A2CB14" Ref="C3"  Part="1" 
F 0 "C3" H 6768 6196 50  0000 L CNN
F 1 "10u" H 6768 6105 50  0000 L CNN
F 2 "" H 6688 6000 50  0001 C CNN
F 3 "~" H 6650 6150 50  0001 C CNN
	1    6650 6150
	1    0    0    -1  
$EndComp
Connection ~ 8250 6250
Connection ~ 8250 6050
Wire Wire Line
	8650 6050 8250 6050
Connection ~ 8650 6050
Wire Wire Line
	9050 6050 8650 6050
Wire Wire Line
	8650 6250 9050 6250
Connection ~ 8650 6250
Wire Wire Line
	8250 6250 8650 6250
$Comp
L Device:C_Small C23
U 1 1 618F0322
P 9050 6150
F 0 "C23" H 9142 6196 50  0000 L CNN
F 1 "100n" H 9142 6105 50  0000 L CNN
F 2 "" H 9050 6150 50  0001 C CNN
F 3 "~" H 9050 6150 50  0001 C CNN
	1    9050 6150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C22
U 1 1 618F031C
P 8650 6150
F 0 "C22" H 8742 6196 50  0000 L CNN
F 1 "100n" H 8742 6105 50  0000 L CNN
F 2 "" H 8650 6150 50  0001 C CNN
F 3 "~" H 8650 6150 50  0001 C CNN
	1    8650 6150
	1    0    0    -1  
$EndComp
Connection ~ 7050 6250
$Comp
L power:GND #PWR043
U 1 1 619D1757
P 6650 6250
F 0 "#PWR043" H 6650 6000 50  0001 C CNN
F 1 "GND" H 6655 6077 50  0000 C CNN
F 2 "" H 6650 6250 50  0001 C CNN
F 3 "" H 6650 6250 50  0001 C CNN
	1    6650 6250
	1    0    0    -1  
$EndComp
Connection ~ 7050 6050
$Comp
L power:VCC #PWR042
U 1 1 619D11BF
P 6650 6050
F 0 "#PWR042" H 6650 5900 50  0001 C CNN
F 1 "VCC" H 6665 6223 50  0000 C CNN
F 2 "" H 6650 6050 50  0001 C CNN
F 3 "" H 6650 6050 50  0001 C CNN
	1    6650 6050
	1    0    0    -1  
$EndComp
Wire Wire Line
	7850 6050 7450 6050
Connection ~ 7850 6050
Wire Wire Line
	7450 6050 7050 6050
Connection ~ 7450 6050
Wire Wire Line
	8250 6050 7850 6050
Wire Wire Line
	7850 6250 8250 6250
Connection ~ 7850 6250
Wire Wire Line
	7450 6250 7850 6250
Connection ~ 7450 6250
Wire Wire Line
	7050 6250 7450 6250
$Comp
L Device:C_Small C19
U 1 1 619CE052
P 8250 6150
F 0 "C19" H 8342 6196 50  0000 L CNN
F 1 "100n" H 8342 6105 50  0000 L CNN
F 2 "" H 8250 6150 50  0001 C CNN
F 3 "~" H 8250 6150 50  0001 C CNN
	1    8250 6150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C18
U 1 1 619CDC77
P 7850 6150
F 0 "C18" H 7942 6196 50  0000 L CNN
F 1 "100n" H 7942 6105 50  0000 L CNN
F 2 "" H 7850 6150 50  0001 C CNN
F 3 "~" H 7850 6150 50  0001 C CNN
	1    7850 6150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C17
U 1 1 619CD840
P 7450 6150
F 0 "C17" H 7542 6196 50  0000 L CNN
F 1 "100n" H 7542 6105 50  0000 L CNN
F 2 "" H 7450 6150 50  0001 C CNN
F 3 "~" H 7450 6150 50  0001 C CNN
	1    7450 6150
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C16
U 1 1 619C89B2
P 7050 6150
F 0 "C16" H 7142 6196 50  0000 L CNN
F 1 "100n" H 7142 6105 50  0000 L CNN
F 2 "" H 7050 6150 50  0001 C CNN
F 3 "~" H 7050 6150 50  0001 C CNN
	1    7050 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 5400 3550 5400
Text Label 3200 5400 0    50   ~ 0
MODE
Wire Wire Line
	3500 5300 3550 5300
Wire Wire Line
	3500 4850 3500 5300
Wire Wire Line
	4250 4850 3500 4850
Wire Wire Line
	4250 5500 4250 4850
Wire Wire Line
	4150 5500 4250 5500
Wire Wire Line
	3850 5750 3850 5700
Wire Wire Line
	3850 5750 3700 5750
$Comp
L power:VCC #PWR050
U 1 1 618D542A
P 3700 5750
F 0 "#PWR050" H 3700 5600 50  0001 C CNN
F 1 "VCC" H 3600 5850 50  0000 C CNN
F 2 "" H 3700 5750 50  0001 C CNN
F 3 "" H 3700 5750 50  0001 C CNN
	1    3700 5750
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR051
U 1 1 618D482B
P 3850 5100
F 0 "#PWR051" H 3850 4950 50  0001 C CNN
F 1 "VCC" H 3865 5273 50  0000 C CNN
F 2 "" H 3850 5100 50  0001 C CNN
F 3 "" H 3850 5100 50  0001 C CNN
	1    3850 5100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS74 U12
U 1 1 618D3CF2
P 3850 5400
F 0 "U12" H 3650 5650 50  0000 C CNN
F 1 "74HC74" H 4050 5650 50  0000 C CNN
F 2 "" H 3850 5400 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 3850 5400 50  0001 C CNN
	1    3850 5400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR029
U 1 1 6196FD56
P 5350 3450
F 0 "#PWR029" H 5350 3300 50  0001 C CNN
F 1 "VCC" H 5365 3623 50  0000 C CNN
F 2 "" H 5350 3450 50  0001 C CNN
F 3 "" H 5350 3450 50  0001 C CNN
	1    5350 3450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR030
U 1 1 6197015F
P 5350 4250
F 0 "#PWR030" H 5350 4000 50  0001 C CNN
F 1 "GND" H 5355 4077 50  0000 C CNN
F 2 "" H 5350 4250 50  0001 C CNN
F 3 "" H 5350 4250 50  0001 C CNN
	1    5350 4250
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR036
U 1 1 61970523
P 5900 3450
F 0 "#PWR036" H 5900 3300 50  0001 C CNN
F 1 "VCC" H 5915 3623 50  0000 C CNN
F 2 "" H 5900 3450 50  0001 C CNN
F 3 "" H 5900 3450 50  0001 C CNN
	1    5900 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 3650 5900 3650
Wire Wire Line
	5900 3650 5900 3450
Wire Wire Line
	4750 3550 4750 3650
Wire Wire Line
	4750 3650 4900 3650
$Comp
L power:VCC #PWR021
U 1 1 61971A87
P 4750 3350
F 0 "#PWR021" H 4750 3200 50  0001 C CNN
F 1 "VCC" H 4765 3523 50  0000 C CNN
F 2 "" H 4750 3350 50  0001 C CNN
F 3 "" H 4750 3350 50  0001 C CNN
	1    4750 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 4050 4850 4050
Wire Wire Line
	4600 4050 4550 4050
Wire Wire Line
	4400 3900 4400 3650
Wire Wire Line
	4400 3650 4750 3650
Connection ~ 4750 3650
NoConn ~ 4400 4200
$Comp
L power:GND #PWR035
U 1 1 6197534D
P 5850 4300
F 0 "#PWR035" H 5850 4050 50  0001 C CNN
F 1 "GND" H 5855 4127 50  0000 C CNN
F 2 "" H 5850 4300 50  0001 C CNN
F 3 "" H 5850 4300 50  0001 C CNN
	1    5850 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 4050 5850 4050
Wire Wire Line
	5850 4050 5850 4100
Wire Wire Line
	4850 4150 4850 4050
Connection ~ 4850 4050
Wire Wire Line
	4850 4050 4800 4050
$Comp
L power:GND #PWR025
U 1 1 619763D0
P 4850 4350
F 0 "#PWR025" H 4850 4100 50  0001 C CNN
F 1 "GND" H 4855 4177 50  0000 C CNN
F 2 "" H 4850 4350 50  0001 C CNN
F 3 "" H 4850 4350 50  0001 C CNN
	1    4850 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 3850 4850 3850
Wire Wire Line
	4850 3850 4850 4050
$Comp
L Device:C_Small C15
U 1 1 619750B5
P 5850 4200
F 0 "C15" H 5942 4246 50  0000 L CNN
F 1 "10n" H 5942 4155 50  0000 L CNN
F 2 "" H 5850 4200 50  0001 C CNN
F 3 "~" H 5850 4200 50  0001 C CNN
	1    5850 4200
	1    0    0    -1  
$EndComp
$Comp
L AK's_Library:LMC555xN U7
U 1 1 6196ECF1
P 5350 3850
F 0 "U7" H 5100 4200 50  0000 C CNN
F 1 "LMC555xN" H 5600 4200 50  0000 C CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 6050 3450 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/lmc555.pdf" H 6250 3450 50  0001 C CNN
	1    5350 3850
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C13
U 1 1 61975AC9
P 4850 4250
F 0 "C13" H 4942 4296 50  0000 L CNN
F 1 "1u" H 4942 4205 50  0000 L CNN
F 2 "" H 4850 4250 50  0001 C CNN
F 3 "~" H 4850 4250 50  0001 C CNN
	1    4850 4250
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R4
U 1 1 6197129C
P 4750 3450
F 0 "R4" H 4809 3496 50  0000 L CNN
F 1 "1k" H 4809 3405 50  0000 L CNN
F 2 "" H 4750 3450 50  0001 C CNN
F 3 "~" H 4750 3450 50  0001 C CNN
	1    4750 3450
	1    0    0    -1  
$EndComp
$Comp
L Device:R_POT RV1
U 1 1 61973512
P 4400 4050
F 0 "RV1" H 4331 4004 50  0000 R CNN
F 1 "500k" H 4331 4095 50  0000 R CNN
F 2 "" H 4400 4050 50  0001 C CNN
F 3 "~" H 4400 4050 50  0001 C CNN
	1    4400 4050
	1    0    0    1   
$EndComp
$Comp
L Device:R_Small R3
U 1 1 619725EA
P 4700 4050
F 0 "R3" V 4896 4050 50  0000 C CNN
F 1 "220" V 4805 4050 50  0000 C CNN
F 2 "" H 4700 4050 50  0001 C CNN
F 3 "~" H 4700 4050 50  0001 C CNN
	1    4700 4050
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4150 5300 4800 5300
Text Label 4800 5300 2    50   ~ 0
PULSE_~RUN
Wire Wire Line
	5200 5400 5600 5400
Text Label 5200 5400 0    50   ~ 0
SPEED
$Comp
L 74xx:74LS74 U12
U 2 1 618E07EB
P 5900 5400
F 0 "U12" H 5700 5650 50  0000 C CNN
F 1 "74HC74" H 6100 5650 50  0000 C CNN
F 2 "" H 5900 5400 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 5900 5400 50  0001 C CNN
	2    5900 5400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR053
U 1 1 618E07F1
P 5900 5100
F 0 "#PWR053" H 5900 4950 50  0001 C CNN
F 1 "VCC" H 5915 5273 50  0000 C CNN
F 2 "" H 5900 5100 50  0001 C CNN
F 3 "" H 5900 5100 50  0001 C CNN
	1    5900 5100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR052
U 1 1 618E07F7
P 5750 5750
F 0 "#PWR052" H 5750 5600 50  0001 C CNN
F 1 "VCC" H 5650 5850 50  0000 C CNN
F 2 "" H 5750 5750 50  0001 C CNN
F 3 "" H 5750 5750 50  0001 C CNN
	1    5750 5750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 5750 5900 5700
Wire Wire Line
	6300 5500 6300 4850
Wire Wire Line
	6300 4850 5550 4850
Wire Wire Line
	5550 4850 5550 5300
Wire Wire Line
	5550 5300 5600 5300
Wire Wire Line
	5900 5750 5750 5750
Wire Wire Line
	6200 5500 6300 5500
Wire Wire Line
	6200 5300 6800 5300
Text Label 6800 5300 2    50   ~ 0
FAST_~SLOW
NoConn ~ 2250 7150
NoConn ~ 2250 7350
Wire Wire Line
	1950 6950 1650 6950
Connection ~ 1650 6950
Connection ~ 1650 6700
Wire Wire Line
	1650 6700 1650 6950
Wire Wire Line
	1650 7550 1950 7550
Text Label 6100 3850 2    50   ~ 0
SLOW
Wire Wire Line
	5800 3850 6100 3850
Connection ~ 5850 1850
Wire Wire Line
	5850 1850 6150 1850
Text Label 6150 1850 2    50   ~ 0
FAST
$Comp
L power:VCC #PWR037
U 1 1 61917DC1
P 9800 2400
F 0 "#PWR037" H 9800 2250 50  0001 C CNN
F 1 "VCC" H 9700 2500 50  0000 C CNN
F 2 "" H 9800 2400 50  0001 C CNN
F 3 "" H 9800 2400 50  0001 C CNN
	1    9800 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 2350 9950 2400
Wire Wire Line
	9950 2400 9800 2400
$Comp
L power:VCC #PWR038
U 1 1 61917DCB
P 9950 1750
F 0 "#PWR038" H 9950 1600 50  0001 C CNN
F 1 "VCC" H 9965 1923 50  0000 C CNN
F 2 "" H 9950 1750 50  0001 C CNN
F 3 "" H 9950 1750 50  0001 C CNN
	1    9950 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 1950 9650 1950
Wire Wire Line
	9600 1500 9600 1950
Wire Wire Line
	10300 1500 9600 1500
Wire Wire Line
	10300 2150 10300 1500
Wire Wire Line
	10250 2150 10300 2150
$Comp
L 74xx:74LS253 U13
U 1 1 618EC7D4
P 8900 2050
F 0 "U13" H 8650 2900 50  0000 C CNN
F 1 "74HC253" H 9150 2900 50  0000 C CNN
F 2 "" H 8900 2050 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn54hc253.pdf" H 8900 2050 50  0001 C CNN
	1    8900 2050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR056
U 1 1 618EED87
P 8900 1050
F 0 "#PWR056" H 8900 900 50  0001 C CNN
F 1 "VCC" H 8915 1223 50  0000 C CNN
F 2 "" H 8900 1050 50  0001 C CNN
F 3 "" H 8900 1050 50  0001 C CNN
	1    8900 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR057
U 1 1 618EF0AE
P 8900 3150
F 0 "#PWR057" H 8900 2900 50  0001 C CNN
F 1 "GND" H 8905 2977 50  0000 C CNN
F 2 "" H 8900 3150 50  0001 C CNN
F 3 "" H 8900 3150 50  0001 C CNN
	1    8900 3150
	1    0    0    -1  
$EndComp
NoConn ~ 9400 1350
Wire Wire Line
	9400 2050 9650 2050
$Comp
L power:VCC #PWR055
U 1 1 618F5E5C
P 8250 1350
F 0 "#PWR055" H 8250 1200 50  0001 C CNN
F 1 "VCC" H 8150 1450 50  0000 C CNN
F 2 "" H 8250 1350 50  0001 C CNN
F 3 "" H 8250 1350 50  0001 C CNN
	1    8250 1350
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 1350 8350 1350
Wire Wire Line
	8350 1350 8350 1450
Wire Wire Line
	8350 1450 8400 1450
Connection ~ 8350 1350
Wire Wire Line
	8350 1350 8400 1350
Connection ~ 8350 1450
Wire Wire Line
	8350 1450 8350 1550
Wire Wire Line
	8350 1550 8400 1550
Connection ~ 8350 1550
Wire Wire Line
	8350 1550 8350 1650
Wire Wire Line
	8350 1650 8400 1650
Wire Wire Line
	8400 1850 7800 1850
Wire Wire Line
	7800 1850 7800 2550
Wire Wire Line
	7800 2550 8400 2550
$Comp
L power:GND #PWR054
U 1 1 61903268
P 7800 2600
F 0 "#PWR054" H 7800 2350 50  0001 C CNN
F 1 "GND" H 7805 2427 50  0000 C CNN
F 2 "" H 7800 2600 50  0001 C CNN
F 3 "" H 7800 2600 50  0001 C CNN
	1    7800 2600
	1    0    0    -1  
$EndComp
Connection ~ 7800 2550
Wire Wire Line
	7800 2550 7800 2600
Text Label 8150 2050 0    50   ~ 0
SLOW
Text Label 8150 2150 0    50   ~ 0
FAST
Text Label 8150 2250 0    50   ~ 0
PULSE
Text Label 8150 2350 0    50   ~ 0
PULSE
Wire Wire Line
	8150 2050 8400 2050
Wire Wire Line
	8400 2150 8150 2150
Wire Wire Line
	8150 2250 8400 2250
Wire Wire Line
	8400 2350 8150 2350
Text Label 7950 2750 0    50   ~ 0
FAST_~SLOW
Text Label 7950 2850 0    50   ~ 0
PULSE_~RUN
Wire Wire Line
	8400 2750 7950 2750
Wire Wire Line
	7950 2850 8400 2850
Connection ~ 10300 2150
Text Label 10500 2150 2    50   ~ 0
~CLK
Wire Wire Line
	10300 2150 10500 2150
Connection ~ 1650 7150
Wire Wire Line
	1650 7250 1650 7550
Connection ~ 1650 7250
Wire Wire Line
	1650 7150 1650 7250
Wire Wire Line
	1650 6950 1650 7150
Text Label 10500 1950 2    50   ~ 0
CLK
Wire Wire Line
	10250 1950 10500 1950
$Comp
L 74xx:74LS74 U11
U 1 1 619B42FC
P 1950 7250
F 0 "U11" H 1750 7500 50  0000 C CNN
F 1 "74HC74" H 2150 7500 50  0000 C CNN
F 2 "" H 1950 7250 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 1950 7250 50  0001 C CNN
	1    1950 7250
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS74 U11
U 2 1 61917DDB
P 9950 2050
F 0 "U11" H 9750 2300 50  0000 C CNN
F 1 "74HC74" H 10150 2300 50  0000 C CNN
F 2 "" H 9950 2050 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/sn74hc74.pdf" H 9950 2050 50  0001 C CNN
	2    9950 2050
	1    0    0    -1  
$EndComp
$EndSCHEMATC