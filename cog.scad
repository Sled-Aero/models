$fn = 100;

ballDiameter = 4.4;
ropeDiameter = 7.5;
numBalls = 12;
circumference = numBalls * (ballDiameter + ropeDiameter); 
diameter = circumference / PI;

ballRadius = ballDiameter / 2;
outerHeight = 1;
innerHeight = ballDiameter - (outerHeight / 2) * 2;
innerRadius = diameter / 2 - ballRadius;
outerRadius = innerRadius + ballDiameter;
spokeRadius = ballRadius * 1.75;
spokeHeight = innerHeight * 2 + outerHeight * 4;
spokeOffset = innerRadius + spokeRadius;

totalHeight = innerHeight + outerHeight * 2;
shaftHoleRadius = 2.7;
shaftHoleDiameter = shaftHoleRadius * 2;

difference() {
	union() {

		cylinder(h=outerHeight, r=outerRadius);
		
		translate([0, 0, outerHeight]) difference() {
			cylinder(h=innerHeight, r=innerRadius);
			translate([-innerRadius * 2 / 3, 0, innerHeight / 2]) cylinder(h=2 * innerHeight / 2, r=3);					
			translate([innerRadius * 2 / 3, 0, innerHeight / 2]) cylinder(h=2 * innerHeight / 2, r=3);
		}


		translate([0, 0, outerHeight]) {
			translate([-innerRadius * 2 / 3, 0, innerHeight / 2 + 0.4]) cylinder(h=innerHeight / 2, r=2.75);			
			translate([innerRadius * 2 / 3, 0, innerHeight / 2 + 0.4]) cylinder(h=innerHeight / 2, r=2.75);
		}

		translate([0, 0, outerHeight + innerHeight]) cylinder(h=outerHeight, r=outerRadius);

	};

	for (i = [0 : (360 / numBalls) : 360]) {
		translate([0, 0, -spokeHeight / 3]) {
			translate([spokeOffset * cos(i), spokeOffset * sin(i), 0]) cylinder(h=spokeHeight, r=spokeRadius);
		};
	}

	difference() {
		translate([0, 0, -totalHeight / 2]) cylinder(h=totalHeight * 2, r=shaftHoleRadius);
		translate([-shaftHoleDiameter / 2 + (shaftHoleDiameter * (4.6/5)), -shaftHoleDiameter / 2, -totalHeight / 3 * 2]) cube([shaftHoleDiameter, shaftHoleDiameter, totalHeight * 3]);
	};
}