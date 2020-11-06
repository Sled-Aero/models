use <utils/morphology.scad> // https://github.com/openscad/scad-utils
use <lib/ShortCuts.scad>
use <lib/Naca4.scad>

/*
 motor: https://www.geekbuying.com/item/Flywoo-NIN-1404-3750KV-2-4S-Brushless-Motor-For-FPV-Racing-RC-Drone-418014.html
 
 blade: https://www.banggood.com/2-Pairs-HQProp-T4X2_5-4025-4-Inch-2-blade-Durable-PC-Propeller-2CW+2CCW-for-RC-Drone-FPV-Racing-p-1590493.html?akmClientCountry=AU&rmmds=search&p=YQ270915554535201710&custlixnkid=731048&cur_warehouse=CN
*/

$fs=0.01;
$fa=3;
$fn=100;


arm_l=90;
arm_w=5;

module spoke() {
    polygon([[-arm_w,arm_l],[arm_w,arm_l],[arm_w,9],[-arm_w,9]]);
}


arm_pad=6;
arm_hole_r=3.5;
notch_w=1;
notch_l=7;

module arm() {
    difference() {
        fillet(r=5) { 
            union() {
                spoke();
                translate([arm_pad,-arm_pad]) circle(arm_pad);
                translate([-arm_pad,-arm_pad]) circle(arm_pad);
                translate([-arm_pad,arm_pad]) circle(arm_pad);
                translate([arm_pad,arm_pad]) circle(arm_pad);
            }
        }
        circle(arm_hole_r);
        for (i = [0 : 1])
            for (j = [0 : 1]) {
                hull() {
                    translate([i*12 - 6, j*12 - 6, 0])
                        circle(1);
                    translate([i*13 - 6.5, j*13 - 6.5, 0])
                        circle(1);
                }
            }
        polygon([[-notch_w,notch_l],[notch_w,notch_l],[notch_w,-notch_l],[-notch_w,-notch_l]]);
        polygon([[-notch_l,notch_w],[notch_l,notch_w],[notch_l,-notch_w],[-notch_l,-notch_w]]);
    }
}


wing_l=160;
wing_w=70;
    
module wing(flip, height) {
    mirror([flip,0])
        translate([0,0,-0.5]) { 
            difference() {
            union() {
                // drop 
                translate([105,165,-35])
                    scale([0.6, 0.6, 0.6])
                        rotate([0,30,0])
                            rotate([0,90,270])
                                scale([0.4, 0.8])
                                    rotate_extrude()
                                        rotate([0, 0, 90])
                                            difference() {
                                                polygon(points = airfoil_data(30)); 
                                                square(100, 100); 
                                            }
                
                // wing                        
                linear_extrude(height=height, twist=0, scale=1)
                    polygon([[-wing_w,wing_l],[0,wing_l],[0,30],[-wing_w,70]]);
                translate([0.2-wing_w,70,0])
                    rotate([0,-10,0])
                        linear_extrude(height=height, twist=0, scale=1)
                            polygon([[-wing_w,90],[0,90],[0,0],[20-wing_w,40]]);
                }

                // hinge
                translate([0,141,0]) {
                    cylinder(4,4,4);
                }
            }
        }
}   


engine_r=51.5; // (5" blades are 63.5 mm, 4" blades are 50.8mm)
engine_h=14.5 + 5.5 + 3; // motor + blade height + mount

module engine() {
    translate([0,0,10])
        difference() {
            scale([1,1,engine_h/10]) {
                    rotate_extrude() {
                      translate([engine_r+2,0]) 
                         circle(5);
                    } 
                }
            translate([0,0,-20])    
                cylinder(engine_r, engine_r, engine_r);   
        } 
}


floor_w=25;
floor_l=75;

// bottom floor
difference() {
    linear_extrude(height=3, twist=0, scale=1) {
        fillet(r=10) rounding(r=3.5) 
        union() {
            shell(d=-10)
                union() {
                    translate([56,120,0]) {
                        rotate([0,0,150])
                            spoke();
                    }
                    translate([-56,120,0]) {
                        rotate([0,0,-150])
                            spoke();
                    }
                    translate([90,-90,0]) {
                        rotate([0,0,90])
                            spoke();
                    }
                    translate([-90,-90,0]) {
                        rotate([0,0,-90])
                            spoke();
                    }

                    // floor
                    translate([0,-27.5])
                        polygon([[-floor_w,floor_l],[floor_w,floor_l],[floor_w,-floor_l],[-floor_w,-floor_l]]);
                }
                
                // bars
                translate([0,7])
                    polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                translate([0,-44])
                    polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                translate([0,-95])
                    polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                
                // supports
                translate([18,-85])
                    polygon([[0,0],[0,20],[15,0]]);
                translate([-18,-85])
                    polygon([[0,0],[0,20],[-15,0]]);
            }
            
    
        // arms    
        translate([56,120,0]) {
            rotate([0,0,150])
                arm();
        }
        translate([-56,120,0]) {
            rotate([0,0,-150])
                arm();
        }
        translate([90,-90,0]) {
            rotate([0,0,90])
                arm();
        }
        translate([-90,-90,0]) {
            rotate([0,0,-90])
                arm();
        }
    }

    // front holes        
    translate([21,60,-2])
        rotate([20,0,0])
            linear_extrude(height=56) 
                circle(1); 
    translate([-21,60,-2])
        rotate([20,0,0])
            linear_extrude(height=56) 
                circle(1);     

    linear_extrude(height=3) {
        // 20 degrees pole holes
        hull() {
            translate([21,-77.8])
                circle(2.5);
            translate([18.5,-86])
                square(5);
        }  
        translate([19.5,-91])
            square([3,6]);
        
        hull() {
            translate([-21,-77.8])
                circle(2.5);
            translate([-23.5,-85])
                square(5);
        }    
        translate([-22.5,-91])
            square([3,6]); 
        
        // back holes
        translate([21,-95])
           circle(1.5);    
        translate([-21,-95])
           circle(1.5);
        
        // mounting holes
        translate([15.5,13])
           circle(1);    
        translate([-15.5,13])
           circle(1);
        translate([15.5,44])
           circle(1);    
        translate([-15.5,44])
           circle(1);
        translate([15.5,-39])
           circle(1);    
        translate([-15.5,-39])
           circle(1);
    }
}

