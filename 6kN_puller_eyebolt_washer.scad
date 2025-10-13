include <../OpenSCAD_Lib/MakeInclude.scad>

washerID = 16.5;
washerOD = 32;
washerShimX = 25.5;
washerShimZ = 0.4;

washerWingsX = 2;
washerWingsY = 12.2;
washerWingsZ = 3;

washerX = washerShimX + 2*washerWingsX;

module itemModule()
{
	difference()
	{
		cylinder(d=washerOD, h=washerShimZ);

		tcy([0,0,-1], d=washerID, h=2);
		doubleX() tcu([washerX/2, -50, -50], 100);
	}

	// Wings:
	#doubleX() tcu([washerShimX/2, -washerWingsY/2, 0], [washerWingsX, washerWingsY, washerWingsZ]);
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
