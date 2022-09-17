use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

$fs=0.01;
$fa=3;
$fn=100;
  
copter_l = 310;
copter_w = 100;
copter_h = 75;
spar_w = 10;
spar_h = 15;
cabin_l=200;

back_h = 10;
front_h = 17;  
  
function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=200)
);

function positive(v) = [for(i = [0:len(v)-1])
  [max(v[i][0],0), max(v[i][1],0)]];



// body
b1 = [[0,0], [37.5,copter_h], [cabin_l,copter_h]];
b2 = [[cabin_l,copter_h], [copter_l,copter_h]];
b3 = [[copter_l,copter_h], [copter_l,copter_h-spar_h]];
b4 = [[copter_l,copter_h-spar_h], [225,copter_h-spar_h]];
b5 = [[225,copter_h-spar_h], [200,copter_h-spar_h], [175,copter_h-spar_h], [cabin_l,-20], [125,0], [100, 0], [75,0], [50,0], [25,0], [0,0]];


// cabin
//linear_extrude(height=copter_w)
//extrudeWithRadius(copter_w, 5, 5, 80)
//rotate_extrude(angle=10, convexity=4)
//  translate([200,0,0])

module cabin() {
//minkowski() {
  translate([-400,0,0])
    rotate([0,0,-7])
      rotate_extrude(angle=14,$fn=300)
        translate([400,0,0])
          mirror([1,0,0])
            rounding(r=7)
              polygon(points=concat(bzpoints(b1), bzpoints(b2), bzpoints(b3), bzpoints(b4), bzpoints(b5)));
  //sphere(4);
//}
}

cabin();






