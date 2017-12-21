
from numpy import pi, sin, arcsin
import sys

energy = float(sys.argv[1])

hbarc=1973.27053324
def e2l(val):
    return 2*pi*hbarc/val

#twod       = 2*3.1356
twod       = 2*3.13572865
reflection = 'Si(111)'

wavelength = e2l(energy)
angle      = arcsin(wavelength / twod)
angle      = angle*180/pi
print "%.2f eV is %.6f degrees" % (energy, angle)
    