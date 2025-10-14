include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

washerID = 16.5;
washerOD = 32;
washerShimX = 25.5;
washerShimZ = 0.4;

washerWingsX = 2;
washerWingsY = 20;
washerWingsZ = 3;

washerX = washerShimX + 2*washerWingsX;

module itemModule()
{
	difference()
	{
		union()
		{
			cylinder(d=washerOD, h=washerShimZ);
			intersection() 
			{
				simpleChamferedCylinder(d=washerOD, h=washerWingsZ, cz=1);
				tcu([-100, -washerWingsY/2, 0], [200, washerWingsY, washerWingsZ]);
			}
		}

		tcy([0,0,-1], d=washerID, h=100);
		tcu([-washerShimX/2, -100, washerShimZ], [washerShimX, 200, 200]);
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
