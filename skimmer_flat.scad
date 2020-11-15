use <utils/morphology.scad> // https://github.com/openscad/scad-utils
use <lib/Naca4.scad>

/*
 motor: https://www.geekbuying.com/item/Flywoo-NIN-1404-3750KV-2-4S-Brushless-Motor-For-FPV-Racing-RC-Drone-418014.html
 
 blade: https://www.banggood.com/2-Pairs-HQProp-T4X2_5-4025-4-Inch-2-blade-Durable-PC-Propeller-2CW+2CCW-for-RC-Drone-FPV-Racing-p-1590493.html?akmClientCountry=AU&rmmds=search&p=YQ270915554535201710&custlixnkid=731048&cur_warehouse=CN
*/

$fs=0.01;
$fa=3;
$fn=100;

flag_floor=true;
flag_roof=true;
flag_frame=true;
flag_wing_inner=true;
flag_wing_outer=true;
flag_drops=true;
flag_crossbar=true;
flag_plugs=true;

flag_engines=false;
flag_battery=true;
flag_flatten=false;


arm_l=75;
arm_w=5;

module spoke() {
    polygon([[-arm_w,arm_l],[arm_w,arm_l],[arm_w,9],[-arm_w,9]]);
}


arm_pad=6;
arm_hole_r=4;
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
                    translate([i*11 - 5.5, j*11 - 5.5, 0])
                        circle(1.25);
                    translate([i*13 - 6.5, j*13 - 6.5, 0])
                        circle(1.25);
                }
                translate([7-14*i, 0, 0])
                    circle(1);
                translate([0, 7-14*i, 0])
                    circle(1);
            }
        polygon([[-notch_w,notch_l],[notch_w,notch_l],[notch_w,-notch_l],[-notch_w,-notch_l]]);
        polygon([[-notch_l,notch_w],[notch_l,notch_w],[notch_l,-notch_w],[-notch_l,-notch_w]]);
    }
}


wing_l=165;
wing_w=70;
wing_h=0.8;
    
module wing(flip) {
    mirror([flip ? 1 : 0,0])
        translate([0,-5,-wing_h/2]) { 
            union() {
                // wing   
                difference() {
                    union() {
                        if (flag_wing_inner)
                            difference() {
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_w,wing_l],[0,wing_l],[0,20],[-wing_w,65]]);
                                
                                // scoop
                                translate([-75,145.55,-2]) {
                                    scale([4,0.66,1])
                                        cylinder(14,2.3,2.3);
                                }  
                            }
                         
                        if (flag_wing_outer)    
                            translate([0.2-wing_w,70,0])
                                rotate([0,-12,0])
                                    difference() {
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[10-wing_w,100],[0,95],[0,-5],[20-wing_w,45]]);
                                        
                                        // scoop
                                        translate([-4.7,74,-1]) {
                                            hull() {
                                                translate([3,0.5,0])
                                                   cube([3,2.3,3]);
                                                cube([1,3,3]);
                                            }
                                        } 
                                    }
                    }
                    
                    // hinge
                    translate([0,145.5,-2])
                        cylinder(4,4,4);
                    
                    // bolt holes   
                    wh=0.6;
                    wd=wing_h;
                    translate([-70,170,0]) {
                        rotate([0,0,0]) {
                            translate([2.2,-15,-0.02])    {
                                cylinder(wd+0.03,wh,wh);
                            }
                            translate([2.2,-28,-0.02]){
                                cylinder(wd+0.03,wh,wh);
                            }
                        }

                        rotate([0,-12,0]) {
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
                    translate([-70,170,0]) {
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
                                      
                            // pole hole
                            translate([-4,-24.4,0.64])
                                rotate([-9.6,101.8,-10])
                                    linear_extrude(height=30) 
                                        circle(1.52);                                            
                            // bolt holes     
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
                                               
                            rotate([0,-12,0]) {
                                translate([-2,-15,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2,-15,-10])                
                                    cylinder(20,dh,dh);
                                translate([-2,-28,2.5])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2,-28,-10])                
                                    cylinder(20,dh,dh);
                            }
                        
                            // inner wing slice
                            translate([70,-170,0])
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_w,wing_l],[0,wing_l],[0,30],[-wing_w,70]]);
                        
                            // outer wing slice
                            translate([70,-170,0])
                                translate([0.2-wing_w,70,0])
                                    rotate([0,-12,0])
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[-wing_w,90],[0,90],[0,0],[20-wing_w,40]]); 
                        } 
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
floor_l=80;

