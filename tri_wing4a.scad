// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <cabin7.scad>

/* ----------------------------------------------------

For some reason, this is the only version that renders!

------------------------------------------------------- */

$fs=0.01;
$fa=6;
$fn=200;

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

module fwing(h, l, orientation) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  f = 1.5;
  X = [// L, dx,    dy,     dz,      R
      [f*25, 0.001, h,      l+10,    -ATTACK, 0],
      [f*25, 105,   h-3,    l+10,    -ATTACK, 0],
      [f*22, 122,   h-8,    l+10,    -ATTACK, -THICKEN/2], 
      [f*13, 126,   h/2+10, l+5,     0,       -THICKEN],
      [f*15, 124,   0,      l-10,    0,       -THICKEN],  
      [f*25, 100,   -14,    l-15,    -ATTACK, -THICKEN/2],
      [f*25, 20,    -18,    l-15,    -ATTACK, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing() {
  fwing(75, 25, 0);
  mirror([1, 0, 0]) {
    fwing(75, 25, 0);
  }
}

module bwing(h, l, orientation) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  f = 1.4;
  X = [// L, dx,    dy,     dz,      R
      [f*10, 128,   h/2-5,  l+10,    0,         -THICKEN],
      [f*20, 124,   0,      l-10,    0,         -THICKEN],  
      [f*25, 100,   -14,    l-15,    -ATTACK,   -THICKEN/2],
      [f*25, 60,    -18,    l-15,    -ATTACK,   0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module back_wing() {
  bwing(75, 25, 0);
    mirror([1, 0, 0]) {
      bwing(75, 25, 0);
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
  translate([3,0,-11.5]) {
    translate([0,0,-4])
      cylinder(12,3,3);
    cylinder(2,r,r);
  }
  translate([3,0,9.5]) {
    translate([0,0,-6])
      cylinder(12,3,3);
    cylinder(2,r,r);
  }
} 

rotate([0,90,0]) {
  translate([0,48,110]) {
    front_wing();
  }
  
  translate([0,48,275]) {
    back_wing();
  }

  translate([0,0,0]) {  
    // front props
    translate([0,-25,-78]) {
      translate([-100,57,85])
        prop(50);
      mirror([1,0,0])
        translate([-100,57,85])
          prop(50);
    }
    
    // back prop
    translate([0,31.5,253])
      rotate([90,90,0])
        prop(64);
    
    // cabin
    rotate([0,270,0]) {
      tri_cabin(350, 15);
    }
  }
}
  