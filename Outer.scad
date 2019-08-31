thick = 5;
gap = 2;
magnets = 17;
magnet_h = 2.0;
magnet_r = 2.0;
radius = (gap + magnet_r * 2) * magnets / 3.1415 / 2;
height = magnet_r * 4 + gap * 2 + 1;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    // cylinder
    difference() {
        cylinder(h=height, r=radius+thick, center=true);
        cylinder(h=height, r=radius, center=true);
    }
    // divots
    rotate([0,90,0]) 
        for (i = [0 : (magnets-1)] )
        {
            rotate(i * 360 / magnets, [1, 0, 0])
            translate([0, radius + magnet_h, 0])
            rotate([90,0,0]) 
                cylinder(h=magnet_h*2.2, r1=magnet_r+0.2, r2=magnet_r-0.1);
        }
}