module floor() {
    difference() {
        linear_extrude(height=3, twist=0, scale=1) {
            fillet(r=10) rounding(r=3.5) shell(d=-12)
                union() {
                    // spokes - smooth support for arms
                    translate([56,120,0]) {
                        rotate([0,0,150])
                            scale([1,1.2,1])
                                spoke();
                    }
                    translate([-56,120,0]) {
                        rotate([0,0,-150])
                            scale([1,1.2,1])
                                spoke();
                    }

                    translate([90,-105,0]) {
                        rotate([0,0,80])
                            spoke();
                    }
                    translate([-90,-105,0]) {
                        rotate([0,0,-80])
                            spoke();
                    } 

                    // floor
                    translate([0,-27.5])
                        polygon([[-floor_w,floor_l],[floor_w,floor_l],[floor_w,-floor_l],[-floor_w,-floor_l]]);
                    
                    // supports
                    translate([22,-90])
                        polygon([[0,0],[0,20],[10,0]]);
                    translate([-22,-90])
                        polygon([[0,0],[0,20],[-10,0]]);
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
                translate([90,-105,0]) {
                    rotate([0,0,80])
                        arm();
                }
                translate([-90,-105,0]) {
                    rotate([0,0,-80])
                        arm();
                }
                
                // bars
                translate([0,16]) {
                    polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                    translate([0,-31])
                        polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                    translate([0,-62])
                        polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
                    translate([0,-93])
                        polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
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

        linear_extrude(height=5) {
            // 20 degrees pole holes
            hull() {
                translate([21,-82])
                    circle(3.5);
                translate([17.5,-86])
                    square([7,4]);
            }  
            translate([18.5,-91])
                square([5,6]);
            
            hull() {
                translate([-21,-82])
                    circle(3.5);
                translate([-24.5,-86])
                    square([7,4]);
            }    
            translate([-23.5,-91])
                square([5,6]); 
            
            // back holes
            translate([21,-95])
               circle(1.5);    
            translate([-21,-95])
               circle(1.5);
            
            // mounting holes
            translate([0,-102.5]) {
                translate([15.5,0])
                   circle(1);    
                translate([-15.5,0])
                   circle(1);
                translate([15.5,31])
                   circle(1);    
                translate([-15.5,31])
                   circle(1);
                translate([15.5,62])
                   circle(1);    
                translate([-15.5,62])
                   circle(1);
                translate([15.5,93])
                   circle(1);    
                translate([-15.5,93])
                   circle(1);
                translate([15.5,124])
                   circle(1);    
                translate([-15.5,124])
                   circle(1);
                translate([15.5,155])
                   circle(1);    
                translate([-15.5,155])
                   circle(1);
            }
        }
    }
}


top_w=18;
top_l=80;
roof_h=1.5;

module roof() {
    translate([0,flag_flatten ? 0 : -27, flag_flatten ? 0 : 37.3])
        linear_extrude(height=roof_h, twist=0, scale=1) {
            difference() {
                fillet(r=5) rounding(r=3.5) 
                    difference() {
                        union() {
                            translate([0,0])
                                polygon([[-top_w,top_l],[top_w,top_l],[top_w,-top_l],[-top_w,-top_l]]);
                            translate([-20,-68])
                               circle(6);
                            translate([20,-68])
                               circle(6);
                        }
                        
                        // bars
                        translate([-10,25])
                           square([20, 35]);
                        translate([-10,-20])
                           square([20, 35]);
                        translate([-10,-65])
                           square([20, 35]);
                    }

                // front holes    
                translate([13,74.5])
                   circle(1.5);    
                translate([-13,74.5])
                   circle(1.5);    
                    
                // back holes    
                translate([21,-68])
                   circle(1.5);    
                translate([-21,-68])
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
            translate([-14.3,47.52,-93.5]) {
                difference() {
                    union() {
                        // padding tube
                        translate([0,0,75.5])
                            linear_extrude(height=36) 
                                circle(3);
                        // pole
                        linear_extrude(height=187) 
                            circle(1.5);
                    }
                    // holes
                    rotate([0,90,0]) {
                        translate([-106.5,0,-5])
                            cylinder(4,1,1);
                        translate([-80.5,0,-5])
                            cylinder(4,1,1);
                    }
                }
            }
        }
    }
}


// main starts here
if (flag_plugs) {
    translate([flag_flatten ? 23.5 : 0, flag_flatten ? 92 : 0, flag_flatten ? 1 : 0])
        difference() {
            translate([-23.5,-92,-1]) {   
                hull() {      
                    linear_extrude(height=5) 
                        square([5,6]); 
                    translate([2.5,5,4.4])
                        rotate([0,90,90])
                            cylinder(1,2.5,2.5);
                }
                translate([-1,0,4])
                    linear_extrude(height=1) 
                        square([7,6]);
                translate([-1,0,0])
                    linear_extrude(height=1) 
                        square([7,6]);
            } 
            
            // pole hole
            translate([-21,0,0])  
                translate([0,-90,1.5])
                    rotate([290,-11,-4]) {
                        linear_extrude(height=160) 
                            circle(frame_pole_r); 
                    }       
            
        }
    
    if (!flag_flatten) {  
        translate([18.5,-92,-1]) {   
            hull() {      
                linear_extrude(height=5) 
                    square([5,6]); 
                translate([2.5,5,4.4])
                    rotate([0,90,90])
                        cylinder(1,2.5,2.5);
            }
            translate([-1,0,4])
                linear_extrude(height=1) 
                    square([7,6]); 
            translate([-1,0,0])
                linear_extrude(height=1) 
                    square([7,6]);
        }
    }
}


frame_pole_r=1.5;

if (flag_frame) {
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
                    circle(frame_pole_r); 
        }
        
        // back vertical pole
        translate([0,-95,3])
            rotate([0,0,0]) 
                linear_extrude(height=34.3) 
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
                    circle(frame_pole_r);                 
        }
        
        // back vertical pole
        translate([0,-95,3])
            rotate([0,0,0]) 
                linear_extrude(height=34.3) 
                    difference() {
                        circle(3); 
                        circle(1); 
                    }
    }
}

