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

use <Cabin.scad>

$fs=0.01;
$fa=3;
$fn=100;

NACA = 2432;
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
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4],vec3D(v2)))) )   // rotate and translate
     v3];

//trace_bezier(bez, N=len(bez)-1); 
//trace_polyline(bezier_polyline(bez3, N=len(bez3)-1, splinesteps=100), size=1);


// wing data - first dimension selects airfoil
//             next 3 dimensions describe xyz offsets
//             last dimension describes rotation of airfoil

X = [ // L, dx, dy, dz, R
      [28, 0,  54, 80, -ATTACK, 0],
      [25, 70,  54, 80, -ATTACK, 0],
      [20, 100,  54, 80, -ATTACK, 0],
      [10, 120,  52, 77, -ATTACK, -THICKEN/2], 
      [15, 130, 40, 60, 0, -THICKEN],  
      [25, 128,  -5, 20, 0, -THICKEN],  
      [30, 100,  -14, 3, -ATTACK, -THICKEN/2],
      [29,   0,  -15, -3, -ATTACK, 0]
   ];
Xs = nSpline(X, 150);   // interpolate wing data


/*
function vec2D(v, z=0) = [for(i = [0:len(v)-1])
  [v[i][0], v[i][1]]];

p = airfoil_data(naca=NACA, L=30, N=100);
q = R_(0, 0, -10, vec3D(p));
linear_extrude(height = 100, twist = 0, scale = 1)
polygon(points = vec2D(q));
*/


// front wing
translate([0,0,0]) {
  sweep(gen_dat(Xs,0,100));
  mirror([1, 0, 0])  
    sweep(gen_dat(Xs,0,100));
}


// back wing
translate([0,0,275]) {
  rotate([0,180,0]) {
    sweep(gen_dat(Xs,180,100));
    mirror([1, 0, 0])  
      sweep(gen_dat(Xs,180,100));
  }
}

// cabin
translate([0,50,260])
  rotate([0,270,0])
    scale([3.5,3,2.5])
      egg2();

/*
// body
b5 = [[0,90], [30,90], [20,90], [150,90], [200,90], [180,60], [150,-40], [125,0], [100, 0], [75,0], [50,0], [25,0], [0,90]];


// cabin
translate([40,40,80])
rotate([0,270,0])
linear_extrude(height=80)
//extrudeWithRadius(80, 10, 10, 100)
  rounding(r=1)
    polygon(points=concat(bzpoints(b5)));

*/