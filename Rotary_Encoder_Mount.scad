include <../OpenSCAD_Lib/MakeInclude.scad>

shaftOD = 6;
shaftFlat = 5.48;
shaftFromFaceZ = 20;

faceOD = 38.3;
faceOpeningOD = 20.2;
faceOpeningZ = 5;

mountingHoles1CtrsDia = 13.8;
mountingHolesOD = 3.2; // m3
mountingHoleHeadRecessDia = 5.9; // m3 SH
mountingHoleThreadDepth = 4;
mountingScrewLen = 8;

mountZ = shaftFromFaceZ;

mountingScrewHeadRecessZ = mountingScrewLen - mountingHoleThreadDepth;

module itemModule()
{
	difference()
    {
        cylinder(d=faceOD, h=mountZ);
        tcy([0,0,-100], d=faceOpeningOD, h=200);

        for(a = [0, 120, 240])
        {
            rotate([0,0,a]) translate([mountingHoles1CtrsDia,0,])
            {
                tcy([0,0,-100], d=mountingHolesOD, h=200);
                tcy([0,0,mountingScrewHeadRecessZ], d=mountingHoleHeadRecessDia, h=200);
            }
        }
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