if (flag_wing_inner || flag_wing_outer || flag_drops) {
    translate([-21,-90,frame_pole_r]) {   
        if (flag_flatten) {
            if (flag_drops) {
                translate([-90,0,0])
                    wing(false);
            } else {
                if (flag_wing_inner) {
                    projection(cut=true)
                        translate([50, 61, 0])
                            wing(false);
                } 
                if (flag_wing_outer) {
                    projection(cut=false)
                        translate([-21,90,0])
                            rotate([0,10,0])
                                translate([142,-68,12])
                                    wing(false);
                }
            }
        } else {
            rotate([20,-11,-4]) {    
                wing(false);
            }
        }
    }
    
    if (!flag_flatten) {
        translate([21,-90,frame_pole_r]) {
            rotate([20,11,4]) {    
                wing(true);
            }
        }
    } 
}

if (flag_crossbar) {
    crossbar();
}

if (flag_floor) {
    if (flag_flatten) {
        projection(cut=true) 
            floor();
    } else {
      floor();
    }
}

if (flag_roof) {
    if (flag_flatten) {
        projection(cut=true) 
            roof();
    } else {
      roof();
    }
}

if (flag_engines) {
    // engines 
    translate([56,120,0]) {
        engine();
    }
    translate([-56,120,0]) {
        engine();
    }
    translate([90,-105,0]) {
        engine();
    }
    translate([-90,-105,0]) {
        engine();
    }
}

if (flag_battery) {
    // battery
    battery_w=35;
    battery_l=105;
    battery_h=27;

    translate([-battery_w/2,-58,3])
        cube([battery_w,battery_l,battery_h]);
}
