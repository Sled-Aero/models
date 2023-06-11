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
flag_roof=false;
flag_frame=false;
flag_stays=false;
flag_wing_inner=false;
flag_wing_outer=false;
flag_drops=false;
flag_crossbar=false;
flag_plugs=false;
flag_back_pole=false;
flag_front_pole=false;

flag_engines=false;
flag_battery=false;
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
    mirror([flip ? 1 : 0,0]) {
        // wings
        translate([0,-5,-wing_h/2]) { 
            union() {
                // wing   
                difference() {
                    union() {
                        if (flag_wing_inner)
                            difference() {
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_w,wing_l],[0,wing_l],[0,20],[-wing_w,65]]);
                            }
                         
                        if (flag_wing_outer)    
                            translate([0.2-wing_w,70,0])
                                rotate([0,-12,0])
                                    difference() {
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[10-wing_w,100],[0,95],[0,-5],[20-wing_w,45]]);

                                    }
                               }
                    
                    if (flag_wing_inner || flag_wing_outer) {           
                        // pole hole
                        translate([-61.9,145.4,-2.37])
                            rotate([0,101.65,0]) {  
                                translate([0,0,-13])  
                                    linear_extrude(height=50) 
                                        circle(1.5);
                            }
                        
                        // hinge
                        translate([0,145.45,-2])
                            cylinder(4,4,4);
                        
                        // bolt holes   
                        wh=0.51;
                        wd=wing_h;
                        translate([-70,170,0]) {
                            rotate([0,0,0]) {
                                translate([2.2,-15,-0.02])    {
                                    cylinder(wd+0.03,wh,wh);
                                }
                                translate([2.2,-33,-0.02]){
                                    cylinder(wd+0.03,wh,wh);
                                }
                            }

                            rotate([0,-12,0]) {
                                translate([-2,-15,-0.05]) {
                                    cylinder(wd+0.03,wh,wh);
                                }
                                translate([-2,-33,-0.05]) {
                                    cylinder(wd+0.03,wh,wh);
                                }
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
                            translate([-4.7,-24.7,0.25])
                                rotate([0,101.65,0])
                                    linear_extrude(height=80) 
                                        circle(1.51);                                            
                            // bolt holes     
                            rotate([0,0,0]) {
                                translate([2.2,-15,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([2.2,-15,-10])                
                                    cylinder(20,dh,dh);
                                translate([2.2,-33,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([2.2,-33,-10])                
                                    cylinder(20,dh,dh);
                            }
                                               
                            rotate([0,-12,0]) {
                                translate([-2,-15,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2,-15,-10])                
                                    cylinder(20,dh,dh);
                                translate([-2,-33,2.5])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2,-33,-10])                
                                    cylinder(20,dh,dh);
                            } 
                        
                            // inner wing slice
                            translate([70,-170,0])
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_w,wing_l],[0,wing_l],[0,20],[-wing_w,65]]); 
                        
                            // outer wing slice
                            translate([70,-170,0])
                                translate([0.2-wing_w,70,0])
                                    rotate([0,-12,0])
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[10-wing_w,100],[0,95],[0,-5],[20-wing_w,45]]);
                        } 
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
mount_d=30.5; 

