$fs=0.1;
$fa=6;
$fn=200;

difference() {
    cylinder(2.54, 55.6/2, 54.7/2);
    cylinder(2.54, 2.6, 5);
}

translate([0,0,2.54]) {
        intersection() {
        difference() {
            cylinder(14.84 - 2.54, 44.6 / 2, 43.3 / 2);
            cylinder(14.84 - 2.54, 37.6 / 2, 37.1 / 2);
        }

    r = (37.6 + 43.3) / 4 - 5;
    rotate_extrude(angle = 205, convexity = 0)
        translate([r, 0]) square(13);
}


rotate([0,0,90]) {
    translate([(36.45 - 4.88) / 2, 0, - 7.76 - 2.54])
        cylinder(7.76, 4.69 / 2, 4.88 / 2);
    translate([- (36.45 - 4.88) / 2, 0, - 7.76 - 2.54])
        cylinder(7.76, 4.69 / 2, 4.88 / 2);
}

//        steps = 60;
//        degrees = 270;
//        r = (37.6 + 43.3) / 4;
//        for (i = [0 : (steps - 1)]) {
//            rotate(i * degrees/steps * degrees / 360, [0, 0, 1]) {
//                translate([r, 0, 0])
//                    cylinder(14.84 - 2.54, 2.3, 1.8);
//            }
//        }
//    }
}
