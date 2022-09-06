include <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>
use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 
use <lib/thing_libutils/Naca4.scad>

$fs=0.01;
$fa=3;
$fn=100;

module trace(bezier) {
  trace_bezier(bezier, N=len(bezier)-1);
}

function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=100)
);


//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);

copter_l = 310;
copter_w = 100;
copter_h = 75;
spar_w = 10;
spar_h = 15;
big_prop_r=40;
big_prop_h=8;
small_prop_r=25;
small_prop_h=6;
wing_l = 60;

back_h = 10;
front_h = 17;


// body
b1 = [[0,0], [37.5,copter_h], [150,copter_h]];
b2 = [[150,copter_h], [copter_l,copter_h]];
b3 = [[copter_l,copter_h], [copter_l,copter_h-spar_h]];
b4 = [[copter_l,copter_h-spar_h], [225,copter_h-spar_h]];
b5 = [[225,copter_h-spar_h], [200,copter_h-spar_h], [175,copter_h-spar_h], [150,-20], [125,0], [100, 0], [75,0], [50,0], [25,0], [0,0]];

difference() {
    // cabin
    linear_extrude(height=copter_w)
    //extrudeWithRadius(copter_w, 5, 5, 80)
      rounding(r=6)
        polygon(points=concat(bzpoints(b1), bzpoints(b2), bzpoints(b3), bzpoints(b4), bzpoints(b5))));

    // notch
    union() {
      translate([240,100,50])
        rotate([90,0,0])
          cylinder(80, big_prop_r+2.5, big_prop_r+2.5);
      translate([290,50,5])    
        cube([90,50,90]);
    }
}

// back prop
translate([240,72,50])
  rotate([90,0,0])
    cylinder(10, big_prop_r, big_prop_r);


module prop() {
  rotate([90,0,0])
    cylinder(small_prop_h, small_prop_r, small_prop_r);
  translate([0,-2.5,-100])  
    cylinder(100,5,5);  
}

module front_wing() {
   difference() {
    rotate([0,0,-8]) 
      translate([-40,0,-50]) {  
        airfoil(naca=4412, L=40, N=101, h=110, open=false);   
        translate([0,0,110])
          rotate([-15,30,-3]) 
            airfoil(naca=4412, L=40, N=101, h=wing_l, open=false);
    } 
    translate([-40,0,wing_l+20])
      cube([70,20,40]);    
  }
}

// front wings
translate([0,-front_h,copter_w])
  front_wing();
translate([0,-front_h,0])
  rotate([0,180,0])
    mirror([1,0,0])
      front_wing();

// front props
translate([80,15,copter_w+30])
  prop();
translate([80,15,-30])
  rotate([0,180,0])
    prop();

// back wings
translate([335,copter_h+back_h,copter_w])
  front_wing();
translate([335,copter_h+back_h,0])
  rotate([0,180,0])
    mirror([1,0,0])
      front_wing();
     

// struts
b6 = [[0,2], [25,0], [30,0], [50,0], [75,0], [100,0], [125,0], [150,0], [175,0], [200,2]];
b7 = [[200,2], [200,-5], [175,-5], [150,-5], [125,-5], [100,-5], [75,-5], [50,-5], [25,-5], [0,-5], [0,2]];
    
translate([-20,-18,0])
  linear_extrude(height=4)
     polygon(points=concat(bzpoints(b6), bzpoints(b7)));
     /*
translate([-20,-17,copter_w-4])
  linear_extrude(height=4)
     polygon(points=slice(concat(bzpoints(b6), bzpoints(b7)), 0, -1)); */


translate([-20,-1,copter_w-4])
linear_extrude(height=4)
    polygon(points=concat(bzpoints(b6), bzpoints(b7)));

// fins
/*
fin_h = 50;
fin_w = 32;
b10 = [
[10, copter_h-10],
[10, copter_h-10-fin_h],
[30, copter_h-10-fin_h],
[fin_w+2, copter_h-10-fin_h],
[fin_w, copter_h-10-fin_h+10],
[fin_w, copter_h-10]
];
b11 = [[fin_w, copter_h-10], [10, copter_h-10]];

module fin() {
 linear_extrude(height=5)
   polygon(points=slice(concat(bzpoints(b10), bzpoints(b11)), 0, -1));
}

translate([350-fin_w,0,2.5])
  fin();
translate([350-fin_w,0,copter_w-10+2.5])
  fin();
  */

