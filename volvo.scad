//use <lib/dotSCAD/src/path_extrude.scad>

use <lib/Naca4.scad>

include <lib/BOSL2/std.scad>
include <lib/BOSL2/skin.scad>
include <lib/BOSL2/rounding.scad>

$fs=0.01;
$fa=3;
$fn=150;

top = [[-22.5,0],[-15,35],[15,35],[22.5,0]];
base = [[-22.5,0],[-23,22.5],[23,22.5],[22.5,0]];


module volvo_section() {
  scale([2,2,4])
    translate([0,5,0])
      union() {
      polygon(smooth_path(top, size=3, closed=true, splinesteps=100));
      translate([0,-5,0])
        polygon(smooth_path(base, size=3, closed=true, splinesteps=100));
      }
}

module drop_slice() {
  rotate([180,0,90])
    difference() {
      polygon(points = airfoil_data(30, N=300));
      translate([0,-50,0])
        square([100,50]); 
    }
}


module volvo(h) {
  linear_extrude(height = h, center = true, convexity = 10, twist = 0)
    volvo_section();
}

module drop(w,h,l) {
  scale([w,h,l]) 
    rotate_extrude(angle = 360, $fn=300)
      drop_slice();
}

volvo();  

//
//drop(5,5,4.5);

//intersection() {
////  translate([15,0,0])
////    rotate([0,90,0])
////      drop(5,3.5,4);
//    
//   //wing(250,110);
//  
//  translate([210,-35,52])
//    rotate([0,90,0])
//      volvo(400);
//}
