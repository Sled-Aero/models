use <canard_wing2e.scad>

$fs=0.1;
$fa=6;
$fn=200;


//2810_motor();

//translate([0,0,24]) {
//    axle_mount();
//}

difference() {

    union() {
//        translate([0,0,80]) cylinder(60, r=20);

        translate([0, 0, 24]) axle_mount();

        landing_foot();

    }

//    translate([0,0,70]) cylinder(100, r=20);
}
