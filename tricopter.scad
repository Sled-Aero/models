
use <lib/BOSL/beziers.scad>
use <utils/morphology.scad> 

$fs=0.01;
$fa=3;
$fn=100;



linear_extrude(height=1) { 
    rounding(r=0.6) { 
         square([30,2.5]); 

         difference() { 
            {
            bez = [[0,10], [-10,10], [-24,0], [9,-19.3], [-10,0], [15,0]];
            closed = bezier_close_to_axis(bez);
            /* trace_bezier(closed, N=len(bez)-1); */
            bezier_polygon(closed, N=len(bez)-1, splinesteps=100);
            }
            translate([-27,-15]) square(30, 30);
        } 

        translate([2,0.8,0]) {
            bez = [[5, 0], [0,5], [-35,0], [0,-16], [5, 0]];
            bezier_polygon(bez, N=len(bez)-1, splinesteps=100);
        }
    }
}

