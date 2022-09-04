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

function seg(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=100)
);


//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);

copter_l = 350;
copter_w = 100;
copter_h = 75;
spar_w = 10;
spar_h = 15;
big_prop_r=40;
big_prop_h=8;
small_prop_r=25;
small_prop_h=6;
wing_l = 60;


// body
b1 = [[0,0], [37.5,copter_h], [150,copter_h]];
b2 = [[150,copter_h], [copter_l,copter_h]];
b3 = [[copter_l,copter_h], [copter_l,copter_h-spar_h]];
b4 = [[copter_l,copter_h-spar_h], [175,copter_h-spar_h]];
b5 = [[225,copter_h-spar_h], [200,copter_h-spar_h], [175,copter_h-spar_h], [150,-20], [125,0], [100, 0], [75,0], [50,0], [25,0], [0,0]];


// cabin
linear_extrude(height=copter_w)
//extrudeWithRadius(copter_w, 5, 5, 80)
  rounding(r=3)
    polygon(points=slice(concat(seg(b1), seg(b2), seg(b3), seg(b4), seg(b5)), 0, -1));


module prop() {
  rotate([90,0,0])
    cylinder(small_prop_h, small_prop_r, small_prop_r);
  translate([0,-2.5,-100])  
  cylinder(100,5,5);  
}

module front_wing() {
   difference() {
    rotate([8,0,-8]) 
      translate([0,5,0]) {  
        airfoil(naca=4412, L=40, N=101, h=wing_l, open=false);   
        translate([0,0,wing_l])
          rotate([-10,30,-3]) 
            airfoil(naca=4412, L=40, N=101, h=wing_l, open=false);
    } 
    translate([0,-10,wing_l+20])
      cube([70,20,40]);    
  }
}

module back_wing() {
   difference() {
    rotate([8,0,-8]) 
      translate([0,5,0]) {  
        airfoil(naca=2411, L=40, N=101, h=wing_l, open=false);   
        translate([6,0,wing_l-22])
          rotate([-3,-30,0]) 
            airfoil(naca=2411, L=40, N=101, h=wing_l, open=false);
    } 
    translate([-30,-10,wing_l+20])
      cube([70,20,40]);    
  }
}

// front wings
translate([10,3,copter_w])
  front_wing();
translate([10,3,0])
  rotate([0,180,0])
    mirror()
      front_wing();

// front props
translate([80, 5, copter_w+30])
  prop();
translate([80, 5, -30])
  rotate([0,180,0])
  prop();

// back wings
translate([265,copter_h-10,copter_w])
  back_wing();
translate([265,copter_h-10,0])
  rotate([0,180,0])
    mirror()
      back_wing();
      

// struts
b6 = [[23,-1], [25,2], [27,3], [30,-8], [50,-1], [75,-1], [100, -1], [125, -3], [150,-3], [175, -3], [205,-15], [230,copter_h-spar_h/2],[255,copter_h-spar_h/2-3]];
b7 = [[255,copter_h-spar_h/2-3], [290,copter_h-spar_h/2-10]];
b8 = [[65,-6],[100,-6], [125, -6], [150, -6], [175,-6], [200,-6], [230,-20], [245,copter_h-spar_h/2],[290,copter_h-spar_h/2-10]];
b9 = [[65,-6], [50, -6], [20, -4], [23,-1]];
    
translate([0,0,-80])
  linear_extrude(height=4)
     polygon(points=slice(concat(seg(b6), seg(b7), reverse(seg(b8)), seg(b9)), 0, -1));
translate([0,0,copter_w+80-4])
  linear_extrude(height=4)
     polygon(points=slice(concat(seg(b6), seg(b7), reverse(seg(b8)), seg(b9)), 0, -1)); 



// fins
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
   polygon(points=slice(concat(seg(b10), seg(b11)), 0, -1));
}

translate([copter_l-fin_w,0,2.5])
  fin();
translate([copter_l-fin_w,0,copter_w-10+2.5])
  fin();

