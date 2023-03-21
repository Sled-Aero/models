//use <lib/dotSCAD/src/path_extrude.scad>
//
//include <lib/BOSL2/std.scad>
//include <lib/BOSL2/skin.scad>
//include <lib/BOSL2/rounding.scad>


include <lib/BOSL/constants.scad>
use <lib/BOSL/transforms.scad> 

$fs=0.01;
$fa=3;
$fn=150;


top = [[75,0],[150,350],[450,350],[525,0]];
base = [[75,0],[70,225],[530,225],[525,0]];


//module cross_section() {
//  scale([20,20,40])
//    translate([-3,0,0])
//      union() {
//      polygon(smooth_path(top, size=0.3, closed=true, splinesteps=100));
//      translate([0,-0.5,0])
//        polygon(smooth_path(base, size=0.3, closed=true, splinesteps=100));
//      }
//}

polygon(points=top);

module cross_section() {
  scale([1,1,1])
    translate([-3,0,0])
      round2d(r=16){
        polygon(points=top);
        polygon(points=base);
      }
      
//      union() {
//      polygon(round2d(top, size=0.3, closed=true, splinesteps=100));
//      translate([0,-0.5,0])
//        polygon(round2d(base, size=0.3, closed=true, splinesteps=100));
//      }
}

//cross_section();
//
linear_extrude(height = 300, center = true, convexity = 10, twist = 0)
  cross_section();

  