use <lib/ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
use <lib/Naca4.scad>
// 
use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <lib/BOSL/transforms.scad>

use <lib/Round-Anything/polyround.scad>

use <lib/dotSCAD/src/bezier_smooth.scad>
use <lib/dotSCAD/src/bspline_curve.scad>


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
$fn=100;
  
copter_l = 400;
copter_w = 100;
copter_h = 150;
cabin_l=300;

back_h = 10;
front_h = 17;

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);
  
function bzpoints(bezier, splinesteps=200) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=splinesteps)
);

function rot2D(v, angle) = assert(is_num(angle)) v*[[cos(angle), sin(angle)], [-sin(angle), cos(angle)]]; 

function positive(v) = [for(i=[0:len(v)-1])
  [max(v[i][0],0), max(v[i][1],0)]
];

function circle_points(r, fn=32) = [for(i=[0:fn-1])
  [r*cos(360*i/fn),r*sin(360*i/fn)]
];


function fpath(l, h, seg=12) = (
//  let(b3=[[len,copter_h/5], [len-80,-20], [125,0], [100,0], [75,0], [50,0], [25,0], [0,0], [-100,60], [-25,0], [-50,60], [10,copter_h], [70,copter_h], [len-50,copter_h-50], [len,copter_h/5]])
  
  let(
    h1=h*1.1,
    h2=h*0.5,
    b1=[[0,0], [10,h1*0.5], [l/1.8,h1], [l*1.3,0]],
    b2=reverse([[0,0], [10,-h2*0.5], [l/1.8,-h2], [l*1.3,0]])
  )
  
//  concat(bzpoints(concat(b1,b2)))
  concat(bzpoints(b1), bzpoints(b2))
);

function round_corners(path, r, steps=100) = (
  polyRound(addZcoord(path,r), steps)
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


module wing(length, height) {
  rotate([180,0,0]) {
    intersection() {
    translate([20,0,-100]) {
      linear_extrude(200)
        polygon(fpath(length, height));
      }
    }
  }
}

//quad_cabin(300,100);
    

//path_extrude(shape, bzpoints(b1), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b2), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b3), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b4), method = "EULER_ANGLE");
//path_extrude(shape, bzpoints(b5), method = "EULER_ANGLE");

//echo(vec3D(b5));
//
//extrude_2d_shapes_along_bezier(vec3(concat(b4,b5,b1,b2,b3)))
//  circle(5);

//linear_extrude(height = 50, center = true, convexity = 10, scale=[1.5,1.5], $fn=100)
//  circle(r = 10);

module slice() {
  rotate([0,0,90])
    difference() {
      polygon(points = airfoil_data(30, N=300)); 
      square(100, 100); 
    }
}

arc = 8;
n = 40;
module half() {
  scale([1.5,1,2]) {
    translate([0,n/8,0]) {
        rotate_extrude(angle = 180, $fn=300)
          slice();
    }

    translate([-n*cos(arc)-2/n,0,0])
      rotate([0,0,-arc])
        rotate_extrude(angle = arc*2)
          translate([n,0,0])
            slice();  
  }
}

//top = [[-22.5,0],[-15,35],[15,35],[22.5,0]];
//base = [[-22.5,0],[-23,22.5],[23,22.5],[22.5,0]];
top2 = [[-22.5,0],[-20,25],[-15,35],[0,36.5],[15,35],[20,25],[22.5,0]];
base2 = [[-22.5,0],[-24,10],[-23,22.5],[23,22.5],[24,10],[22.5,0],[12,-1.5],[0,-2],[-12,-1.5]];


module spread_drop() {
  union() {
    half();
    rotate([0,0,180])
      half(); 
  }
}

module drop(w,h,l) {
  scale([w,h,l]) 
    translate([0,n/8,0]) {
        rotate_extrude(angle = 360, $fn=300)
          slice();
    }
}

module cut() {
  translate([45,-80,0])
    rotate([0,0,20])
      scale([1.5,0.8,1])
        sphere(100);
}

module shell(len) {
  intersection() {
    translate([14,-50,0])
      rotate([0,90,6])
        drop(4,5,3.7);
      
    wing(len,110);
  }
}

module body(len) {
  union() {
    difference() {
      shell(len);
      cut();
    }
  }   
}

module body_shell(len) {
  difference() {
    union() {
      body(len);
      rotate([180,0,0]) {
        translate([159,-31.2,20])
          fin(3);
        translate([159,-31.2,-20])
          fin(3);
      }
    }
    translate([0.8,0,0])
      scale([0.99,0.99,0.99])
        body(len);
  }
}

module hatch(len) {
  intersection() {
    shell(len);
    cut();
  }
}

module hatch_shell(len) {
  difference() {
    hatch(len);
    translate([1,1,0])
      scale([1,1,0.99])
        hatch(len);
  }
}

fin_shape = [[0,0],[0,30],[160,30],[90,0]];

module fin_section() {
   polygon(bezier_smooth(fin_shape,5,closed = true));
}

module fin(h) {
  linear_extrude(height = h, center = true, convexity = 10, twist = 0)
    fin_section();
}

module quad_cabin_shell(len, l=1,h=1,w=1) {
  scale([l,h,w])
  translate([-19,0,0])
    rotate([180,0,0]) {
      body_shell(len);
//      color("grey") { translate([0,-0.3,0]) hatch_shell(len); }
    }
    
//  translate([140,-31.2,20])
//    fin(3);
//  translate([140,-31.2,-20])
//    fin(3);   
}

module quad_cabin(len, l=1,h=1,w=1) {
  scale([l,h,w])
  translate([-19,0,0])
    rotate([180,0,0]) {
      body(len);
      color("grey") { translate([0,-0.3,0]) hatch(len); }
    }
    
//  translate([140,-31.2,20])
//    fin(3);
//  translate([140,-31.2,-20])
//    fin(3);   
}

//quad_cabin_shell(250);
quad_cabin(250);



