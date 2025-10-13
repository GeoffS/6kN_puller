include <../OpenSCAD_Lib/MakeInclude.scad>

washerID = 16.5;
washerOD = 32;
washerX = 25;
washerZ = 0.3;

module itemModule()
{
	difference()
	{
		cylinder(d=washerOD, h=washerZ);

		tcy([0,0,-1], d=washerID, h=2);
		doubleX() tcu([washerX/2, -50, -50], 100);
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
