// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>


// wing data - first dimension describes airfoil
//             last 3 dimensions describe xyz offsets
NACA = 2432;
X = [ // L, dx, dy, dz
      [1, -200, 0.5, 0],
      [0, -198, 10, -1],
      [40, -180, 20, -2],
      [80, -52,  40, -20],  // edge
      [80, -50,  40, -20],
      [80,   0,  40, 0]
   ];
Y = nSpline(X, 100);   // interpolate wing data

sweep(gen_dat(Y,40));
mirror([1, 0, 0])  // second half
  sweep(gen_dat(Y,40));

function gen_dat(X, N=100) = [ for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca = NACA, L = x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, 90, -90, vec3D(v2))))    // rotate and translate
     v3];


