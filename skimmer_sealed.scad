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
flag_frame=true;
flag_stays=true;
flag_wing_inner=true;
flag_wing_outer=true;
flag_drops=true;
flag_tips=true;
flag_crossbar=true;
flag_plugs=true;
flag_back_pole=true;
flag_front_pole=true;

flag_engines=false;
flag_battery=false;
flag_flatten=false;

wing_lift=7;
wing_spread=21;
wing_attack_degrees=20;
wing_drop_degrees=5;
wing_camber_degrees=18;
wing_tip_degrees=18;
wing_tip_offset_degrees=5;

arm_l=75;
arm_w=5;

long_pole_r=1.5;
short_pole_r=3;

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


wing_l=160;
wing_wf=50;
wing_wb=15;
wing_w2=74;
wing_l1=150;
wing_l2=50;

// calculate rotation of outer wing
vert=(wing_wf-wing_wb) * sin(wing_camber_degrees);
hori1=sqrt(pow(wing_wf-wing_wb,2)+pow(wing_l1,2));
hori2=sqrt(pow(wing_wf-wing_wb,2)+pow(wing_l1,2));
angle=asin((vert/2)/hori1);
echo(angle*2);

wing_h=1.0;
tip_f=wing_l2/120;
    
module wing(flip) {
    mirror([flip ? 1 : 0,0]) {
        // wings
        translate([0,165-8.5,-wing_h/2]) { 
            union() {
                // wing   
                difference() {
                    union() {
                        if (flag_wing_inner)
                            difference() {
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_wf,0],[0,0],[0,-wing_l],[-10,-wing_l],[-wing_wb,-wing_l1]]);
                            }
                         
                        if (flag_wing_outer)    
                            translate([0.2-wing_wf,0,0])
                                rotate([angle*2.15,-wing_camber_degrees,-angle/3])
                                    difference() {
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[-wing_w2,5],[0,0],[wing_wf-wing_wb,-wing_l1],[-wing_w2,-wing_l2]]);

                                    }
                                 
