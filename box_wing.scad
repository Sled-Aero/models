// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>
use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 

use <cabin.scad>
use <cabin2.scad>

$fs=0.01;
$fa=3;
$fn=100;

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


module wing(h, orientation) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  X = [ // L, dx, dy, dz, R
      [35, 0,  h, 80, -ATTACK, 0],
      [27, 80,  h, 80, -ATTACK, 0],
      [18, 95,  h, 80, -ATTACK, 0],
      [10, 120,  h, 80, -ATTACK, -THICKEN/2], 
      [9, 130, h-10, 80, 0, -THICKEN],
      [12, 132,  10, 73, 0, -THICKEN],  
      [27, 128,  -5, 20, 0, -THICKEN],  
      [27, 110,  -14, 3, -ATTACK, -THICKEN/2],
      [29,   0,  -19, -3, -ATTACK, 0]
   ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing() {
  wing(60, 0);
}

module back_wing() {
  wing(80, 180);
}

front_wing();
  