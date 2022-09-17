use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <lib/dotSCAD/src/path_extrude.scad>

$fs=0.01;
$fa=3;
$fn=100;

ATTACK=10;
NACA=2412;

function vec2D(v, a=0, b=1) = [
  for(i = [0 : len(v)-1])
    [v[i][a], v[i][b]]
 ];

function rot2D(v, angle) = assert(is_num(angle)) v*[[cos(angle), sin(angle)], [-sin(angle), cos(angle)]]; 
 
  
X = [ // L, dx, dy, dz, R
  [0,  54, 80],
  [70,  54, 80],
  [100,  54, 80],
  [120,  52, 80], 
  [130, 40, 79],
  [132,  10, 68],  
  [128,  -5, 20],  
  [110,  -14, 3],
  [0,  -19, -3]
];
path = nSpline(X, 150);
//polygon(points);

shape = airfoil_data(naca=NACA, L=30, N=100);
echo("---");
echo(shape);
echo("---");
//polygon(rot2D(shape, 90));
//polygon(shape);

//path_extrude(rot2D(shape, 90), vec2D(path, a=0, b=2), method = "NO_ANGLE"); 
path_extrude(rot2D(shape, 90-ATTACK), path, method = "NO_ANGLE"); 

//polygon(points_along_path3d(polyline(shape), path));
