// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>

use <utils/morphology.scad>

use <cabin8b.scad>

/* ----------------------------------------------------

Centre of wing lift:

30 .... 340
^         ^

30 + 310 * 3 / 5 = 216

Center of prop lift:
25 .... 365
^         ^

25 + 340 / 2 = 195

---

1. Fill the hole in the floor
2. Wing axles: 10mm
3. Back body: 14mm
4. All holes round
5. Worry about feet once we have motors to mount them on

------------------------------------------------------- */

$fs=0.1;
$fa=6;
$fn=100;

HAS_AXLES = false;
HAS_WINGS = true;
HAS_HATCH = true;
HAS_PROPS = false;
FLATTEN = false;
FLATTEN_TAIL = true;

REFINEMENT = 100;
ANGLE = 0;
NACA = 2414;
ATTACK = 5;
SCALE = 7;
FRONT_AXLE_R = 3.5; // 1.225;
REAR_AXLE_R = 4.9; // 1.225;

BW = 125;
BL = 1800 / BW * 5;
FW = BW-30;
FL = 1200 / (FW-10) * 5;

module rotate_about_pt(rot, pt) {
  translate(pt)
    rotate(rot)
      translate(-pt)
        children();   
}

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4], vec3D(v2)))) )   // rotate and translate
     v3];

module pie_slice(angle, radius, height) {
  rotate_extrude(angle=angle) square([radius, height]);
}

module fwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  X = [//L,  dx,      dy,  dz,    R
      [FL,   w*FW,    0,   l-5,   -ATTACK,  0],  
      [FL,   w*70,    0,   l-5,   -ATTACK,  0],
      [FL,   w*8,     0,   l-5,   -ATTACK,  0],
      [FL,   w*0.1,   0,   l-5,   -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT));
}

module front_wing(l, rot=0) {
  translate([0,7,30.5]) {
    rotate_about_pt([rot,0,0], [0,0,0]) {
      difference() {
        union() {
          if (HAS_WINGS)
            translate([30, 0.5, -39])
              fwing(l, 0);

//          if (!FLATTEN)
//            translate([BW + 1, 0, - 16])
//              prop(60, 1);
        }

        translate([30, 0, 0])
          rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);
      }
    }
  
    mirror([1, 0, 0]) {
      rotate_about_pt([rot,0,0], [0,0,0]) {
        difference() {
          union() {
            if (HAS_WINGS)
              translate([30, 0.5, -39])
                fwing(l, 0);

  //          if (!FLATTEN)
  //            translate([BW + 1, 0, - 16])
  //              prop(60, 1);
          }

          translate([30, 0, 0])
            rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);
        }
      }
    }
  }
}

module bwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  X = [//L,  dx,     dy,   dz,    R
      [BL,   w*BW*2,  0,   l-5,   -ATTACK,  0],  
      [BL,   w*100,  0,   l-5,   -ATTACK,  0],
      [BL,   0,    0,   l-5,  -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT));
}

module aframe_curved(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 30;
  X = [//L,  dx,   dy,    dz,    R
      [5,    -8,     2,   l+23,  0,  0],
      [25,   -2,    -1,   l+8,  0,  0],  
      [20,   20,   -10,    l+3,  0,  0],
      [12,   95,   -13,   l+35,  0,  0],
      [15,  106,   -17,   l+56,  0,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT/2));
}

module aframe(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 33;
  X = [//L,  dx,   dy,    dz,    R
      [0,    -5,    0,   l+13,  0,  0],
      [19,   0,    0,   l+7,  0,  0],
      [12,   40,    0,    l,  0,  0],
      [15,   95,    0,   l+11,  0,  0],
      [4,   102,    0,   l+20,  0,  0]
    ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs, orientation, REFINEMENT / 2));
}

module aframe_flat(w) {
  translate([106,0,0])
    rotate([270,-90,0])
      linear_extrude(height=2)
        rounding(r = 1)
        projection(cut = true)
          rotate([0, 90, 0])
            translate([0,-106,0])
              rotate([0, 0, 90])
                aframe(w);
}

