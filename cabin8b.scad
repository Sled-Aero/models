use <lib/ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
use <lib/Naca4.scad>
// 
use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad>  // https://github.com/openscad/scad-utils
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>
use <lib/BOSL/shapes.scad>
use <lib/BOSL/transforms.scad>

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

$fs=0.1;
$fa=3;
$fn=100;


FLATTEN = true;
HAS_HATCH = false;
SCALE = 7;
ROOF_OFFSET = 5.3;
ROOF_HEIGHT = 0.3;
FLOOR_OFFSET = 1.2;
FLOOR_HEIGHT = 0.5;
HOLE=0.3;
AXLE_RADIUS=3.5;
RESOLUTION=100;
  
copter_l = 400;
copter_w = 100;
copter_h = 150;
cabin_l=300;

back_h = 10;
front_h = 17;

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);
  
function bzpoints(bezier, splinesteps=100) = (
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

module rotate_about_pt(rot, pt) {
  translate(pt)
    rotate(rot)
      translate(-pt)
        children();
}

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
        rotate_extrude(angle = 180, $fn=RESOLUTION)
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
        rotate_extrude(angle=360, $fn=300)
          slice();
    }
}

module cut() {
  translate([50,-95,0])
    rotate([0,0,15])
      scale([2.1,0.9,1])
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

module body(has_hatch, len, has_axle=false) {

