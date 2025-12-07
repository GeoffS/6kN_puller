// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2025 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

boardX = 13;
boardOffsetZ = 9.4;

holeCtrsX = 8.75;
holeDia = 3;

terminalRecessCtrsX = 4.42;

mountY = 25;
mountX = 13 + 4;
mountZ = boardOffsetZ + 2;
mountCornerDia = 3;

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
        hull() doubleX() tcy([terminalRecessCtrsX/2, 4.25, boardOffsetZ-2], d=3, h=100);
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
