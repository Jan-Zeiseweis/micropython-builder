"""Generic ESP32 with 128x160 7735 display"""

from machine import Pin, SPI
import st7789

TFA = 0
BFA = 0

def config(rotation=0, buffer_size=0, options=0):
    return st7789.ST7789(
        SPI(0, baudrate=20000000, polarity=0, phase=0, sck=Pin(18), mosi=Pin(19), miso=Pin(16)),
        128,
        160,
        reset=Pin(6, Pin.OUT),
        cs=Pin(17, Pin.OUT),
        dc=Pin(3, Pin.OUT),
        backlight=Pin(2, Pin.OUT),
        color_order=st7789.RGB,
        inversion=False,
        rotation=rotation,
        options=options,
        buffer_size=buffer_size)
