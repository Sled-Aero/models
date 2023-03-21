// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <cabin8.scad>

/* ----------------------------------------------------

For some reason, this is the only version that renders!

------------------------------------------------------- */

$fs=0.01;
$fa=6;
$fn=200;

NACA = 2412;
ATTACK = 8;
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

module fwing(h, w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  f = 1.8;
  l = 25;
  X = [// L, dx,     dy,     dz,      R
      [f*31, 0.001,  h,      l-25,    -ATTACK, 0],
      [f*30, w*105,  h-3,    l-24,    -ATTACK, 0],
      [f*27, w*122,  h-8,    l-19,    -ATTACK, -THICKEN/2], 
      [f*10, w*128,  h/2+10, l+5,     0,       -THICKEN],
      [f*15, w*122,  0,      l-5,     0,       -THICKEN],  
      [f*28, w*100,  -14,    l-10,    -ATTACK, -THICKEN/2],
      [f*30, w*20,   -18,    l-15,    -ATTACK, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing(h, l) {
  fwing(h, l, 0);
  mirror([1, 0, 0]) {
    fwing(h, l, 0);
  }
}

module bwing(h, w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  f = 1.2;
  l = 25;
  X = [// L, dx,     dy,     dz,      R
      [f*3,  w*118,  h/8,    l+40,     0,      -THICKEN],
      [f*20, w*116,  -10,    l+15,     0,    -THICKEN],  
      [f*28, w*90,   -14,    l,    -ATTACK/4, -THICKEN/2],
      [f*30, w*20,   -18,    l-15,    -ATTACK/4, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module back_wing(h, l) {
  bwing(h, l, 0);
  mirror([1, 0, 0]) {
    bwing(h, l, 0);
  }
}

module prop(r,a=0) {  
  rotate([0,90,0]) {
    cylinder(6,6,6);
    translate([0,0,-2])
      cylinder(8,4,4);
    translate([0,4*sin(a),4*sin(a)])  
      rotate([a,0,0])
        cylinder(100,4,4);
  }  
  translate([3,0,-12]) {
    translate([0,0,-4])
      cylinder(12,3,3);
    cylinder(2,r,r);
  }
} 

rotate([0,90,0]) {
  translate([0,63,0]) {
    rotate([0,270,0]) {
      quad_cabin(1.03,1,0.8);
    }
    
    // front props
    translate([0,-60,-75]) {
      translate([-110,57,85])
        prop(60);
      mirror([1,0,0])
        translate([-110,57,85])
          prop(60);
    }
    
    // back props
    translate([0,15,154]) {
      translate([-110,57,85])
        prop(60, 45);
      mirror([1,0,0])
        translate([-110,57,85])
          prop(60, 45);
    }
    
    translate([0,0,115]) {
      front_wing(95, 1.2);
    }
    
    translate([0,18,281]) {
      back_wing(110, 0.95);
    }
  }
}

  