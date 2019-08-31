thick = 5;
gap = 2;
magnets = 5;
magnet_h = 12.0;
magnet_r = 9.75;
magnet_gap = 45;
radius = magnet_gap / sqrt((5 - sqrt(5))/2); // https://en.wikipedia.org/wiki/Pentagon
height = magnet_h + 4;
disc_h = 2;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    difference()
    {
        translate([0,0,0]) {
            //  rings
            cylinder(h=height+1, r=radius+0.5, center=true);

            difference() {
                cylinder(h=6, r=radius+magnet_r/2+1.5, center=true);
                cylinder(h=6, r=radius+magnet_r-7, center=true);
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
        cylinder(h=height*3, r=radius-thick-0.5, center=true);
    } 
        
    translate([0,0,0]) {
        // magnets
        rotate([0,90,0]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([0-magnet_h/2, radius - thick/2, 0])
                rotate([90,0,90]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1.5, r2=1.5);
                }
            }
                
        // magnets
        rotate([0,90,180]) 
            for (i = [0 : (magnets-1)] )
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([0, radius + magnet_h/2 - thick/2 - 0.5, 0])
                rotate([90,0,0])  {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=40, r1=1.5, r2=1.5);
                }
            }
        }   
}