module floor() {
    difference() {
        linear_extrude(height=3, twist=0, scale=1) {
            fillet(r=5) union() {
                fillet(r=10) rounding(r=3.5) shell(d=-12) union() {
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
                    
                // bars
                translate([0,14.5])
                    for (i = [0 : 3])
                        translate([0,-i * mount_d])
                            polygon([[-floor_w,10],[floor_w,10],[floor_w,0],[-floor_w,0]]);
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
        }

        // front pole holes        
        translate([21,60,-2])
            rotate([20,0,0])
                linear_extrude(height=90) 
                    circle(1); 
        
        translate([-21,60,-2])
            rotate([20,0,0])
                linear_extrude(height=90) 
                    circle(1);    
    
        translate([0,0,-1]) linear_extrude(height=5) {
            // front hole
            translate([0,46.5])
               circle(1.5); 
            
            // 20 degrees pole plug holes
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
            
            // stays holes
            translate([21,-101.5])
                difference() {
                    union() {
                        circle(2.5);
                        translate([-2.5,-2.5,0])
                            square([5,2.5]);
                    }
                    translate([-2.5,-7,0])
                        square([5,5]);
               } 
               
            translate([-21,-101.5])
                difference() {
                    union() {
                        circle(2.5);
                        translate([-2.5,-2.5,0])
                            square([5,2.5]);
                    }
                    translate([-2.5,-7,0])
                        square([5,5]);
               } 
            
            // back holes
            translate([21,-95])
               circle(1.5);    
            translate([-21,-95])
               circle(1.5);
            translate([0,-101.5])
               circle(1.5);
            
            // mounting holes
            translate([0,-102.5]) 
                for (i = [0 : 5]) {
                    translate([mount_d/2,i * mount_d])
                       circle(1);    
                    translate([-mount_d/2,i * mount_d])
                       circle(1);
                }                
            
            // gutters
            translate([0,3.5]) 
                for (i = [0, 2]) {    
                translate([18,-i * mount_d]) {
                    translate([1.5,0,0]) circle(1.5);
                    square([3,32]);
                    translate([1.5,32,0]) circle(1.5);
                }
                translate([-21,-i * mount_d]) {
                    translate([1.5,0,0]) circle(1.5);
                    square([3,32]);
                    translate([1.5,32,0]) circle(1.5);
                }
            }
        }
    }
}


top_w=18;
top_l=80;
roof_h=1.5;

module roof() {
    translate([0,flag_flatten ? 0 : -27, flag_flatten ? 0 : 44.4])
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
                        translate([-10,52]) {
                            for (i = [0 : 4])
                                translate([0,-i * mount_d])
                                    square([20, 20]);
                        }
                    }

                // front holes    
                translate([13,71.2])
                   circle(1.5);    
                translate([-13,71.2])
                   circle(1.5);    
                    
                // back holes    
                translate([21,-68])
                   circle(1.5);    
                translate([-21,-68])
                   circle(1.5);
                translate([0,-76])
                   circle(1.5);    
     
                // mounting holes
                translate([0,-60])
                    for (i = [0 : 5]) {
                        translate([mount_d/2,i * mount_d])
                           circle(1);    
                        translate([-mount_d/2,i * mount_d])
                           circle(1);
                    }
            
                // gutters
                gutter_r=1.5;    
                translate([-12,-46.25])
                    for (i = [0 : 3])    
                        translate([0,i * mount_d]) {
                            translate([0,1.5,0]) circle(gutter_r);
                            square([24,3]);
                            translate([24,1.5,0]) circle(gutter_r);
                        }
            }
        }
}

module crossbar() {
    translate([0,0,20]) {
        rotate([0,90,0]) {
            // top
            translate([-14.3,47.52,-94]) {
                difference() {
                    union() {
                        // sleeve
                        translate([0,0,76])
                            linear_extrude(height=36) 
                                circle(3);
                        // pole
                        linear_extrude(height=188) 
                            circle(1.5);
                    }
                    // holes
                    rotate([0,90,0]) {
                        translate([-107,0,-5])
                            cylinder(4,1,1);
                        translate([-81,0,-5])
                            cylinder(4,1,1);
                    }
                }
            }
        }
    }
}

module 20pole() {
    translate([0,0,-10])
        linear_extrude(height=170) 
            circle(frame_pole_r);  
}

module stay() {
    difference() {
        linear_extrude(height=4) {
            difference() {
                circle(frame_pole_r+1); 
                circle(frame_pole_r);
            }
        }
        translate([0,-1,2]) 
            rotate([90,0,0])
                cylinder(3,0.75,0.75); 
    }
}

