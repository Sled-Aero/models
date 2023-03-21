// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <cabin8a.scad>

/* ----------------------------------------------------

For some reason, this is the only version that renders!

------------------------------------------------------- */

$fs=0.01;
$fa=6;
$fn=200;

NACA = 2414;
ATTACK = 8;

module rotate_about_pt(rot, x, y, z) {
  translate([x,y,z])
    rotate(rot)
      translate([-x,-y,-z])
        children();   
}

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4], vec3D(v2)))) )   // rotate and translate
     v3];

module fwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  X = [//L,  dx,     dy,    dz,    R
      [55,   w*150,  -20,   l-5,   -ATTACK,  0],  
      [55,   w*100,  -12,   l-5,  -ATTACK,  0],
      [55,   w*30,    0,    l-5,  -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module front_wing(l, rot=0) {
  rotate_about_pt([rot,rot*(-8/90),0],270,-20,41) {
    fwing(l, 0);
    translate([150,-22,12])
      prop(60,0.8);
  }
    
  mirror([1, 0, 0]) {
    rotate_about_pt([rot,rot*(-8/90),0],270,-20,41) {
      fwing(l, 0);
      translate([150,-22,12])
        prop(60,0.8);
    }
  }
}

module bwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  X = [//L,  dx,     dy,   dz,    R
      [55,   w*150,  0,   l-5,   -ATTACK,  0],  
      [55,   w*100,  0,   l-5,  -ATTACK,  0],
      [55,   0.01,    0,   l-5,  -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}

module back_wing(l, rot) {
  rotate_about_pt([rot,0,0],0,-6,35) {
    bwing(l, 0);
    translate([150,0,11])
      prop(60,2.02);
  }
  
  mirror([1, 0, 0]) {
    rotate_about_pt([rot,0,0],0,-6,35) {
      bwing(l, 0);
      translate([150,0,11])
        prop(60,2.02);
    }
  }
}

module drop_slice() {
  rotate([0,0,90])
    difference() {
      polygon(points = airfoil_data(30, N=300)); 
      square(100, 100); 
    }
}

module drop(w,h,l) {
  scale([w,h,l]) 
    translate([0,0,0]) {
      rotate_extrude(angle = 360, $fn=300)
        drop_slice();
    }
}

module prop(r,d=1) {  
  translate([0,0,-1]) {
    translate([0,0,-4])
      cylinder(12,3,3);
    cylinder(2,r,r);
  }
  
  difference() {
    drop(0.3,0.7,d);
    translate([-10,-10,90*d])
      cube(20);
  }
} 

module housing(s) {
  rotate([0,0,-ATTACK])
    scale(s)
      sphere(3);
}

module pole(h,w=12) {
  linear_extrude(height=h, twist=0, scale=1)
    polygon(points = airfoil_data(naca=NACA, L=w, N=100)); 
}

module aframe(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 30;
  X = [//L,  dx,     dy,   dz,    R
      [60,  0,   0,  l-20,   0,  0],  
      [32,   10,  0,   l-15,  0,  0],
      [10,   90,  0,   l+30,  0,  0],
      [0,   96,  0,   l+42,  0,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,100));
}


rotate([0,90,0]) {
  translate([0,32,0]) {
    union() {
      rotate([0,270,0]) {
        quad_cabin(250,1.1,1,0.8);
        
//        translate([50,-2,33])
//          housing([6,4,2]);
//        translate([50,-2,-33])
//          housing([6,4,2]);
          
        translate([230,40,20])
          rotate([90,-30,70])
            aframe(10);  
          
        translate([230,40,-20])
          rotate([90,30,70])
            aframe(10); 
      }
      
      translate([0,-5,18]) {
        front_wing(1,90);
      }
      
      translate([0,96,280]) {
        back_wing(1,90);
      }
    }
  }
}



  