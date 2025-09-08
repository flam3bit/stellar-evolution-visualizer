class_name StarBase extends Node2D


## End of the main sequence for stars under 0.7 solar masses.
const END_MAIN_SEQUENCE_UNDER_07 = 0

## Main sequence
const MAIN_SEQUENCE = 1

## Subgiant branch. Hertzsprung gap for more massive stars. 
const SUBGIANT_HERTZSPRUNG = 2

## Red giant branch.
const GIANT_BRANCH = 3

## Red clump in less massive stars.
const CORE_HELIUM_BURNING = 4

## Early asymptotic giant branch
const EARLY_AGB = 5

## Thermally pulsing AGB. Not visualized constantly expanding/shrinking like in Algol/MrPlasma style timelines.
## Instead it visualizes the transition between the AGB and white dwarf stages.
const TP_AGB = 6

## Wolf-Rayet star.
const HeMS_WR = 7

## Wolf-Rayet star.
const HeHG_WR = 8

## Wolf-Rayet star.
const HeGB_WR = 9

## Helium white dwarf, only possible for red dwarf stars that even die
const He_WD = 10

## The Sun will turn into this type of white dwarf.
const CARBON_OXYGEN_WD = 11

## More massive stars will turn into this type of white dwarf.
const OXYGEN_Ne_WD = 12

## Neutron star
const NEUTRON_STAR = 13

## Black hole (self modulate is black)
const BLACK_HOLE = 14

## No remnant (visibility turned off)
const NO_REMNANT = 15
