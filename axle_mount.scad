use <canard_wing2e.scad>

$fs=0.1;
$fa=6;
$fn=200;


2810_motor();
translate([0,0,24]) {
    axle_mount();
}
