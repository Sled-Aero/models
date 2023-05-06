
$fs=0.01;
$fa=6;
$fn=200;

GAP=7.1;
SPAN=51-GAP;
MSPAN=SPAN-3;
ARM=3;
L1=17;
L2=13;
LROT=16;
LLEG=17;

module rotate_about_pt(rot=0, x=0, y=0, z=0) {
  translate([x,y,z])
    rotate(rot)
      translate([-x,-y,-z])
        children();   
}

module fast_cylinder(l,r,d) {
  linear_extrude(height=l, true)
    difference() {
      circle(r);
      circle(r-d);
    }
}

module arm(l,r=ARM/2,d=0.3) {
  translate([0,0,-l/2])
    fast_cylinder(l,r,d);
}

module motor_old(l=5.5,r=3.5) {
  translate([0,l/2-ARM/2+0.2,0])
    rotate([90,0,0]) {
      cylinder(l,r,r);
    }
}

module motor(rot=0) {
  rotate([0,rot,0])
  scale([0.1,0.1,0.1])
    import("X6-G2-D30-fixed.stl", convexity=3);
}

module lid(d1,d2) {
  translate([0,0.8,0])
    rotate([90,0,0])
      linear_extrude(4.5,true) {
        intersection() {
          square(d1, true);
          rotate([0,0,45]) {
            square(d2, true);
          }
        }
      }
}

module leg(l1=10,l2=10,d=0.9) {
  translate([-LLEG,0,0]) {
    rotate([-90,0,0]) {
      fast_cylinder(l1,d,0.15);
      translate([0,0,l1-0.2])  
        rotate([0,-LROT,0])
          fast_cylinder(l2+0.2,d,0.15);  
    }
  }
}

module platform(d) {
  rotate([90,45,0])
    linear_extrude(0.3,true)
      square(d,true);
}

module foot(t=46,d=0.9) {
  translate([LLEG+sin(LROT)*10,t,0])
    rotate([0,45,0])
      translate([0.6,-sin(LROT),-t/0.81])
        fast_cylinder(46,d,0.15);  
}

module battery(h=10) {
 translate([0,-h/2-0.6,0])
   rotate([0,45,0]) {
     cube([15,h,15],true);
     
     translate([0,h/2+0.3,0])
       rotate([90,0,0])
       linear_extrude(0.3,true)
          square(17,true);
   }
}

translate([0,0,5.7706])
  rotate([-90,0,-45]) {
    translate([0,0,MSPAN/2+GAP])
      arm(MSPAN);
    translate([0,0,-MSPAN/2-GAP])
      arm(MSPAN);  
    rotate([0,90,0]) {
      translate([0,0,MSPAN/2+GAP])
        arm(MSPAN);
      translate([0,0,-MSPAN/2-GAP])
        arm(MSPAN);  
    }
    
    translate([0,0,SPAN+GAP]) {
      //motor(180);
      motor_old();
    }
    translate([0,0,-SPAN-GAP]) {
      //motor(0);
      motor_old();
    }
    translate([SPAN+GAP,0,0]) {
      //motor(270);
      motor_old();
    }
    translate([-SPAN-GAP,0,0]) {
      //motor(90); 
      motor_old();  
    }
        
    difference() {    
      lid(21.5,19);
      translate([0,-0.4,0])
        lid(21.1,18.6);
    }

    rotate([0,-90,0])
    leg(L1,L2);
    rotate([0,180,0])
      leg(L1,L2);
    foot(L1+L2);  

    rotate([0,180,0]) {
      rotate([0,-90,0])
      leg(L1,L2);
      rotate([0,180,0])
        leg(L1,L2);
      foot(L1+L2);  
    }

    translate([0,15,0]) {
      battery();
      platform(24);
    }
  }
  