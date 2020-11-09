use <utils/morphology.scad> // https://github.com/openscad/scad-utils
use <lib/Naca4.scad>

/*
 motor: https://www.geekbuying.com/item/Flywoo-NIN-1404-3750KV-2-4S-Brushless-Motor-For-FPV-Racing-RC-Drone-418014.html
 
 blade: https://www.banggood.com/2-Pairs-HQProp-T4X2_5-4025-4-Inch-2-blade-Durable-PC-Propeller-2CW+2CCW-for-RC-Drone-FPV-Racing-p-1590493.html?akmClientCountry=AU&rmmds=search&p=YQ270915554535201710&custlixnkid=731048&cur_warehouse=CN
*/

$fs=0.01;
$fa=3;
$fn=100;

flag_floor=false;
flag_roof=false;
flag_frame=false;
flag_wings=false;
flag_wing_inner=false;
flag_wing_outer=false;
flag_drops=true;
flag_crossbar=false;
flag_engines=false;
flag_battery=false;

flag_flatten=true;


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
wing_h=0.8;
    
module wing(flip) {
    mirror([flip,0])
        translate([0,0,flag_flatten ? -wing_h : -wing_h/2]) { 
            union() {
                // wing   
                difference() {
                    union() {
                        if (flag_wing_inner)
                            difference() {
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_w,wing_l],[0,wing_l],[0,30],[-wing_w,70]]);
                                // scoop
                                translate([-70,141.2,-2]) {
                                    scale([4,0.66,1])
                                        cylinder(14,2.3,2.3);
                                }  
                            }
                         
                        if (flag_wing_outer)    
                            translate([(flag_flatten ? -10 : 0.2)-wing_w,70,0])
                                rotate([0,flag_flatten ? 0 : -10,0])
                                    difference() {
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[-wing_w,90],[0,90],[0,0],[20-wing_w,40]]);
                                        // scoop
                                        translate([0,71.2,-2]) {
                                            difference() {
                                                scale([5,1,1])
                                                    cylinder(4,1.5,1.5);
                                                translate([-8.35,-2,0])
                                                    cube([4,4,4]);
                                            }
                                        } 
                                    }
                    }
                    
                    // hinge
                    if (flag_inner)
                        translate([0,141,-2]) {
                            cylinder(4,4,4);
                        }
                    
                    // wing holes
                    wh=0.6;
                    wd=wing_h;
                    translate([-70,165,0]) {
                        rotate([0,0,0]) {
                            translate([2.2,-15,-0.02])    {
                                cylinder(wd+0.03,wh,wh);
                            }
                            translate([2.2,-28,-0.02]){
                                cylinder(wd+0.03,wh,wh);
                            }
                        }

                        rotate([0,-10,0]) {
                            translate([-2,-15,-0.05]) {
                                cylinder(wd+0.03,wh,wh);
                            }
                            translate([-2,-28,-0.05]) {
                                cylinder(wd+0.03,wh,wh);
                            }
                        }  
                    }  
                }
                
                // drop
                if (flag_drops) {
                    dh = 0.5;
                    difference() { 
                        translate([-70,165,0]) {
                            difference() {
                                rotate([0,-5,0])
                                    scale([0.6,0.6,0.6])
                                        rotate([0,90,270])
                                            scale([0.4, 0.8])
                                                rotate_extrude()
                                                    rotate([0, 0, 90])
                                                        difference() {
                                                            polygon(points = airfoil_data(naca=NACA(30))); 
                                                            square(100, 100); 
                                                        }
                                               
                                rotate([0,0,0]) {
                                    translate([2.2,-15,2.6])                
                                        cylinder(20,dh*2,dh*2);
                                    translate([2.2,-15,-10])                
                                        cylinder(20,dh,dh);
                                    translate([2.2,-28,2.6])                
                                        cylinder(20,dh*2,dh*2);
                                    translate([2.2,-28,-10])                
                                        cylinder(20,dh,dh);
                                }
                                                   
                                rotate([0,-10,0]) {
                                    translate([-2,-15,2.6])                
                                        cylinder(20,dh*2,dh*2);
                                    translate([-2,-15,-10])                
                                        cylinder(20,dh,dh);
                                    translate([-2,-28,2.5])                
                                        cylinder(20,dh*2,dh*2);
                                    translate([-2,-28,-10])                
                                        cylinder(20,dh,dh);
                                }
                            }
                        }
                        translate([-74,141.1,1.1]) 
                            rotate([-9.6,101.7,-9.5])
                                linear_extrude(height=30) 
                                    circle(1.54);
                    }
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

module floor() {
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
}


top_w=18;
top_l=78;

module roof() {
    translate([0,flag_flatten ? 0 : -25, flag_flatten ? 0 : 38.5])
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
}


module crossbar() {
    translate([0,0,20]) {
        rotate([0,90,0]) {
            // top
            translate([-15.5,47.8,-93.5]) {
                difference() {
                    union() {
                        // pole
                        linear_extrude(height=187) 
                            circle(1.5);
                        
                        // padding tube
                        translate([0,0,75.5])
                            linear_extrude(height=36) 
                                circle(3);
                    }
                    // holes
                    rotate([0,90,0]) {
                        translate([-106.5,0,-5])
                            cylinder(10,1,1);
                        translate([-80.5,0,-5])
                            cylinder(10,1,1);
                    }
                }
            }
        }
    }
}


// main starts here
if (flag_frame) {
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
}

if (flag_wings || flag_drops) {
    translate([-21,-90,1.5]) {   
        if (flag_flatten) {
            translate([21,0,0])
                wing(0);
        } else {
            rotate([20,-11,-4]) {    
                wing(0);
            }
        }
    }
    
    /*
    if (!flag_flatten) {
        translate([21,-90,1.5]) {
            rotate([20,11,4]) {    
                wing(1);
            }
        }
    }*/
}

if (flag_crossbar) {
    crossbar();
}

if (flag_floor) {
    floor();
}

if (flag_roof) {
    roof();
}

if (flag_engines) {
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
}

if (flag_battery) {
    // battery
    battery_w=35;
    battery_l=105;
    battery_h=27;

    translate([-battery_w/2,-100,4])
        cube([battery_w,battery_l,battery_h]);
}
