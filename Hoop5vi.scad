thick = 5;
gap = 2;
magnets = 5;
magnet_h = 12.0;
magnet_r = 9.5;
magnet_gap = 44;
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon
height = magnet_h + 4;
disc_h = 2;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0]) {
        // top and bottom rings
        rotate_extrude() {
          translate([radius-2,magnet_r/2+1.8,0]) 
             circle(thick/2);
        }
        
        rotate_extrude() {
          translate([radius-2,0-magnet_r/2-1.8,0]) 
             circle(thick/2);
        }
               
        // struts
        rotate([0,90,90]) 
            for (i = [0 : (magnets*2-1)] )
            {
                rotate(i * 360 / magnets / 2, [1, 0, 0])
                translate([0, radius-thick/2, disc_h/2])
                rotate([180,0,0]) {
                    difference() {
                        cylinder(h=disc_h, r1=magnet_r, r2=magnet_r);
                        
                        // hole
                        translate([0,0,-10])
                            cylinder(h=30, r1=4, r2=4);
                    }
                }
            } 
    }

    translate([0,0,0]) {
        // magnets
        rotate([0,90,36]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-6, radius-2, 0])
                rotate([90,0,45]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1, r2=1);
                }
            }
                
        // magnets
        rotate([0,90,72]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-2.5, radius-10.5, 0])
                rotate([90,0,135])  {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1, r2=1);
                }
            }
    }  
}