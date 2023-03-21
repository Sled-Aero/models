use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

/*
use <lib/dotSCAD/src/path_extrude.scad>

include <lib/BOSL2/std.scad>
include <lib/BOSL2/skin.scad>
include <lib/BOSL2/rounding.scad>
*/

$fs=0.01;
$fa=3;
$fn=100;
  
copter_l = 310;
copter_w = 100;
copter_h = 115;
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
  let(b3=[[cabin_l,copter_h/5], [cabin_l-50,-15], [125,0], [100,0], [75,0], [50,0], [25,0], [0,0], [-25,0], [-30,50], [10,copter_h], [70,copter_h], [cabin_l-50,copter_h-50], [cabin_l,copter_h/5]])
  
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

      translate([0,0,-30])
        linear_extrude(160)
          polygon(fpath(len, tail));

      translate([6,5,50])  
        scale([1,1.5,1.1])
          rotate([0,90,17.5])
            cylinder(len,43,70);  

      }        
    }
    
    translate([250,30,0]) {
      rotate([0,90,90])
        cylinder(70,60.5,60.5);
    }
  }
}

//tri_cabin(325,12);


module quad_cabin(len, tail) {
  translate([-7,0,-50])
    intersection() {
      translate([0,0,-3])
        linear_extrude(106)
          polygon(fpath(len, tail));

      translate([-10,38,50])  
        scale([1,1,1])
          rotate([0,90,-1])
            cylinder(copter_l+20,52,30);       
    }
}

quad_cabin(250,5);
    

//path_extrude(shape, bzpoints(b1), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b2), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b3), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b4), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b5), method = "EULER_ANGLE");

//echo(vec3D(b5));
//
//extrude_2d_shapes_along_bezier(vec3(concat(b4,b5,b1,b2,b3)))
//  circle(5);



