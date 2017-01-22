#define fillVolume
///fillVolume(xstack, ystack, volumestack)
// Determine volume at point
// based on distance from other points with given volume
// returns array of volumes at all points
// assumes that all points are within the map
// and that xstack, ystack, volumestack are equal size

var to_check_x = argument0;
var to_check_y = argument1;
var to_check_vol = argument2;
target = false; // just to clean it out... still having confusion w/ scoping in this engine

// initial volumes
for (var p=0; p<global.gridsize; ++p) {
    for (var q=0; q<global.gridsize; ++q) {
        target[p, q] = 0;
    }
}
// and spread from there
soundSpread(target, to_check_x, to_check_y, to_check_vol)
return target

#define soundSpread
///soundSpread(target, to_check_x, to_check_y, to_check_vol)
// Spread based on volume at given point until zero or drowned out
// map used to modify sound spread for walls

target = argument0
var to_check_x = argument1
var to_check_y = argument2
var to_check_vol = argument3

// looping implementation
while (!ds_stack_empty(to_check_x)) {
    // use the top one from the stack
    var xpos = ds_stack_pop(to_check_x);
    var ypos = ds_stack_pop(to_check_y);
    var vol = ds_stack_pop(to_check_vol);
    if (ypos >= 0 and ypos < global.gridsize
            and xpos >= 0 and xpos < global.gridsize) {
        vol -= ds_grid_get(global.map, xpos, ypos);
        if (target[xpos, ypos] < vol) {
            target[xpos, ypos] = vol
        }
    }
    // spread if it's not done
    if (vol > 1) {
        if (ypos > 0) {
            ds_stack_push(to_check_x, xpos)
            ds_stack_push(to_check_y, ypos - 1)
            ds_stack_push(to_check_vol, vol - 1)
        }
        if (ypos < global.gridsize - 1) {
            ds_stack_push(to_check_x, xpos)
            ds_stack_push(to_check_y, ypos + 1)
            ds_stack_push(to_check_vol, vol - 1)
        }
        if (xpos < global.gridsize - 1) {
            ds_stack_push(to_check_x, xpos + 1)
            ds_stack_push(to_check_y, ypos)
            ds_stack_push(to_check_vol, vol - 1)
        }
        if (xpos > 0) {
            ds_stack_push(to_check_x, xpos - 1)
            ds_stack_push(to_check_y, ypos)
            ds_stack_push(to_check_vol, vol - 1)
        }
    }
}
