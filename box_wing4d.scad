// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <cabin3.scad>

/* ----------------------------------------------------

For some reason, this is the only version that renders!

------------------------------------------------------- */

$fs=0.01;
$fa=3;
$fn=64;

NACA = 2412;
ATTACK = 15;
THICKEN = 40;

module trace(bezier) {
  trace_bezier(bezier, N=len(bezier)-1);
}

function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=200)
);

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4], vec3D(v2)))) )   // rotate and translate
     v3];

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);

module wing(h, l, orientation) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  X = [ // L, dx, dy, dz, R
      [25, 20, h+3,  l-15,    -ATTACK, 0],
      [25, 105,  h+10,    l,    -ATTACK, 0],
      [20, 122,  h-8,  l*0.9,    -ATTACK, -THICKEN/2], 
      [16, 126,  h/2+10,   0,   0,       -THICKEN],
      [18, 124,  0,    0,   0,       -THICKEN],  
      [27, 100,  -14,  0,   -ATTACK, -THICKEN/2],
      [30, 0.001, -20,  0,   -ATTACK, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing() {
  wing(70, 120, 0);
  mirror([1, 0, 0]) {
    wing(70, 120, 0);
  }
}

module back_wing() {
  wing(95, 0, 0);
  mirror([1, 0, 0]) {
    wing(95, 0, 0);
   }
}

module prop(r, offset=0) {
  translate([92-offset,57,85]) {
    rotate([0,90,0]) {
      cylinder(6,6,6);
      translate([0,0,-70])
        cylinder(80,4,4);
    }  
    translate([3,0,-12]) {
      translate([0,0,-4])
        cylinder(12,3,3);
      cylinder(2,r,r);
    }
  }
} 

translate([0,67,25]) {
  front_wing();
}

translate([0,67,292]) {
  back_wing();
}

translate([0,70,70]) {
  rotate([0,270,0]) {
    quad_cabin(238, 8);
  }
  
  translate([0,27,85]) {
    prop(45,7);
    mirror([1, 0, 0])
      prop(45,7);
  }
  
  translate([0,-45,-50]) {
    prop(45);
    mirror([1, 0, 0])
      prop(45);
  }
}
  