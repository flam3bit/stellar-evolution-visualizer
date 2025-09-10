class_name StarBase extends Node2D
## Base class for the star node. Constants provided from this [url=https://adsabs.harvard.edu/pdf/2000MNRAS.315..543H]paper[/url]:
## 

## End of the main sequence for stars under 0.7 solar masses.
const END_MAIN_SEQUENCE_UNDER_07 = 0

## Main sequence
const MAIN_SEQUENCE = 1

## Subgiant branch. Hertzsprung gap for more massive stars. 
const SUBGIANT_HERTZSPRUNG = 2

## Red giant branch.
## Less and intermediate-mass stars go through this at the end of main sequence.
const GIANT_BRANCH = 3

## Red clump in less massive stars.
## Red supergiants in stars over 100,000x solar luminosities.
const CORE_HELIUM_BURNING = 4


## Early asymptotic giant branch.
## Less massive stars will go through this at the end of their lives.
const EARLY_AGB = 5

## Thermally pulsing/pulsating asymptotic giant branch. Not visualized constantly expanding/shrinking like in Algol/MrPlasma style timelines.
## Instead it visualizes the transition between the AGB and white dwarf stages.
const TP_AGB = 6

## Wolf-Rayet star and the helium burning phase of low-mass stars.
const HeMS_WR = 7

## Wolf-Rayet star. Massive stars explode as supernovae after this phase.
const HeHG_WR = 8

## Wolf-Rayet star.
const HeGB_WR = 9

## Helium white dwarf. Only possible for low-mass stars.
const He_WD = 10

## Carbon/Oxygen white dwarf. Higher low-mass and lower intermediate-mass stars turn into this. 
const CARBON_OXYGEN_WD = 11

## Oxygen/Neon white dwarf. Intermediate stars turn into this. 
const OXYGEN_Ne_WD = 12

## Neutron star, the remnant of a star that exploded in a supernova whose core did not collapse.
const NEUTRON_STAR = 13

## Black hole. [code]self_modulate[/code] is black and temperature forced at zero.
const BLACK_HOLE = 14

## Massless remnant. If a star has this stage, its visibility is set to [code]false[/code].
const NO_REMNANT = 15
