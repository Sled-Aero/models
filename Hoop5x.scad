thick = 5;
gap = 2;
magnets = 5;
magnet_h = 12.0;
magnet_r = 9.5;
magnet_gap = 45;
radius = magnet_gap; 
height = magnet_h + 4;
disc_h = 3;
holes = 6;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0]) {
        // top and bottom rings
        rotate_extrude() {
          translate([radius-8.75-magnet_r/2,0]) 
             circle(thick/2);
        } 
        rotate_extrude() {
          translate([radius-0.4+magnet_r/2,0]) 
             circle(thick/2);
        }
               
        // struts
        rotate([0,90,90]) 
            for (i = [0 : (magnets*2-1)] )
            {
                rotate(i * 360 / magnets / 2, [1, 0, 0]) {
                    
                    translate([0, radius-thick/2-1, disc_h/2+3.8])
                        rotate([195,0,0]) {
                              cylinder(h=disc_h, r1=magnet_r+0.5, r2=magnet_r+0.5);
                        } 
                        
                    translate([0, radius-thick/2-4, disc_h/2+3])
                        rotate([195,0,0]) {
                              cylinder(h=disc_h, r1=magnet_r+0.5, r2=magnet_r+0.5);
                        }   
                }
                
            } 
    }

    translate([0,0,0]) {
        // magnets
        rotate([0,90,45]) 
            for (i = [0 : (magnets*2-1)] )
            {
                rotate(i * 360 / magnets / 2, [1, 0, 0])
                translate([0, radius-4.5, -1.7])
                rotate([magnet_h/2,0,0]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // screw
                    translate([0,0,-5])
                        cylinder(h=25, r1=1, r2=1);
                
                    rotate([0,180,90])    
                        for (i = [0 : holes-1] )
                            rotate(i * 360 / holes+30, [0, 0, 1])
                                translate([6.5, 0, 0])
                                    cylinder(h=disc_h, r1=2.5, r2=2.5);
                   
                }
                
            }
    }  
}