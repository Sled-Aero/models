use <box_wing.scad>
use <cabin3.scad>

$fs=0.01;
$fa=3;
$fn=100;


module prop(r) {
  translate([121,58,85]) {
    rotate([0,90,0])
      cylinder(6,6,6);
    translate([3,0,-12]) {
      translate([0,0,-4])
        cylinder(10,3,3);
      cylinder(2,r,r);
    }
  }
} 

union() {
/*
  // cabin
  translate([0,0,0])
    rotate([0,270,0])
      quad_cabin(250); 
*/    
  // front wing
  translate([0,-40,-70]) {
    front_wing();
    /*
    translate([0,0,0])
      prop(40);

    mirror([1, 0, 0]) {
      //front_wing();
      translate([0,0,0])
        prop(40);
    } */
  }


  // back wing 
  translate([0,-40,260]) {
    back_wing();
    /*
    translate([0,70,-160])
      prop(40);

    mirror([1, 0, 0]) {
      //back_wing();
      translate([0,70,-160])
        prop(40);
    } */
  } 

}
