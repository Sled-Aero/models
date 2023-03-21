use <lib/ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
use <lib/Naca4.scad>
 

use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

 

/*
T(50, 30, 0)
scale([1, 2])
rotate_extrude()
Rz(90)
difference()
{
  polygon(points = airfoil_data(30)); 
  square(100, 100); 
}*/



/*
use <lib/dotSCAD/src/path_extrude.scad>

include <lib/BOSL2/std.scad>
include <lib/BOSL2/skin.scad>
include <lib/BOSL2/rounding.scad>
*/

$fs=0.01;
$fa=3;
$fn=150;
  
copter_l = 310;
copter_w = 100;
copter_h = 120;
cabin_l=300;

back_h = 10;
front_h = 17;

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);
  
function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=200)
);

function rot2D(v, angle) = assert(is_num(angle)) v*[[cos(angle), sin(angle)], [-sin(angle), cos(angle)]]; 

function positive(v) = [for(i=[0:len(v)-1])
  [max(v[i][0],0), max(v[i][1],0)]
];

function circle_points(r, fn=32) = [for(i=[0:fn-1])
  [r*cos(360*i/fn),r*sin(360*i/fn)]
];

function fpath(len, seg=12) = (
  let(b3=[[len,copter_h/5], [len-50,-15], [125,0], [100,0], [75,0], [50,0], [25,0], [0,0], [-25,0], [-30,50], [10,copter_h], [70,copter_h], [len-50,copter_h-50], [len,copter_h/5]])
  
  concat(bzpoints(b3))
);
//path2=bzpoints(concat(b5,b2,b3,b4));

//rounding(r=7)
  //polygon(points=concat(bzpoints(b1), bzpoints(b2), bzpoints(b3), bzpoints(b4), bzpoints(b5)));

//trace_bezier(path, N=len(path)-1);
//translate([5,5,0])
//  circle(5);

//shape = circle_points(2.5);
//trace_bezier(p, N=len(p)-1);

//path_extrude(shape, path2, method = "NO_ANGLE");

module tri_cabin(len, tail) {
  difference() {
    translate([-7,0,-50]) {
      intersection() {

      translate([0,0,-40])
        linear_extrude(180)
          polygon(fpath(len, tail));

      translate([6,5,50])  
        scale([1,1.4,1.1])
          rotate([0,90,13])
            cylinder(len,37,90);  

      }        
    }
    
    translate([250,-50,0]) {
      rotate([0,90,90])
        cylinder(300,65,65);
    }
  }
}

tri_cabin(350,15);


module quad_cabin(len, tail) {
  translate([-7,0,-50])
    difference() {
      intersection() {
        translate([0,50,-3])
          rotate([0,0,-8])
           airfoil(naca=2432, L=len+50, N=300, h=106, open = false);
      /*
        translate([0,0,-3])
          linear_extrude(106)
            polygon(fpath(len, tail)); */

//        translate([-10,48,50]) {
//          rotate([0,90,-3.1]) {
//            scale([1,1.2,1])
//              cylinder(copter_l+20,50,30);  
//          }
//        }
        translate([-90,54,50]) {
          rotate([0,90,-3.1]) {
            scale([3.5,3.5,7])
              rotate_extrude()
                rotate([0,0,90])
                  difference() {
                    polygon(points = airfoil_data(30)); 
                    square(100, 100); 
                  }
          }
        }
      }
      translate([0,-62,20])
        rotate([0,0,0])
          cube([300,60,60]);
    }
    
//    rotate([0,90,0])
//      scale([2, 3, 7])
//        rotate_extrude()
//          rotate([0,0,90])
//            difference() {
//              polygon(points = airfoil_data(30)); 
//              square(100, 100); 
//            }
}

//quad_cabin(250,5);
    

//path_extrude(shape, bzpoints(b1), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b2), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b3), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b4), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b5), method = "EULER_ANGLE");

//echo(vec3D(b5));
//
//extrude_2d_shapes_along_bezier(vec3(concat(b4,b5,b1,b2,b3)))
//  circle(5);



