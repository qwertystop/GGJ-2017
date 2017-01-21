#define fillVolume
///fillVolume(xarray, yarray, volumearray)
// Determine volume at point
// based on distance from other points with given volume
// returns array of volumes at all points
// assumes that all points are within the map
// and that xarray, yarray, volumearray are equal size

xarray = argument0
yarray = argument1
volumearray = argument2

// initial volumes
for (i=0; i < array_length_1d(xarray); ++i) {
    xpos = xarray[i]
    ypos = yarray[i]
    vol = volumearray[i]
    if (global.vols[xpos, ypos] < vol) {
        global.vols[xpos, ypos] = vol
        // and spread from there
        soundSpread(xpos, ypos)
    }
}

#define soundSpread
///soundSpread(xpos, ypos)
// Spread based on volume at given point until zero or drowned out
// map used to modify sound spread for walls

xpos = argument0
ypos = argument1

// naive recursive implementation - can fix if stack becomes an issue
vol = global.vols[xpos, ypos]
if (vol > 1) { // can still spread
    // set all four directions
    if (ypos > 0) singleSpread(xpos, ypos-1, vol)
    if (ypos < global.gridsize) singleSpread(xpos, ypos+1, vol)
    if (xpos < global.gridsize) singleSpread(xpos+1, ypos, vol)
    if (xpos > 0) singleSpread(xpos-1, ypos, vol)
}

#define singleSpread
///singleSpread(xpos, ypos, base_vol)
// the most repeated part of soundSpread

vol = argument2 - 1 - ds_grid_get(global.map, argument0, argument1)
if (global.vols[argument0, argument1] == 0 && vol > 0) { // TODO this leaves problems on multiple sources of sound
        global.vols[argument0, argument1] = vol
        // and recur
        soundSpread(argument0, argument1)
}