  difference() {
    shell(len);

    rotate_about_pt([0,0,7],[346, -1, 0]) {
      translate([346, -1, 0]) {
        difference() {
          cube([12, 12, 40], true);
        }
      }
    }


    if (has_hatch) {
      cut();
    }

    if (has_axle)
      translate([48.1, 4.5, -50]) {
        cylinder(100, AXLE_RADIUS/1.1, AXLE_RADIUS/1.1); // magic number
//        translate([-AXLE_RADIUS/1.1, -4.5, 0]) cube([AXLE_RADIUS/1.1 * 2, 4.5, 100]);
      }
  }
}

module body_shell(has_hatch, len, has_axle=false) {
  difference() {
    union() {
      body(has_hatch, len, has_axle);

//      rotate([180,0,0]) {
//        translate([159,-31.2,20])
//          fin(3);
//        translate([159,-31.2,-20])
//          fin(3);
//      }
    }
    translate([2.5,0,0])
      scale([0.97,0.97,0.97])
        body(has_hatch, len);
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
    translate([1.5,3,0])
      scale([0.993,0.99,0.97])
        hatch(len);
  }
}

fin_shape = [[0,0],[0,30],[160,30],[90,0]];

module fin_section() {
   polygon(bezier_smooth(fin_shape,5,closed = true));
}

module fin(h) {
  linear_extrude(height=h, center=true, convexity=10, twist=0)
    fin_section();
}

module quad_cabin_shell(has_hatch, len, l=1,h=1,w=1) {
  scale([l,h,w])
    translate([-19,0,0])
      rotate([180,0,0]) {
        body_shell(true, len, true);
        if (has_hatch) {
          color("grey") {translate([0, -0.3, 0]) hatch_shell(len);}
        }
      }
    
//  translate([140,-31.2,20])
//    fin(3);
//  translate([140,-31.2,-20])
//    fin(3);   
}

module tail_holes() {
  rotate([0, 90, 0]) {
    translate([-19, 30, 285])
      rotate([0, 75, 14])
        scale([1.6, 1.6, 0.6])
          sphere(10);

    translate([19, 30, 285])
      rotate([0, -75, -14])
        scale([1.6, 1.6, 0.6])
          sphere(10);
  }
}

module quad_cabin(has_hatch, has_axle, len, l=1,h=1,w=1) {
  scale([l, h, w])
    difference() {
      translate([-19, 0, 0])
        rotate([180, 0, 0]) {
          body(has_hatch, len, has_axle);
          if (has_hatch) {
            color("grey") {translate([0, - 0.3, 0]) hatch(len);}
          }
        }
      scale([1 / l, 1 / h, 1 / w])
        tail_holes();
    }
//  translate([140,-31.2,20])
//    fin(3);
//  translate([140,-31.2,-20])
//    fin(3);   
}

module roof() {
  translate([14, ROOF_OFFSET-FLOOR_OFFSET, -4.5])
    rotate([90,0,0]) {
      linear_extrude(height=ROOF_HEIGHT)
        difference() {
          rounding(r = 1) square([19, 9]);

          translate([0, -0.5, 0]) {
            for (i = [0 : 2]) {
              // holes
              translate([2.5 + i * 5.5, 2.5, 0]) {
                rounding(r = 1) square([2.85, 5]);
              }

              // rails
              translate([1 + i * 7, 1.2, 0]) {
                translate([0, HOLE / 2, 0]) circle(HOLE / 2);
                square([3, HOLE]);
                translate([3, HOLE / 2, 0]) circle(HOLE / 2);
              }
              translate([1 + i * 7, 8.5, 0]) {
                translate([0, HOLE / 2, 0]) circle(HOLE / 2);
                square([3, HOLE]);
                translate([3, HOLE / 2, 0]) circle(HOLE / 2);
              }
            }

            for (i = [0 : 3]) {
              // cross-rails
              translate([1.0 + i * 5.5, 2.5, 0]) {
                translate([HOLE / 2, 0, 0]) circle(HOLE / 2);
                square([HOLE, 5]);
                translate([HOLE / 2, 5, 0]) circle(HOLE / 2);
              }
            }
          }
        }
    }
}

module floor() {
  intersection() {
    translate([0, -FLOOR_OFFSET, -7]) {
      rotate([90, 0, 0]) {
        linear_extrude(height=FLOOR_HEIGHT)
          difference() {
            square([50, 14]);

            for (i = [0 : 2]) {
              // rails
              translate([10 + i * 8.25, 3.2, 0]) {
                translate([0, HOLE / 2, 0]) circle(HOLE / 2);
                square([6, HOLE]);
                translate([6, HOLE / 2, 0]) circle(HOLE / 2);
              }
              translate([10 + i * 8.25, 10.5, 0]) {
                translate([0, HOLE / 2, 0]) circle(HOLE / 2);
                square([6, HOLE]);
                translate([6, HOLE / 2, 0]) circle(HOLE / 2);
              }
            }

            // holes
            for (i = [1 : 7])
            translate([4 + i * 4.85, 4.75, 0]) {
              rounding(r = 1) square([2.85, 4.5]);
            }

            // mounting holes
            translate([37, 7, 0]) circle(0.2);
            translate([3, 7, 0]) circle(0.2);
            translate([17.1, 12, 0]) circle(0.2);
            translate([17.1, 2, 0]) circle(0.2);
          }
      }
    }
    scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
      translate([0.8, 0, 0])
        scale([0.99, 0.99, 0.99])
          quad_cabin(false, false, 250, 1.1, 1, 0.8);
  }
}

module battery() {
  cube([15,4.8,4.8]);
}

module pole(len) {
  difference() {
    cylinder(len,0.6,0.6);
    cylinder(len,HOLE/2,HOLE/2);
  }
}

module tab(w,l) {
  difference() {
    union() {
      cylinder(w, 0.6, 0.6);
      rotate([0, 0, -90]) translate([0, -0.6, 0]) cube([l, 1.2, 1]);
    }
    cylinder(w,HOLE/2,HOLE/2);
  }
}

module bottom_tabs(l) {
  translate([1.145, 0.6, 0]) rotate([0, 90, 0]) {
    translate([HOLE / 2+1.5, 0, 0]) tab(1,l);
    translate([-HOLE / 2-1.5, 0, 0]) tab(1,l);
  }
  translate([43.87, 0.6, 0]) rotate([0, 90, 0]) {
    translate([HOLE / 2+1, 0, 0]) tab(1,l);
    translate([-HOLE / 2-1, 0, 0]) tab(1,l);
  }
}

module top_shell() {
  difference() {
    scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
      difference() {
        quad_cabin_shell(false, 250, 1.1, 1, 0.8);
        tail_holes();
      }
    hatch_hinge();
    translate([0, -10, -10])
      cube([55, 10, 20]);
  }
  translate([37.2, 5.91, -1.5]) {
    pole(0.75);
  }
  translate([37.2, 5.91, 0.75]) {
    pole(0.75);
  }

