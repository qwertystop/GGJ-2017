#define gridVolume
///gridVolume(map, xarray, yarray, volumearray)
// Determine volume at point
// based on distance from other points with given volume
// returns array of volumes at all points
// assumes that all points are within the map
// and that xarray, yarray, volumearray are equal size

map = argument0
xarray = argument1
yarray = argument2
volumearray = argument3

// initial volumes
for (i=1; i < array_length_1d(xarray); ++i) {
    xpos = xarray[i]
    ypos = yarray[i]
    vol = volumearray[i]
    if (result[xpos, ypos] < vol) {
        result[xpos, ypos] = vol
    }
    // and spread from there
    soundSpread(result, xpos, ypos, map)
}    

#define soundSpread
///soundSpread(result, xpos, ypos, map)
// Spread based on volume at given point until zero or drowned out
// map used to modify sound spread for walls

result = argument0
xpos = argument1
ypos = argument2
map = argument3

// naive recursive implementation - can fix if stack becomes an issue
vol = result[xpos, ypos]
if (vol > 1) { // can still spread
    // set all four directions
    singleSpread(result, xpos, ypos+1, vol, map)
    singleSpread(result, xpos, ypos-1, vol, map)
    singleSpread(result, xpos+1, ypos, vol, map)
    singleSpread(result, xpos-1, ypos, vol, map)
}

#define singleSpread
///singleSpread(result, xpos, ypos, base_vol, map)
// the most repeated part of soundSpread

vol = argument3 - ds_grid_get(argument1, argument2)

if (argument0[argument1, argument2] < vol) {
        argument0[argument1, argument2] = vol
        // and recur
        soundSpread(argument0, argument1, argument2, argument4)
}
