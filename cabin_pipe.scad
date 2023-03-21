use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>


use <lib/dotSCAD/src/path_extrude.scad>
/*
include <lib/BOSL2/std.scad>
include <lib/BOSL2/skin.scad>
include <lib/BOSL2/rounding.scad>
*/

$fs=0.01;
$fa=3;
$fn=100;
  
copter_l = 310;
copter_w = 100;
copter_h = 95;
spar_w = 10;
spar_h = 12;
cabin_l=200;

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

function fpath(l, h, seg=12) = (
  let(b=[[l,copter_h/5], [l-50,-15], [125,0], [100,0], [75,0], [50,0], [25,0], [0,0], [-25,0], [-30,50], [10,h], [70,h-30], [100,h], [l-50,h-50], [l,h/5]])
  concat(bzpoints(b))
);

//path2=bzpoints(concat(b5,b2,b3,b4));

//rounding(r=7)
  //polygon(points=concat(bzpoints(b1), bzpoints(b2), bzpoints(b3), bzpoints(b4), bzpoints(b5)));

//trace_bezier(path, N=len(path)-1);
//translate([5,5,0])
//  circle(5);


module qtr_hoop(r,h,w) {
  rotate([90,0,0])
    translate([0,w/2,h/2]) {
      rotate([90,0,90])
        rotate_extrude(angle=90, convexity=10)
          translate([r,0,0])
            circle(r=2.5, $fn=100);
            
      translate([0,r,-h/2])
        linear_extrude(h/2)   
          circle(r=2.5, $fn=100);
          
      translate([0,0,r])
        rotate([90,0,0])
          linear_extrude(w/2)   
            circle(r=2.5, $fn=100);    
    }
}

module hoop(r,h,w) {
  qtr_hoop(r,h,w);
  mirror([0,0,1])    
    qtr_hoop(r,h,w);
  rotate([180,180,0]) {
    qtr_hoop(r,h,w);
    mirror([0,0,1])    
      qtr_hoop(r,h,w);
  }
}

width = 20;

translate([235,30,0]) hoop(15,10,width/2);
translate([190,35,0]) hoop(25,20,width/2);
translate([145,40,0]) hoop(30,20,width/2);
translate([100,43,0]) hoop(33,20,width/2);
translate([55,40,0])  hoop(30,20,width/2);
translate([10,38,0])  hoop(15,10,width/2);  
        

//shape = circle_points(2.5);
//p = fpath(200);
//trace_bezier(p, N=len(p)-1);
translate([0,5,width])
  path_extrude(circle_points(2.5), fpath(280,105), method = "EULER_ANGLE");
translate([0,5,-width])
  path_extrude(circle_points(2.5), fpath(280,105), method = "EULER_ANGLE");  


module quad_cabin(len, tail) {
  translate([-7,0,-50])
    intersection() {
    //union() {
    //path_sweep(circle(3), path);

    translate([0,0,-3])
      linear_extrude(106)
        polygon(fpath(len, tail));

    //linear_extrude(100)
    //shell2d(3)
    //  polygon(path);
      
    //translate([0,0,100])
      //path_sweep(circle(3), path);  
    //

    translate([0,47,50])  
      scale([1,1.3,1])
      rotate([0,90,-1])
        cylinder(copter_l+20,52,40);  
  }
}
//quad_cabin(230,5);
    

//path_extrude(shape, bzpoints(b1), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b2), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b3), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b4), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b5), method = "EULER_ANGLE");

//echo(vec3D(b5));
//
//extrude_2d_shapes_along_bezier(vec3(concat(b4,b5,b1,b2,b3)))
//  circle(5);



