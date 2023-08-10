from PIL import Image, ImageDraw, ImageFont
import os

image_width = 1280
image_height = 720
playlist_width = 640
playlist_height = 360

episodes = [
    'Introduction',
    'Bank address latch',
    'Data buffer',
    'Bus Enable',
    'Test rig',
    'RDY part #1',
    'RDY part #2',
    'Timing improvements',
    'Clock module #1',
    'Clock module #2',
    'Power-up Reset',
    'Clock module #3',
    'First run\nBus display',
    'Memory map\nAddress decoding',
    'ROM',
    'RAM',
    'Address decoding\nrework',
    'Troubleshooting\nBus Monitor',
    'VDA, VPA, RD, WR',
    'New CLK phase\nWR timing',
    'Extended RAM',
    'Versatile Interface\nAdapter',
    'LCD screen\nCalling conventions',
    'Clock\nimprovements',
    'CPU breakout\nPart 1',
    'CPU breakout\nPart 2',
    'CPU breakout\nPart 3',
    'CPU breakout\nPart 4',
    'EEPROM\nProgrammer',
    'CPU breakout\nPart 5',
    '6551 UART\nwith USB adapter',
    'ROM programmer\nMem Diagnostics',
    'Spring Cleaning',
    'Exploring\ninterrupts'
]

path = './thumbnails/'
pathfmt = path + '{:d}.{}'

for num, episode in enumerate(episodes, start=0):

    if num < 33:
        continue

    with Image.open(pathfmt.format(num, 'png')) as im:
        img = im.resize((image_width, image_height))

        canvas = ImageDraw.Draw(img)

        font = ImageFont.truetype('Arial Black.ttf', size=250)
        canvas.text((image_width-50,0+50), '{:d}'.format(num), font=font, fill='#FFFFFF', stroke_fill='#000000', stroke_width=5, anchor="rt")

        font = ImageFont.truetype('Arial Black.ttf', size=120)
        canvas.text((image_width/2,image_height-30), "BB816 Computer", font=font, fill='#FFFFFF', stroke_fill='#000000', stroke_width=5, anchor="mb")

        font = ImageFont.truetype('Arial Black.ttf', size=80)
        canvas.multiline_text((0+30,0), episode, font=font, fill='#FFFFFF', stroke_fill='#000000', stroke_width=3)

        print(pathfmt.format(num, 'jpg'))
        img.save(pathfmt.format(num, 'jpg'), quality=80)


with Image.open(pathfmt.format(len(episodes)-1, 'png')) as im:
    img = im.resize((playlist_width, playlist_height))

    canvas = ImageDraw.Draw(img)
    font = ImageFont.truetype('Arial Black.ttf', size=60)
    canvas.text((playlist_width/2,playlist_height-15), "BB816 Computer", font=font, fill='#FFFFFF', stroke_fill='#000000', stroke_width=2, anchor="mb")

    font = ImageFont.truetype('Arial Black.ttf', size=40)
    canvas.multiline_text((0+15,0), 'Playlist', font=font, fill='#FFFFFF', stroke_fill='#000000', stroke_width=1)

    img = img.resize((400, 225))

    print(path + 'playlist.{}'.format('jpg'))
    os.remove(path + 'playlist.{}'.format('jpg'))
    img.save(path + 'playlist.{}'.format('jpg'), quality=80)