// pole plugs
translate([-23.5,-92,-1]) {   
    hull() {      
        linear_extrude(height=5) 
            square([5,7]); 
        translate([2.5,6,4.4])
            rotate([0,90,90])
                cylinder(1,2.5,2.5);
    }
    translate([-1,0,4])
        linear_extrude(height=1) 
            square([7,7]); 
}
translate([18.5,-92,-1]) {   
    hull() {      
        linear_extrude(height=5) 
            square([5,7]); 
        translate([2.5,6,4.4])
            rotate([0,90,90])
                cylinder(1,2.5,2.5);
    }
    translate([-1,0,4])
        linear_extrude(height=1) 
            square([7,7]); 
}

    
// wing supports   
translate([-21,0,0]) {
    // front vertical pole
    difference() {
        translate([0,60,0]) {
            rotate([20,0,0])
                linear_extrude(height=56.5) 
                    difference() {
                        circle(3); 
                        circle(1); 
                    } 
        }
        translate([0,60,-3])            
            cylinder(5,5,5);            
    }
    
    // 20 degrees pole
    translate([0,-90,1.5])
        rotate([290,-11,-4]) {
            linear_extrude(height=160) 
                circle(1.5); 
    }
    
    // back vertical pole
    translate([0,-95,3])
        rotate([0,0,0]) 
            linear_extrude(height=35.5) 
                difference() {
                    circle(3); 
                    circle(1); 
                }
}
translate([21,0,0]) {
    // front vertical pole
    difference() {
        translate([0,60,0]) {
            rotate([20,0,0])
                linear_extrude(height=56.5) 
                    difference() {
                        circle(3); 
                        circle(1); 
                    }
        }
        translate([0,60,-3])            
            cylinder(5,5,5);            
    }            
                
    // 20 degrees pole
    translate([0,-90,1.5])
        rotate([290,11,4]) {
            linear_extrude(height=160) 
                circle(1.5);                 
    }
    
    // back vertical pole
    translate([0,-95,3])
        rotate([0,0,0]) 
            linear_extrude(height=35.5) 
                difference() {
                    circle(3); 
                    circle(1); 
                }
}

// wings
translate([-21,-90,1.5]) {    
    rotate([20,-11,-4]) {    
        wing(0,1);
    }
}
translate([21,-90,1.5]) {
    rotate([20,11,4]) {    
        wing(1,1);
    }
}

// wing cross pole
translate([0,0,20]) {
    rotate([0,90,0]) {
        // top
        translate([-15.5,47.8,-94]) {
            difference() {
                union() {
                    // pole
                    linear_extrude(height=188) 
                        circle(1.5);
                    
                    // padding tube
                    translate([0,0,76])
                        linear_extrude(height=36) 
                            circle(3);
                }
                // holes
                rotate([0,90,0]) {
                    translate([-107,0,-5])
                        cylinder(10,1,1);
                    translate([-81,0,-5])
                        cylinder(10,1,1);
                }
            }
        }
    }
}

// top floor
top_w=18;
top_l=78;

translate([0,-25,38.5])
linear_extrude(height=1.5, twist=0, scale=1) {
    difference() {
        fillet(r=5) rounding(r=3.5) 
            difference() {
                union() {
                    translate([0,0])
                        polygon([[-top_w,top_l],[top_w,top_l],[top_w,-top_l],[-top_w,-top_l]]);
                    translate([-20,-70])
                       circle(6);
                    translate([20,-70])
                       circle(6);
                }
                translate([-10,25])
                   square([20, 35]);
                translate([-10,-20])
                   square([20, 35]);
                translate([-10,-65])
                   square([20, 35]);
            }

        // front holes    
        translate([13,73])
           circle(1.5);    
        translate([-13,73])
           circle(1.5);    
            
        // back holes    
        translate([21,-70])
           circle(1.5);    
        translate([-21,-70])
           circle(1.5);
            
        // mounting holes
        translate([13,-25])
           circle(1);    
        translate([-13,-25])
           circle(1);
        translate([13,20])
           circle(1);    
        translate([-13,20])
           circle(1);    
    }
}

/*
// engines 
translate([56,120,0]) {
    engine();
}
translate([-56,120,0]) {
    engine();
}
translate([90,-90,0]) {
    engine();
}
translate([-90,-90,0]) {
    engine();
}

// battery
battery_w=35;
battery_l=105;
battery_h=27;

translate([-battery_w/2,-100,4])
    cube([battery_w,battery_l,battery_h]);
*/
