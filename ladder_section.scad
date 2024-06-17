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
increment=28;
stepsperseg = 7;
bottom = 6; // bottom * increment + section_depth_top  
incline_deg = 89;
spacing = 300;
increment_auto = round(spacing / tan(incline_deg));
segment = true;
ladder = false;
if(!ladder){
    // display only a single baseplate not the ladder or steps
    // base plate
    translate([section_depth,210,-30]) rotate([0,90,0])
    baseplate();
    // art strut
    translate([section_depth,210-platethickness/2,0]) rotate([90,90,180])
    armstrut();
    // ladder arm left
    translate([0, 210, 0]) rotate([0, 90, 0]) 
    difference(){
        cylinder(r=piperadius, h=section_depth);
        cylinder(r=piperadius-3, h=section_depth-2);
    }
    
}else{
    if (!segment){
        // display a single section/step  with the increment value increment 
        section=section_depth_top+(increment_delta*increment);
        echo(section);
        translate([170,0,300])
        ladder_section(section);
    }else{
        // display a ladder segment with stepsperseg steps starting at increment bottom
        echo(increment_auto);
        translate([0,0,spacing*stepsperseg])
        ladder_segment(bottom - stepsperseg +1,bottom);
        echo(increment_auto);
    }
}
module ladder_segment(start, stop){
    sidebar_z_offset = spacing*(stepsperseg -1)+(bottom-stepsperseg+1)*spacing;
    sidebar_x_offset = -(bottom-stepsperseg)*increment_auto-(increment_auto*(stepsperseg-1));
    echo(sidebar_x_offset);
    translate([sidebar_x_offset,-230,-sidebar_z_offset]) rotate([0,90-incline_deg,0])
    cylinder(r=piperadius, h=spacing*(stepsperseg -1));
    translate([sidebar_x_offset,210,-sidebar_z_offset]) rotate([0,90-incline_deg,0])
    cylinder(r=piperadius, h=spacing*(stepsperseg -1));    
    for (i = [start:1:stop]){
        //do something(s)
        translate([-increment_auto*i,0,-spacing*i])
        ladder_section(section_depth_top+(increment_auto*i));
        echo(i,section_depth_top+(increment_auto*i));
    }
}
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
    
    // art strutd
    translate([section_depth,210-platethickness/2,0]) rotate([90,90,180]) 
    armstrut();

    translate([section_depth,-230-platethickness/2,0]) rotate([90,90,180]) 
    armstrut();

}

module armstrut(){
    points = [[15,0], [80,0], [15,110]];
    linear_extrude(height=platethickness){
    polygon(points=points);
    }
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