                        if (flag_tips) {
                            translate([0.2-wing_wf,5,0])
                                rotate([angle*2.15,-wing_camber_degrees,-angle/3])
                                    translate([0.5-wing_w2,0,0.5]) {
                                        // mount
                                        translate([0,-55*tip_f,0.5])
                                            difference() {
                                                rotate([0,0,270]) rotate_extrude(angle=180) square([5,1]);
                                                translate([2.5,0,0])                
                                                    cylinder(2,0.8,0.8);
                                            }
                                        
                                        // mount
                                        translate([0,-100*tip_f,0.5])
                                            difference() {
                                                rotate([0,0,270]) rotate_extrude(angle=180) square([5,1]);
                                                translate([2.5,0,0])                
                                                    cylinder(2,0.8,0.8);
                                            }
                                        
                                        // tip    
                                        rotate([90,0,270])
                                            rotate([-wing_tip_degrees-wing_drop_degrees-wing_camber_degrees,0,0])
                                                rotate([0,0,wing_tip_offset_degrees])
                                                    translate([-7,-sin(wing_tip_offset_degrees)*120*tip_f,0])
                                                        scale([1.6*tip_f,2.1*tip_f,1])
                                                            linear_extrude(height=1.5, twist=0, scale=1)
                                                                polygon(points = airfoil_data(naca=[.0, .0, .18]));
                            }                        
                         }
                    }
                    
                    if (flag_wing_inner || flag_wing_outer) {           
                        // pole hole
                        rotate([0,wing_drop_degrees,0])  
                            translate([-wing_wf,5,0])
                                translate([1.5+wing_spread+wing_wf-crossbar_l/2,-24.25,-wing_h/1.5-wing_wf*sin(wing_drop_degrees)])
                                    crossbar();
                        
                        // hinge
                        translate([long_pole_r,-19.2,-2])
                            cylinder(4,4,4);
                        
                        // engine hole   
                        rotate([-wing_attack_degrees,2,0])                     
                            translate([0,-165,wing_h/2])
                                translate([-67.5,2.5,-75])    
                                    cylinder(engine_r, engine_r+1, engine_r+1);  
                        
                        // drop bolt holes   
                        wh=0.51;
                        wd=wing_h;
                        translate([0.1-wing_wf,5,-atan((wing_wb-wing_wf)/(wing_l1))]) {
                            rotate([0,0,0]) {
                                translate([2.1,-15,-0.02])    {
                                    cylinder(wd+0.03,wh,wh);
                                }
                                translate([2.1,-33,-0.02]){
                                    cylinder(wd+0.03,wh,wh);
                                }
                            }

                            rotate([0,-12,-atan((wing_wb-wing_wf)/(wing_l1))]) {
                                translate([-2.1,-15,-0.05]) {
                                    cylinder(wd+0.03,wh,wh);
                                }
                                translate([-2.1,-33,-0.05]) {
                                    cylinder(wd+0.03,wh,wh);
                                }
                            }  
                        }
                        
                        // tip bolt holes
                        translate([0.2-wing_wf,170+13,0])
                            rotate([0,-wing_camber_degrees,0]) 
                                translate([0.5-wing_w2,0,0.5]) {
                                    // hole
                                    translate([0,-55,-1])
                                        translate([2.5,0,-0.5])                
                                            cylinder(2,1,1);
                                    // hole
                                    translate([0,-100,-1])
                                        translate([2.5,0,-0.5])                
                                            cylinder(2,1,1);
                                }
                    }
                }
                
                // crossbar
                if (flag_crossbar && !flip) {
                    rotate([0,wing_drop_degrees,0])  
                        translate([-wing_wf,5,0])
                            translate([1.5+wing_spread+wing_wf-crossbar_l/2,-24.25,-wing_h/1.5-wing_wf*sin(wing_drop_degrees)])
                                crossbar();
                }
                
                // drop
                if (flag_drops) {
                    dh = 0.5;
                    translate([0.1-wing_wf,0,0]) {
                        difference() {
                            rotate([-0.5,0,-atan((wing_wb-wing_wf)/(wing_l1))])
                                translate([0,5,0])
                                scale([0.6,0.6,0.6])
                                    rotate([0,90,270])
                                        scale([0.42,0.8])
                                            rotate_extrude()
                                                rotate([0, 0, 90])
                                                    difference() {
                                                        polygon(points = airfoil_data(naca=NACA(30))); 
                                                        square(100, 100); 
                                                    }
                                      
                            // pole hole
                            translate([wing_wf,-170,0])
                                rotate([0,wing_drop_degrees,0])  
                                    translate([-wing_wf,170+5,0])
                                        translate([1.5+wing_spread+wing_wf-crossbar_l/2,-24.25,-wing_h/1.5-wing_wf*sin(wing_drop_degrees)])
                                            crossbar();                                        
                            // bolt holes     
                            rotate([0,0,-atan((wing_wb-wing_wf)/(wing_l1))]) {
                                translate([2.1,-15,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([2.1,-15,-10])                
                                    cylinder(20,dh,dh);
                                translate([2.1,-33,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([2.1,-33,-10])                
                                    cylinder(20,dh,dh);
                            }
                                               
                            rotate([0,-12,-atan((wing_wb-wing_wf)/(wing_l1))]) {
                                translate([-2.1,-15,2.6])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2.1,-15,-10])                
                                    cylinder(20,dh,dh);
                                translate([-2.1,-33,2.5])                
                                    cylinder(20,dh*2,dh*2);
                                translate([-2.1,-33,-10])                
                                    cylinder(20,dh,dh);
                            }
                        
                            // inner wing slice
                            translate([wing_wf,-170,0])
                                linear_extrude(height=wing_h, twist=0, scale=1)
                                    polygon([[-wing_wf,wing_l],[0,wing_l],[0,20],[-wing_wf,65]]); 
                        
                            // outer wing slice
                            translate([wing_wf,-170,0])
                                translate([0.2-wing_wf,wing_wf,0])
                                    rotate([0,-wing_camber_degrees,0])
                                        linear_extrude(height=wing_h, twist=0, scale=1)
                                            polygon([[10-wing_wf,100],[0,95],[0,-5],[20-wing_wf,45]]);
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
        translate([wing_spread,60,-2])
            rotate([20,0,0])
                linear_extrude(height=90) 
                    circle(1); 
        
        translate([-wing_spread,60,-2])
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
            translate([wing_spread,-101.5])
                difference() {
                    union() {
                        circle(2.5);
                        translate([-2.5,-2.5,0])
                            square([5,2.5]);
                    }
                    translate([-2.5,-7,0])
                        square([5,5]);
               } 
               
            translate([-wing_spread,-101.5])
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
            translate([wing_spread,-95])
               circle(1.5);    
            translate([-wing_spread,-95])
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
                translate([wing_spread,-68])
                   circle(1.5);    
                translate([-wing_spread,-68])
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

sleeve_l=36;
crossbar_l=2*(wing_spread+wing_wf*cos(wing_drop_degrees))+short_pole_r+long_pole_r+5-10*(1-wing_wb/wing_wf);
echo(crossbar_l);

module crossbar() {
    rotate([0,90,0]) {
        // top
        difference() {
            union() {
                // sleeve
                translate([0,0,(crossbar_l-sleeve_l)/2])
                    linear_extrude(height=sleeve_l) 
                        circle(short_pole_r);
                // pole
                linear_extrude(height=crossbar_l) 
                    circle(long_pole_r+0.01);
            }
            // holes
            rotate([0,90,0]) {
                translate([-crossbar_l/2-13,0,-5])
                    cylinder(4,1,1);
                translate([-crossbar_l/2+13,0,-5])
                    cylinder(4,1,1);
            }
        }
    }
}

module 20pole() {
    translate([0,0,-13.5]) {
        linear_extrude(height=170) 
            circle(long_pole_r);  
    
        if (flag_stays)
            translate([0,0,0.1]) 
                stay();
    }
}

module stay() {
    difference() {
        linear_extrude(height=4) {
            difference() {
                circle(long_pole_r+1); 
                circle(long_pole_r);
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
                        circle(short_pole_r); 
                        circle(1); 
                    }
        
        // pole holes            
        translate([0,-90,1.5]) {           
            translate([0,-3.3,7])
                rotate([270+wing_attack_degrees,11,4])    
                    20pole();  
            translate([0,-3.3,13])
                rotate([270+wing_attack_degrees,24,8.3])    
                    20pole(); 
            translate([0,-3.3,19])
                rotate([270+wing_attack_degrees,36,12])    
                    20pole(); 
            translate([0,-3.3,25])
                rotate([270+wing_attack_degrees,44,14])    
                    20pole();
            translate([0,-3.3,31])
                rotate([270+wing_attack_degrees,52,15.8])    
                    20pole();
        }
    }
}

module front_pole() {
    // front vertical pole
    union() {
        translate([0,60,0]) {
            difference() {
                rotate([wing_attack_degrees,0,0])
                    translate([0,-0.7,1.5]) {
                        // pole
                        linear_extrude(height=70) 
                            difference() {
                                circle(short_pole_r); 
                                circle(1); 
                            }
                        
                        // extension of hole (debugging) 
                        /* translate([0,0,-20])
                            linear_extrude(height=80) 
                                circle(1); */
                        }
                
                // clip end of pole        
                translate([0,-1.5,0]) {
                    cylinder(3,5,5);
                }    
            }
        }           
    }
}

module frame() {
    // wing supports   
    translate([-wing_spread,0,0]) {
        // front vertical pole
        front_pole();
        
        // 20 degrees pole
        translate([0,-90, wing_lift+long_pole_r])
            rotate([270,0,0])
                rotate([wing_attack_degrees,0,0])
                    20pole(); 
        
        // back vertical pole
        if (flag_back_pole) {    
            back_pole();
        }
    }
    translate([wing_spread,0,0]) {
        front_pole();     
                    
        // 20 degrees pole
        translate([0,-90, wing_lift+long_pole_r])
            rotate([270,0,0])
                rotate([wing_attack_degrees,0,0])
                    20pole();                 
           
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
                rotate([270+wing_attack_degrees,-11,-4]) {
                    linear_extrude(height=160) 
                        circle(long_pole_r); 
                }  
        }     
}


// main starts here
if (flag_plugs) {
    if (flag_flatten) 
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

    if (!flag_flatten) {  
        translate([18.5,-92,-1]) {   
            plug();
        }
    }
}


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
                        rotate([-180-wing_attack_degrees,0,0])
                            difference() {
                                front_pole();
                                
                                // 20 degrees pole
                                for (k = [0 : 6])
                                    translate([0,20*k,0])
                                        translate([0,-3.3,7])
                                            translate([0,-90,1.5])
                                                rotate([270+wing_attack_degrees,11,4])
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
    translate([-wing_spread-long_pole_r,-90,flag_flatten ? 0 : wing_lift+long_pole_r]) {   
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
                            translate([-wing_spread,90,3.4])
                                rotate([0,12,0])                 
                                    translate([142,-68,12])
                                        wing(false);
                        fillet(r=100)
                        union() {
                            difference() {
                                projection(cut=true) 
                                    translate([-wing_spread,90,3.66])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                                projection(cut=true) 
                                    translate([-wing_spread,90,3.3])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                            }
                            difference() {
                                projection(cut=true) 
                                    translate([-wing_spread,90,2.9])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                                projection(cut=true) 
                                    translate([-wing_spread,90,3.3])
                                        rotate([0,12,0])                 
                                            translate([142,-68,12])
                                                wing(false);
                            }
                        }
                    }
                }
            }
        } else {
            rotate([wing_attack_degrees,0,0])
                rotate([0,-wing_drop_degrees,0])  
                    wing(false);
                
        }
    }
    
    if (!flag_flatten) {
        translate([wing_spread+long_pole_r,-90, wing_lift+long_pole_r]) {
            rotate([wing_attack_degrees,0,0])
                rotate([0,wing_drop_degrees,0]) 
                    wing(true);
        }
    } 
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
