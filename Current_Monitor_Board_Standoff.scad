// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2025 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

$fn=360;

boardX = 13.2;
boardY = 31.6;
boardOffsetZ = 9.4;

holeCtrsX = 8.75;
holeDia = 3;

mountCornerDia = 3;
mountY = boardY;
mountX = boardX + mountCornerDia + 1;
mountZ = boardOffsetZ + 2;

module itemModule()
{
	difference()
    {
        translate([0, mountY/2, 0]) hull() doubleX() doubleY() 
        translate([(mountX-mountCornerDia)/2, (mountY-mountCornerDia)/2, 0]) 
            simpleChamferedCylinder(d = mountCornerDia, h = mountZ, cz = 1);

        // Board recess:
        tcu([-boardX/2, -50, boardOffsetZ], [boardX, 100, 100]);
        // Mounting holes:
        doubleX() tcy([holeCtrsX/2, 13.8, -10], d=holeDia, h=100);
        // Recesses for the terminal:
        hull() doubleX() tcy([4.42/2, 4.25, boardOffsetZ-3], d=3, h=100);
        // Recess for the pin connector:
        hull() doubleX() tcy([5/2, 28.2, -10], d=3.8, h=100);
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
