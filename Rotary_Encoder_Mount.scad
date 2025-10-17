include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

shaftOD = 6;
shaftFlat = 5.48;
shaftFromFaceZ = 20;

faceOD = 38.3;
faceOpeningOD = 20.2 + 0.1;
faceOpeningZ = 5;

mountingHoles1CtrsDia = 13.9;
mountingHolesOD = 4; //3.2; // m3
mountingHoleHeadRecessDia = 6; // m3 SH
mountingHoleThreadDepth = 3.8;
mountingScrewLen = 8;

mountZ = shaftFromFaceZ + 1.8;
mountOD = faceOD;

mountingScrewHeadRecessZ = mountingScrewLen - mountingHoleThreadDepth;

sheaveZ = shaftFromFaceZ - faceOpeningZ;
sheaveDia = shaftOD + 2*4.4; // Aded 4.7mm for m3 set-screw.
echo(str("sheaveDia = ", sheaveDia));

stringHoleDia = 2;
stringGuideDeltaY = sheaveDia/2 + stringHoleDia*0.3;
stringGuideDeltaZ = 4.4;
stringGuideBottomZ = faceOpeningZ+sheaveZ/2-sheaveZ/2+stringGuideDeltaZ;
stringGuideTopZ = faceOpeningZ+sheaveZ/2+sheaveZ/2-stringGuideDeltaZ;
echo(str("stringGuideBottomZ = ", stringGuideBottomZ));
echo(str("stringGuideTopZ = ", stringGuideTopZ));

module mount()
{
	difference()
    {
        simpleChamferedCylinder(d=mountOD, h=mountZ, cz=1.3);

        tcy([0,0,-100], d=faceOpeningOD, h=200);
        translate([0,0,mountZ-faceOpeningOD/2-0.6]) cylinder(d2=30, d1=0, h=15);
        translate([0,0,-15+faceOpeningOD/2+1.2]) cylinder(d1=30, d2=0, h=15);

        // Mounting screw holes:
        for(a = [0, 120, 240])
        {
            rotate([0,0,a]) translate([mountingHoles1CtrsDia,0,0])
            {
                tcy([0,0,-100], d=mountingHolesOD, h=200);
                tcy([0,0,mountingScrewHeadRecessZ], d=mountingHoleHeadRecessDia, h=200);
                translate([0,0,mountZ-mountingHoleHeadRecessDia/2-0.6]) cylinder(d2=10, d1=0, h=5);
            }
        }

        // String guides:
        stringGuideHole(dY=stringGuideDeltaY, z=stringGuideBottomZ, angleFactor= 1);
        stringGuideHole(dY=stringGuideDeltaY, z=stringGuideTopZ,    angleFactor=-1);
    }
}

module stringGuideHole(dY, z, angleFactor)
{
    rotate([0,0,60]) translate([0, 0, z])  
    {
        translate([0, dY*angleFactor, 0]) rotate([0,-90,0]) 
        {
            cylinder(d=stringHoleDia, h=100);
            taperCrossover = 5;
            // Taper on the inside to be tangent with the face-opening:
            hull()
            {
                d2 = faceOpeningOD/2 - dY + stringHoleDia/2; // Tangent to face-opening.
                tcy([0,0,0], d=stringHoleDia, h=faceOpeningOD/2+taperCrossover-2);
                tcy([0,(d2/2-stringHoleDia/2)*angleFactor,0], d=d2, h=nothing);
            }
            // Taper on the outside to be "good looking":
            hull()
            {
                z2 = faceOpeningOD/2+taperCrossover;
                tcy([0,0,z2], d=stringHoleDia, h=8);
                tcy([0, 0, z2+5], d=8, h=nothing);
            }
        }
    }
}


module sheave()
{
    difference() 
    {
        union()
        {
            // Main body:
            cylinder(d=sheaveDia, h=sheaveZ);
            // Ends:
            translate([0,0,sheaveZ/2]) doubleZ() translate([0,0,-sheaveZ/2]) simpleChamferedCylinder(d=faceOpeningOD-1, h=3, cz=2.25);
        }
        rotate([0,0,180]) shaft(dd=0.2, z=20);
        // Set screw:
        translate([0,0,sheaveZ/2]) rotate([0,-90,0]) cylinder(d=2.9, h=100);
        
    }
}

module shaft(dd=0, z=shaftFromFaceZ)
{
    effDia = shaftOD + dd;
    difference()
    {
        cylinder(d=effDia, h=z);
        tcu([shaftFlat-shaftOD/2+dd/2, -20, -1], 40);
    }
}

module clip(d=0)
{
	// tcu([-200, -400-d, -10], 400);

    // rotate([0,0,60]) 
    // {
    //     tcu([-200,-200,stringGuideTopZ], 400);
    //     tcu([-200,0,stringGuideBottomZ], 400);
    // }
}

if(developmentRender)
{
    // display() sheave();
    // translate([0,0,-faceOpeningZ])
    // {
    //     displayGhost() mount();
    //     displayGhost() encoderGhost();
    // }

	display() mount();
    displayGhost() encoderGhost();
    displayGhost() translate([0,0,faceOpeningZ]) sheave();
}
else
{
	mount();
}

module encoderGhost()
{
    faceZ = 2.8;
    bodyOD = 38.5;
    bodyAndFaceZ = 35;
    bodyZ = bodyAndFaceZ - faceZ;

    tcy([0,0,-faceZ], d=faceOD, h=faceZ);
    tcy([0,0,-bodyAndFaceZ], d=bodyOD, h=bodyZ);
    simpleChamferedCylinder(d=20.2, h=faceOpeningZ, cz=0.2);
    rotate([0,0,180]) shaft();
}
