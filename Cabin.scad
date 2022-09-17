use <lib/Round-Anything/polyround.scad>
use <utils/morphology.scad> 

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

$fs=0.01;
$fa=3;
$fn=100;
  
  
function bzpoints(bezier) = (
  bezier_polyline(bezier, N=len(bezier)-1, splinesteps=200)
);

function positive(v) = [for(i = [0:len(v)-1])
  [max(v[i][0],0), max(v[i][1],0)]];


module egg() {
  difference() {
    rotate([0,0,-7]) {
      scale([1.5,0.4,0.6])
        difference() {
          sphere(50);
          translate([-100,-50,-50])
            cube([100,100,100]);
        }  
        
      translate([1,0,0])  
        mirror([1,0,0])
          scale([0.8,0.4,0.6])
            difference() {
              sphere(50);
              translate([-100,-50,-50])
                cube([100,100,100]);
            }    
     }     
   }
}


module egg2() {
b1 = [[0,0], [50,66], [-24,60], [-10,70], [0,0]]; 
//polygon(points=bzpoints(b1)); 

difference() {
  translate([0,-4,0])
    rotate([-10,-90,0])
      rotate_extrude() 
        polygon(points=positive(bzpoints(b1))); 
  
  translate([-120,-120,-60])
    cube([120,120,100]);
  }    
}

egg2();

