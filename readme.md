# Stellar Evolution Visualizer

### Description
Made in the Godot engine.
<br>Visualize stellar evolution with a MrPlasma/Algol style timeline!
<br>The visualizer pulls out data from the output .csv file made using the Python script/exe file.
<br>Orbits are optional and are mainly used to show scale.
<br>More information about starpasta [here](https://worldbuildingpasta.blogspot.com/2022/11/an-apple-pie-from-scratch-part-ii.html?m=1).

#### Usage
1. After running the exe/python script, the location of the .csv file will be provided.
(The .exe file puts the .csv file in a temp folder, and the python file puts it in whatever folder it's in.)
2. Drag/move/copy the .csv file into the location of the StellarEvolutionVisualizer folder, locations provided
for Windows and Linux in the main menu.
3. (optional) Rename the file to a name of your choice, it's recommended if you want to add orbits.

#### Creating orbits

Example

    NAME: Earth
        SemiMajorAxis:  1.00000011
        Eccentricity:   0.01671022
        Rotation:       2.22342356
        Color:          #4391b7
        Fade:           true

1. Navigate to the "orbits" folder.
2. Create a .txt file, its name should be the same as the star (shouldn't be "[Unnamed Star]") you put in.
3. The format of an individual orbit should be as follows:

Parameters:
- ``SemiMajorAxis:`` The orbit's semi-major axis in AU
- ``Eccentricity:``  The object's eccentricity. Should not be above 1.
- ``Rotation:`` The orbit's rotation rate, an inaccurate representation of [apsidal precession.](https://en.wikipedia.org/wiki/Apsidal_precession)
- ``Color:`` The orbit (and infobox's) color.
  - Additionally, the color can be one of [these](https://raw.githubusercontent.com/godotengine/godot-docs/master/img/color_constants.png) by using its name
- ``Fade:`` (Optional) Can be specified true or false. If enabled, the orbit and infobox will have 50% transparency.
  - An orbit will get this status in-visualizer if its pericenter gets within an area outside the star that is 5% the star's current radius.
4. Save the text file, press R if you're in the main menu. Tick "Enable orbits" and click on the star.

#### Star Config file

Example

    AGE: 4568.1
    ZOOM: 0.01

1. Navigate to the "star_config" folder.
2. Just like the orbits file, the name should be the same as the star's.

Parameters:
- ``AGE:`` Star's age in millions of years.
- ``ZOOM:`` Zoom override.

#### Notes
- Thermal pulses (expanding/shrinking) of the star during the asymptotic giant branch is not visualized.
- Evolutionary stage names may be applied to the wrong stars (e.g. Wolf-Rayet star for a 0.5 mass red dwarf.)
- Orbital expansion may be inaccurate.

#### Credits:
- [Star colors (table 5)](https://arxiv.org/abs/2101.06254)


### Preview (Solar System)
Inner (Mercury, Venus, Earth, Mars)
![The inner solar system](/showcase/D%202025-09-10%20T%2008-30-30.png)

Outer (Jupiter, Saturn, Uranus, Neptune)
![The outer solar system](/showcase/D%202025-09-10%20T%2008-30-33.png)
