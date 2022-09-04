// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>


// wing data - first dimension describes airfoil
//             last 3 dimensions describe xyz offsets
NACA = 2412;
X = [ // L, dx, dy, dz
      [28, 0,  54, 80],
      [25, 70,  54, 80],
      [20, 100,  54, 80],
      [15, 120,  52, 77],  // edge
      [20, 130, 40, 60],  // box side
      [30, 128,  -5, 20],  // edge
      [30, 100,  -14, 3],
      [29,   0,  -15, -3]  // centre
   ];
Y = nSpline(X, 100);   // interpolate wing data

sweep(gen_dat(Y,40));
mirror([1, 0, 0])  // second half
  sweep(gen_dat(Y,40));

function gen_dat(X, N=100) = [ for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca = NACA, L = x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, 90, 0, vec3D(v2))))    // rotate and translate
     v3];


