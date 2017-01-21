#define fillVolume
///fillVolume(xarray, yarray, volumearray)
// Determine volume at point
// based on distance from other points with given volume
// returns array of volumes at all points
// assumes that all points are within the map
// and that xarray, yarray, volumearray are equal size

var xarray = argument0
var yarray = argument1
var volumearray = argument2
var temparrays

// initial volumes
for (i=0; i < array_length_1d(xarray); ++i) {
    var xpos = xarray[i]
    var ypos = yarray[i]
    var vol = volumearray[i]
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

var xpos = argument0
var ypos = argument1

// naive recursive implementation - can fix if stack becomes an issue
var vol = global.vols[xpos, ypos]
if (vol > 1) { // can still spread
    // set all four directions
    if (ypos > 0) {singleSpread(xpos, ypos-1, vol)}
    if (ypos < global.gridsize - 1) {singleSpread(xpos, ypos+1, vol)}
    if (xpos < global.gridsize - 1) {singleSpread(xpos+1, ypos, vol)}
    if (xpos > 0) {singleSpread(xpos-1, ypos, vol)}
}

#define singleSpread
///singleSpread(xpos, ypos, base_vol)
// the most repeated part of soundSpread

var vol = argument2 - 1 - ds_grid_get(global.map, argument0, argument1)
if (global.vols[argument0, argument1] < vol) { // TODO this leaves problems on multiple sources of sound
        global.vols[argument0, argument1] = vol
        // and recur
        soundSpread(argument0, argument1)
}
