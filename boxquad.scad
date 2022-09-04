// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>


NACA = 2412;
ATTACK = 5;
THICKEN = 40;

// wing data - first dimension selects airfoil
//             next 3 dimensions describe xyz offsets
//             last dimension describes rotation of airfoil

X = [ // L, dx, dy, dz, R
      [28, 0,  54, 80, -ATTACK, 0],
      [25, 70,  54, 80, -ATTACK, 0],
      [20, 100,  54, 80, -ATTACK, 0],
      [15, 120,  52, 77, -ATTACK, -THICKEN/2], 
      [20, 130, 40, 60, 0, -THICKEN],  
      [30, 128,  -5, 20, 0, -THICKEN],  
      [30, 100,  -14, 3, -ATTACK, -THICKEN/2],
      [29,   0,  -15, -3, -ATTACK, 0]
   ];
Xs = nSpline(X, 100);   // interpolate wing data

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4],vec3D(v2)))) )   // rotate and translate
     v3];

function vec2D(v, z=0) = [for(i = [0:len(v)-1])
  [v[i][0], v[i][1]]];


/*
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
translate([0,0,300]) {
  rotate([0,180,0]) {
    sweep(gen_dat(Xs,180,100));
    mirror([1, 0, 0])  
      sweep(gen_dat(Xs,180,100));
  }
}

