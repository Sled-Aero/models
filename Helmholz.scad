thick = 5;
radius = 40;
height = 10;
rim = 4;
holes = 48;

$fs = 0.01;
$fa=3;
echo(radius * 2);


difference()
{    
    difference() {
        cylinder(h=height, r=radius+rim, center=true);
        cylinder(h=height, r=radius-2, center=true);
    }

    difference() {
        cylinder(h=height-4, r=radius+rim, center=true);
        cylinder(h=height-4, r=radius, center=true);
    }

    rotate([0,90,0]) 
        for (i = [0 : (holes-1)] )
        {
            rotate(i * 360 / holes, [1, 0, 0])
            translate([0, radius, 0])
            rotate([90,0,0]) {
                //cylinder(h=10, r1=3, r2=3);
                cube([6,3,6], true);
            }
        }
}