module back_pole() {
    difference() {
        translate([0,-95,3])
            rotate([0,0,0]) 
                linear_extrude(height=41.4) 
                    difference() {
                        circle(3); 
                        circle(1); 
                    }
        
        // pole holes            
        translate([0,-90,1.5]) {           
            translate([0,-3.3,7])
                rotate([290,11,4])    
                    20pole();  
            translate([0,-3.3,12])
                rotate([290,24,8.3])    
                    20pole(); 
            translate([0,-3.3,17])
                rotate([290,36,12])    
                    20pole(); 
            translate([0,-3.3,22])
                rotate([290,44,14])    
                    20pole();
            translate([0,-3.3,27])
                rotate([290,52,15.8])    
                    20pole();
        }
    }
}

module front_pole() {
    // front vertical pole
    union() {
        translate([0,60,0]) {
            difference() {
                rotate([20,0,0]) {
                    translate([0,-0.7,1.5]) {
                        // pole
                        linear_extrude(height=63) 
                            difference() {
                                circle(3); 
                                circle(1); 
                            }
                        
                        // extension of hole (debugging) 
                        /* translate([0,0,-20])
                            linear_extrude(height=80) 
                                circle(1); */
                    }
                }
                    
               // crossbar
                rotate([20,0,0]) {
                    translate([0,-0.7,1.5])
                        rotate([90,0,270])
                            translate([0,42.7,-88])
                            linear_extrude(height=188) 
                                circle(1.5);
                        }
                
                // clip end of pole        
                translate([0,-1.5,0]) {
                    cylinder(3,5,5);             
             
//                // crossbar
//                rotate([90,0,270])
//                    translate([0,70,-88])
//                    linear_extrude(height=188) 
//                        circle(1.5);
                }
            }
        }           
    }
}

module frame() {
    // wing supports   
    translate([-21,0,0]) {
        // front vertical pole
        front_pole();
        
        // 20 degrees pole
        translate([0,-3.3,7])
            translate([0,-90,1.5])
                rotate([290,-11,-4]) {
                    20pole(); 
                    
                    translate([0,0,-10]) {                        
                        if (flag_stays)
                            translate([0,0,0.1]) 
                                stay();
                    }
            }
        
        // back vertical pole
        if (flag_back_pole) {    
            back_pole();
        }
    }
    translate([21,0,0]) {
        front_pole();     
                    
        // 20 degrees pole
        translate([0,-3.3,7])
            translate([0,-90,1.5])
                rotate([290,11,4]) {
                    20pole();                 
            }
        
        // back vertical pole
        if (flag_back_pole) {    
            back_pole();
        }
    }
}

