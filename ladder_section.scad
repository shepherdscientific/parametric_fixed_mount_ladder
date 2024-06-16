eps = 0.01;
piperadius = 15;
baseplate_x = 175;
baseplate_y = 95;
section_depth = 110;
screwhole_offset = 15;
screwhole_radius = 2.5;
platethickness = 3;
section_depth_top = 100;
increment_delta=5;
//   35   - 0 
// bottom - top
increment=0;
section=section_depth_top+(increment_delta*increment);
echo(section);
translate([170,0,300])
ladder_section(section);
//ladder_section(270);
module ladder_section(section_depth){
    // ladder arm right
    translate([0, -230, 0])
       rotate([0, 90, 0]) cylinder(r=piperadius, h=section_depth);

    // curve right
    translate([eps, -210, 0])
    rotate([0,0,90])
       rotate_extrude(angle=180, convexity=10)
           translate([20, 0]) circle(piperadius);     
    translate([0,-170,0]) rotate([0,0,90])
    rotate_extrude(angle=90, convexity=10)
       translate([-20, 0,0]) circle(piperadius);

    // ladder midsection   
    translate([20, 150, 0])
       rotate([90, 0, 0]) cylinder(r=piperadius, h=320);

    //curve left
    translate([eps, 190, 0])
    rotate([0,0,90])
       rotate_extrude(angle=180, convexity=10)
           translate([20, 0]) circle(piperadius);
    translate([0,150,0]) rotate([0,0,0])
    rotate_extrude(angle=90, convexity=10)
       translate([20, 0]) circle(piperadius);

    // ladder arm left
    translate([0, 210, 0])
       rotate([0, 90, 0]) cylinder(r=piperadius, h=section_depth);

    // base plate left       
    translate([section_depth,210,-30]) rotate([0,90,0]) baseplate();

    // base plate right
    translate([section_depth,-230,-30]) rotate([0,90,0])
        baseplate();


    points = [[0,0], [80,0], [0,110]];
    translate([section_depth,210-platethickness/2,0]) rotate([90,90,180]) 
    linear_extrude(height=platethickness){
    polygon(points=points);
    }

    translate([section_depth,-230-platethickness/2,0]) rotate([90,90,180]) 
    linear_extrude(height=platethickness){
    polygon(points=points);
    }


    module baseplate(){
    linear_extrude(height=platethickness){
        difference(){
                roundedplate();
                translate([baseplate_x/2-screwhole_offset,baseplate_y/2-screwhole_offset,0]) circle(screwhole_radius);
                translate([baseplate_x/2-screwhole_offset,-
                baseplate_y/2+screwhole_offset,0]) circle(screwhole_radius);
                translate([-baseplate_x/2+screwhole_offset,baseplate_y/2-screwhole_offset,0]) circle(screwhole_radius);
                translate([-baseplate_x/2+screwhole_offset,-baseplate_y/2+screwhole_offset,0]) circle(screwhole_radius);
            }
        }
    }

    module roundedplate(){
    minkowski()
    {
        square([baseplate_x,baseplate_y],center=true);
        circle(r = 10);
    }
    }
}