  intersection() {
    union() {
      // front stays
      translate([2.145, 0.6, 0]) rotate([0, 90, 0]) {
        translate([3.5, 0, 0.5]) cube([3, 1, 1], true);
        translate([HOLE / 2 + 1.5, 0, 0]) pole(1);
        translate([0, 0, 0.5]) cube([3, 1, 1], true);
        translate([-HOLE / 2 - 1.5, 0, 0]) pole(1);
        translate([-3.5, 0, 0.5]) cube([3, 1, 1], true);
      }

      // back stays
      translate([44.87, 0.6, 0]) rotate([0, 90, 0]) {
        translate([2.5, 0, 0.5]) cube([2, 1, 1], true);
        translate([HOLE / 2+1, 0, 0]) pole(1);
        translate([0, 0, 0.5]) cube([2, 1, 1], true);
        translate([-HOLE / 2-1, 0, 0]) pole(1);
        translate([-2.5, 0, 0.5]) cube([2, 1, 1], true);
      }
    }
    scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
      quad_cabin(false, false, 250, 1.1, 1, 0.8);
  }
}

module bottom_shell() {
  difference() {
    union() {
      scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
        quad_cabin_shell(false, 250, 1.1, 1, 0.8);

      intersection() {
        union() {
          translate([0, -FLOOR_OFFSET -FLOOR_HEIGHT, -7])
            rotate([90, 0, 0]) {
              translate([37, 7, 0]) pole(3);
              translate([3, 7, 0]) pole(3);
              translate([17.1, 12, 0]) pole(3);
              translate([17.1, 2, 0]) pole(3);
            }
          bottom_tabs(3);
        }
        scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
          quad_cabin(false, true, 250, 1.1, 1, 0.8);
      }
    }
    translate([0, 0, -10])
      cube([55, 10, 20]);
  }
  bottom_tabs(1);
}

module hatch_hinge() {
  intersection() {
    scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
      quad_cabin_shell(false, 250, 1.1, 1, 0.8);

    translate([37, 7, 0]) {
      intersection() {
        cube([3, 4, 1.5], true);
        translate([-1.8, 0, 0]) rotate([90, 0, 0]) cylinder(3, 3, 3);
      }
    }
  }
  translate([37.2, 5.91, -0.75]) {
    pole(1.5);
  }

  translate([31.5, 7.9, -0.75]) {
    rotate([0,0,-25]) cube([6,0.45,1.5]);
    translate([2.5,-1.1,0])
    rotate([0,0,-18]) cube([3,0.45,1.5]);
  }
}

module scaled_hatch_shell() {
  scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
    scale([1.1, 1, 0.8])
      translate([-19, 0, 0])
        rotate([180, 0, 0])
          hatch_shell(250);
}

// main

//rotate([0,45,0])
//  scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
//    quad_cabin(false, true, 250, 1.1, 1, 0.8);

//color("grey") {
//  translate([- 0.01, 0.02, 0]) {
//    scaled_hatch_shell();
//    translate([0, 0, 0]) hatch_hinge();
//  };
//};

//  top_shell();
//
//  bottom_shell();


if (FLATTEN) {
  projection(cut = true)
    rotate([90, 0, 0]) translate([-14, FLOOR_OFFSET-ROOF_OFFSET, 0])
      roof();
} else {
  roof();
}

//translate([16, 0.1 - FLOOR_OFFSET, 0.1])
//  battery();
//translate([16, 0.1 - FLOOR_OFFSET, -4.9])
//  battery();

//if (FLATTEN) {
//  translate([-2.1,0,0])
//  projection(cut = true)
//    rotate([90, 0, 0]) translate([0, FLOOR_OFFSET+FLOOR_HEIGHT-0.01, 0])
//      floor();
//} else {
//  translate([0, -FLOOR_OFFSET-FLOOR_HEIGHT, 0])
//    rotate([ -90, 0, 0])
//      linear_extrude(height = FLOOR_HEIGHT)
//        projection(cut = true)
//          rotate([90, 0, 0]) translate([0, FLOOR_OFFSET + FLOOR_HEIGHT - 0.01, 0])
//            floor();
//}

//translate([15.3, 0.1 - FLOOR_OFFSET, - 3.65])
//  rotate([-90,0,0]) pole(ROOF_OFFSET-0.3);
//translate([15.3, 0.1 - FLOOR_OFFSET, 3.65])
//  rotate([-90,0,0]) pole(ROOF_OFFSET-0.3);
//translate([31.7, 0.1 - FLOOR_OFFSET, - 3.65])
//  rotate([-90,0,0]) pole(ROOF_OFFSET-0.3);
//translate([31.7, 0.1 - FLOOR_OFFSET, 3.65])
//  rotate([-90,0,0]) pole(ROOF_OFFSET-0.3);

// scanner base
//translate([-3,-10,-37])
//  cube([40,4,40]);