module plug() {
    difference() {
        union() { 
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
        translate([2.5,92,1])  
            translate([0,-90,1.5])
                rotate([290,-11,-4]) {
                    linear_extrude(height=160) 
                        circle(frame_pole_r); 
                }  
        }     
}


// main starts here
if (flag_plugs) {
    translate([flag_flatten ? 23.5 : 0, flag_flatten ? 92 : 0, flag_flatten ? 1 : 0])
        translate([-23.5,-92,-1]) {
            for (i = [0 : 1])
                for (j = [0 : 2]) {
                    translate([i * 8.5, j * 7, 0]) {
                        plug();   
                    
                        // lugs
                        if (i > 0)
                            translate([-2.75,4,0.5])
                                rotate([0,90,0])
                                    cylinder(2,0.5,0.5);
                        if (j > 0)
                            translate([1,0.5,0.5])
                                rotate([90,0,0])
                                    cylinder(2,0.5,0.5);
                    }
                }
        }

    if (!flag_flatten) {  
        translate([18.5,-92,-1]) {   
            plug();
        }
    }
}


frame_pole_r=1.5;

if (flag_frame) {
    frame();
}

if (flag_flatten) {
    if (flag_stays) 
        for (i = [0 : 2])
            for (j = [0 : 2])
                translate([i * 6, j * 6, 0]) {
                    rotate([0,0,45])
                        stay();
                    
                    // lugs
                    if (i > 0)
                        translate([-4,0,2])
                            rotate([0,90,0])
                                cylinder(2,0.5,0.5);
                    if (j > 0)
                        translate([0,-2,2])
                            rotate([90,0,0])
                                cylinder(2,0.5,0.5);
                }
    
    if (flag_back_pole) {
        for (i = [0 : 1])
            for (j = [0 : 1]) 
                translate([i * 7, j * 7, 0]) {
                    translate([0,95,-3])
                        back_pole();
                    
                    // lugs
                    if (i > 0)
                        translate([-4.5,0,0.5])
                            rotate([0,90,0])
                                cylinder(2,0.5,0.5);
                    if (j > 0)
                        translate([0,-2.5,0.5])
                            rotate([90,0,0])
                                cylinder(2,0.5,0.5);
                }
    }
    
    if (flag_front_pole) {
        for (i = [0 : 1])
            for (j = [0 : 1]) 
                translate([i * 7, j * 7, 0]) {
                    translate([0,56,44])
                        rotate([-200,0,0])
                            difference() {
                                front_pole();
                                
                                // 20 degrees pole
                                translate([0,-3.3,7])
                                    translate([0,-90,1.5])
                                        rotate([290,11,4])
                                            20pole();
                            }
                                            
                    // lugs
                    if (i > 0)
                        translate([-4.5,0,0.6])
                            rotate([0,90,0])
                                cylinder(2,0.5,0.5);
                    if (j > 0)
                        translate([0,-2.5,0.6])
                            rotate([90,0,0])
                                cylinder(2,0.5,0.5);                            
                
        }
    }
}

if (flag_wing_inner || flag_wing_outer || flag_drops) {
    translate([-21,-90,flag_flatten ? 0 : frame_pole_r]) {   
        if (flag_flatten) {
            if (flag_drops) {
                for (i = [0 : 1]) {
                    translate([-56.5,-15,-8 * i]) 
                        wing(true);
                    translate([99,-15,-8 * i]) 
                        wing(false); 
                    translate([18.5,120,-8 * i]) 
                        rotate([0,90,0])
                            cylinder(5,0.5,0.5);
                }
                translate([21.5,120,-8]) 
                    cylinder(9,0.5,0.5);
            } else {
                if (flag_wing_inner) {
                    projection(cut=true)
                        translate([50,61,0.4])
                            wing(false);
  
                } 
                if (flag_wing_outer) {
                    difference() {
                        projection(cut=true) 
                            translate([-21,90,3.4])
                                rotate([0,12,0])                 
                                    translate([142,-68,12])
                                        wing(false);
                        fillet(r=100)
                        union() {
                            difference() {
                                projection(cut=true) 
                                    translate([-21,90,3.66])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                                projection(cut=true) 
                                    translate([-21,90,3.3])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                            }
                            difference() {
                                projection(cut=true) 
                                    translate([-21,90,2.9])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                                projection(cut=true) 
                                    translate([-21,90,3.3])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                            }
                        }
                    }
                }
            }
        } else {
            translate([0,-3.3,7])
                rotate([20,-11,-4]) {    
                    wing(false);
                }
        }
    }
    
    if (!flag_flatten) {
        translate([0,-3.3,7])
            translate([21,-90,frame_pole_r]) {
                rotate([20,11,4]) {    
                    wing(true);
                }
            }
    } 
}

if (flag_crossbar) {
    translate([0,-3.3,7])
        crossbar();
}

if (flag_floor) {
    if (flag_flatten) {
        difference() {
            projection(cut=true) 
                floor(); 
            fillet(r=20) union() {
                difference() {
                    projection(cut=true)
                       floor();
                    projection(cut=true)
                        translate([0,0,-3])
                           floor();
                }
                difference() {
                    projection(cut=true)
                        translate([0,0,-3])
                           floor();
                    projection(cut=true)              
                       floor();
                }
            }
        }
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
