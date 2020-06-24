thick = 5;

magnets = 10;
magnet_h = 12.5;
magnet_r = 9.5;
magnet_gap = 44;
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon
height = magnet_h + 4;
disc_h = 2;
span = 26;
sleeve = 9;
gap = 3;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0]) {
        // top and bottom rings
        /*
        rotate_extrude() {
          translate([radius-2,magnet_h-thick+1.25,0]) 
             circle(thick/2);
        }
        
        rotate_extrude() {
          translate([radius-2,thick-magnet_h-1.25,0]) 
             circle(thick/2);
        }*/
               
        // struts
        rotate([0,90,90]) 
            for (i = [1 : magnets])
            {
                rotate((i-7) * 360/magnets, [1, 0, 0])
                translate([0, radius-thick/2, disc_h/2])
                rotate([180,0,0]) {
                    difference() {
                        cylinder(h=disc_h, r1=11, r2=11);
                        
                        // hole
                        translate([0,0,-10])
                            cylinder(h=30, r1=6.5, r2=6);
                    }
                }
            } 

        // spans
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([-8.5, radius-3, -span/2])
                rotate([0,0,90]) {
                    cylinder(h=span, r1=2, r2=2);
                }
            }
        rotate([0,90,0]) 
            for (i = [1 : magnets] )
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([8.5, radius-3, -span/2])
                rotate([0,0,90]) {
                    cylinder(h=span, r1=2, r2=2);
                }
            }
    }
    
    // mask   
    /*   
    rotate([0,90,90]) 
        for (i = [1 : magnets-1])
        {
            rotate((i-7) * 360/magnets, [1, 0, 0])
            translate([0, radius-thick/2, 12])
                rotate([180,0,0]) {
                    cylinder(h=24, r1=12, r2=12);
                }
        } 
    */ 
            
    translate([0,0,0]) {        
       // sleeves
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([-8.5, radius-3, -sleeve/2])
                rotate([0,0,90]) {
                    difference() {
                        cylinder(h=sleeve, r1=2.5, r2=2.5);
                        cylinder(h=sleeve, r1=1.2, r2=1.3);
                    }
                }
            }
            
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([8.5, radius-3, -sleeve/2])
                rotate([0,0,90]) {
                    difference() {
                        cylinder(h=sleeve, r1=2.5, r2=2.5);
                        cylinder(h=sleeve, r1=1.2, r2=1.3);
                    }
                }
            }    
       
        // gaps     
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([-8.5, radius-3, -sleeve/6])
                rotate([0,0,90]) {
                    cylinder(h=sleeve/3, r1=3, r2=3);
                }
            }
            
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([8.5, radius-3, -sleeve/6])
                rotate([0,0,90]) {
                    cylinder(h=sleeve/3, r1=3, r2=3);
                }
            }    
    }

/*
    // magnets            
    translate([0,0,0]) {
        rotate([0,90,36]) 
            for (i = [0 : (magnets-1)])
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-magnet_h/2, radius-2, 0])
                rotate([90,0,90]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=30, r1=1, r2=1);
                }
            }
        rotate([0,90,72]) 
            for (i = [0 : (magnets-1)])
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-magnet_h/2, radius-2, 0])
                rotate([90,0,90])  {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=30, r1=1, r2=1);
                }
            }
            
    }*/
}