module back_wing(l, rot) {
  rotate_about_pt([rot,0,0], [0,-78,-13]) {
    difference() {
      union() {
        if (HAS_WINGS)
          translate([-BW, 0.5, -21])
            bwing(l, 0);

        translate([0, - 96, - 280])
          rotate([0, 270, 0])
            translate([220, 30, 15])
              rotate([90, -20, 70])
                if (FLATTEN_TAIL) {
                  aframe_flat(1);
                } else {
                  aframe(1);
                }

//        if (!FLATTEN)
//          translate([BW + 1, 0, 2])
//            prop(60, 1);

        mirror([1, 0, 0]) {
          translate([0, - 96, - 280])
            rotate([0, 270, 0]) {
              translate([220, 30, 15]) {
                rotate([90, - 20, 70])
                  if (FLATTEN_TAIL) {
                    aframe_flat(1);
                  } else {
                    aframe(1);
                  }
              }
            }

//          if (!FLATTEN)
//            translate([BW + 1, 0, 2])
//              prop(60, 1);
        }
      }

      // back axle hole
      translate([-25, -78, -13])
        rotate([0, 90, 0]) {
          cylinder(50, REAR_AXLE_R, REAR_AXLE_R);
      }

      // wing spar hole
      translate([0, 0, 19])
        rotate([0, 90, 0]) {
          translate([0, 0, -BW]) cylinder(BW * 2, FRONT_AXLE_R, FRONT_AXLE_R);
        }
    }

    if (HAS_AXLES) {
      translate([0, 0, 19])
        rotate([0, 90, 0]) {
          translate([0, 0, -BW-20]) cylinder((BW+20) * 2, FRONT_AXLE_R, FRONT_AXLE_R);
        }

      translate([-20.5, -78, -13])
        rotate([0, 90, 0]) {
          cylinder(41, REAR_AXLE_R, REAR_AXLE_R);
        }
    }
  }
}

module drop_slice() {
  rotate([0,0,90])
    difference() {
      polygon(points = airfoil_data(30, N=REFINEMENT));
      square(100, 100); 
    }
}

module drop(w,h,l) {
  scale([w,h,l]) 
    translate([0,0,0]) {
      rotate_extrude(angle = 360, $fn=REFINEMENT)
        drop_slice();
    }
}

module prop(r,d=1) {
  if (HAS_PROPS)
    translate([0,0,-2]) {
      cylinder(12,3,3);
      sphere(3);
      cylinder(4, r, r);
    }
  
  difference() {
    drop(0.3,0.7,1.2*d);
    translate([-10,-10,(12+BL)*d])
      cube([20,20,40]);
  }
} 

//module housing(s) {
//  rotate([0,0,-ATTACK])
//    scale(s)
//      sphere(3);
//}

module naca_pole(h,w=12) {
  linear_extrude(height=h, twist=0, scale=1)
    polygon(points = airfoil_data(naca=NACA, L=w, N=REFINEMENT));
}

module scaled_front_wing(l, r=0) {
  rotate_about_pt([r-90, 0, 0], [0, 7, 30.5])
    difference() {
      rotate_about_pt([90, 0, 0], [0, 7, 30.5])
      difference() {
        front_wing(l, 0);
        translate([0, 11, -0.5]) rotate([0, 270, 0]) {
          quad_cabin(false, false, 250, 1.1, 1, 0.8);
        }
      }
      translate([0, 11, -0.5]) rotate([0, 270, 0]) {
        quad_cabin(false, false, 250, 1.1, 1, 0.8);
      }
    }
}

module nubbins(l) {
  difference() {
    front_wing(l, 0);
    translate([0, 11, -7]) rotate([0, 270, 0]) {
      quad_cabin(false, false, 250, 1.1, 1, 0.8);
    }
    scaled_front_wing(l, 0);
  }
}

rotate([270, 180, 0]) {
//rotate([0, 0, 0]) {

  rotate([0, 270, 0]) {
//    top_shell();
//    bottom_shell();
  }

  scale([1/SCALE,1/SCALE,1/SCALE]) {
    rotate([0, 270, 0]) {
      quad_cabin(HAS_HATCH, true, 250, 1.1, 1, 0.8);
    }

    if (FLATTEN) {
      translate([0,-1,-11.2])
        scaled_front_wing(1, ANGLE);
    } else {
      translate([0, -11.5, 1.5]) {
//        nubbins(1);

        scaled_front_wing(1, ANGLE);

        if (HAS_AXLES) {
          translate([-BW-20, 7, 30.5])
            rotate([0, 90, 0])
              cylinder((BW+20) * 2, FRONT_AXLE_R, FRONT_AXLE_R);
        }
      }
    }

    if (FLATTEN) {
      if (HAS_WINGS) {
        translate([0, 6, 0])
          back_wing(1, ANGLE);
      } else {
        projection(cut = true)
          translate([0,0,43])
            rotate([0,90,0])
                rotate([-20,0,20])
                  back_wing(1, ANGLE);
      }
    } else {
      translate([0, 106, 295])
        back_wing(1, ANGLE);
    }
  }
}

//if (FLATTEN) {
//  projection(cut = true)
//    rotate([90, 0, 0])
//      scale([1/SCALE,1/SCALE,1/SCALE])
//        translate([9,0,-32])
//          aframe_flat(1);
//}



  
