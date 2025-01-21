/*
This model is licensed under: Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International.
You can find this license here: https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en
*/

$fa = $preview ? .5 : .1;
$fs = $preview ? .5 : .1;

/* [General] */
// PLEASE TURN OFF BEFORE DOWNLOADING: previews a cross section of the adapter with annotations
preview = true;
// Pipe wall thickness in mm
thickness = 3; // [2:.1:256]
// Reduction section length
reduction_distance = 10; // [1:1:100]
/* [Side A] */
// Internal diameter side a
id_a = 45;
// Side a length
length_a = 40; // [10:.1:100]
// Fitting reduction in mm (to pressure fit a pipe into the hole, such as a vacume hose)
reduction_a = 1; // [0:.01:2]
// Fitting reduction distance in mm (to pressure fit a pipe into the hole, such as a vacume hose)
reduction_distance_a = 25; // [1:1:100]
// Chamfer outer edge side a
chamfer_a = 2; // [0:.1:10]

/* [Side B] */
// Internal diameter side b
id_b = 36;
// Side b length
length_b = 30; // [10:.1:100]
// Fitting reduction in mm (to pressure fit a pipe into the hole, such as a vacume hose)
reduction_b = 1; // [0:.01:2]
// Fitting reduction distance in mm (to pressure fit a pipe into the hole, such as a vacume hose)
reduction_distance_b = 25; // [1:1:100]
// Chamfer outer edge side b
chamfer_b = 3; // [0:.1:10]

od_a = id_a + thickness * 2;
od_b = id_b + thickness * 2;
total_l = length_a + length_a + reduction_distance;
assert(reduction_a < thickness, "Please reduce the reduction on side a, it can't exceed the thickness.");
assert(reduction_b < thickness, "Please reduce the reduction on side b, it can't exceed the thickness.");
assert(reduction_distance_a < length_a, "Please reduce the reduction distance on side a, it can't exceed the length.");
assert(reduction_distance_b < length_b, "Please reduce the reduction distance on side a, it can't exceed the length.");

// pipe generator
translate([ 0, 0, -total_l / 2 ])
color("green") difference()
{
	union()
	{
		// side a
		difference()
		{
			cylinder(h = length_a, d = od_a);
			translate([ 0, 0, -.01 ])
			cylinder(h = length_a + .02, d = id_a - reduction_a);
			if (reduction_a && reduction_distance_a)
			{
				translate([ 0, 0, -.01 ])
				cylinder(h = reduction_distance_a + .01, d1 = id_a, d2 = id_a - reduction_a);
			}
			// chamfer a
			if (chamfer_a > 0)
			{
				translate([ 0, 0, -.01 ])
				difference()
				{
					cylinder(h = chamfer_a + .01, d = od_a + .01);
					translate([ 0, 0, -.01 ])
					cylinder(h = chamfer_a + .02, d1 = od_a - chamfer_a * 2, d2 = od_a);
				}
			}
		}
		// side b
		translate([ 0, 0, length_a + reduction_distance ])
		difference()
		{
			cylinder(h = length_b, d = od_b);
			translate([ 0, 0, -.01 ])
			cylinder(h = length_b + .02, d = id_b - reduction_b);
			// side b reduction
			if (reduction_b && reduction_distance_b)
			{
				translate([ 0, 0, length_b - reduction_distance_b + .01 ])
				cylinder(h = reduction_distance_b + .01, d2 = id_b, d1 = id_b - reduction_b);
			}
			// chamfer b
			if (chamfer_b > 0)
			{
				translate([ 0, 0, length_b - chamfer_b - .01 ])
				difference()
				{
					cylinder(h = chamfer_b + .02, d = od_b + .01);
					translate([ 0, 0, -.01 ])
					cylinder(h = chamfer_b + .04, d1 = od_b, d2 = od_b - chamfer_a * 2);
				}
			}
		}
		// reduction
		translate([ 0, 0, length_a ])
		difference()
		{
			translate([ 0, 0, -.01 ])
			cylinder(h = reduction_distance + .02, d1 = od_a, d2 = od_b);
			translate([ 0, 0, -.02 ])
			cylinder(h = reduction_distance + .04, d2 = id_b - reduction_b, d1 = id_a - reduction_a);
		}
	}
	// Cross section?
	if (preview)
	{
		translate([ -100, -200, -1 ])
		cube([ 200, 200, 200 ]);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ANNOTATIONS, DON'T EDIT BELOW HERE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module arrow(l, t = undef, b = true, e = true, dist = 10, orientation = "z")
{
	$fs = .3;
	$fa = 12;
	lines = is_list(t) ? t : [t];
	rotate_text = [ orientation == "z" ? 0 : -90, orientation == "z" ? -90 : -90, orientation == "z" ? 90 : 0 ];
	rotate_arrow = [ orientation == "z" ? 0 : 180, orientation == "z" ? 0 : -90, orientation == "z" ? 0 : 0 ];
	vector = [ orientation == "z" ? -dist : 0, 0, orientation == "z" ? 0 : -dist ];
	arrow_d = min(l / 3, 1);
	translate(vector)
	{
		rotate(rotate_arrow)
		{
			color([ .5, .7, .9, .7 ])
			{
				translate([ 0, 0, arrow_d ])
				cylinder(h = l - 2 * arrow_d, d = .4);
			}
			color([ .7, .3, .3, .8 ])
			{
				translate([ 0, 0, l - arrow_d ])
				cylinder(h = arrow_d, d1 = arrow_d, d2 = 0);
				cylinder(h = arrow_d, d1 = 0, d2 = arrow_d);
			}

			line_h = dist < 0 ? -1 * dist : dist;
			line_vector = dist < 0 ? [ 0, -90, 0 ] : [ 0, 90, 0 ];

			color([ .6, .6, .6, .8 ])
			{
				rotate(line_vector)
				cylinder(h = line_h, d = .2);
				translate([ 0, 0, l ])
				rotate(line_vector)
				cylinder(h = line_h, d = .2);
			}
			if (t)
			{
				for (i = [0:1:len(lines) - 1])
				{
					vector_text = [ (dist < 0 ? 4 : -4) * (i + 1), 0, l / 2 ];
					color("white") translate(vector_text)
					rotate(rotate_text)
					linear_extrude(height = .1) text(lines[i], size = 2.5, halign = "center");
				}
			}
		}
	}
}

if (preview)
{
	translate([ 0, 0, -total_l / 2 ])
	{
		color("orange")
		{
			translate([ -max(od_a, od_b) / 2 - 20, 0, -total_l / 2 + 40 ])
			rotate([ 90, 0, 0 ])
			linear_extrude(height = .1) text("rendering preview", size = 3.5, halign = "right");
			translate([ -max(od_a, od_b) / 2 - 20, 0, -total_l / 2 + 34 ])
			rotate([ 90, 0, 0 ])
			linear_extrude(height = .1) text("please disable preview before", size = 3.5, halign = "right");
			translate([ -max(od_a, od_b) / 2 - 20, 0, -total_l / 2 + 28 ])
			rotate([ 90, 0, 0 ])
			linear_extrude(height = .1) text("printing/downloading", size = 3.5, halign = "right");
		}

		color("grey")
		{
			translate([ max(od_a, od_b) / 2 + 20, 0, -total_l / 2 + 28 ])
			rotate([ 90, 0, 0 ])
			linear_extrude(height = .1) text("Licensed under CC-BY-SA-NC", size = 3.5, halign = "left");
		}

		// General annotations
		// total length
		translate([ od_a / 2, 0, 0 ])
		arrow(total_l, str("total length=", total_l, "mm"), dist = -25);
		// thickness
		translate([ -od_a / 2, 0, 0 ])
		arrow(thickness, str("thickness=", thickness, "mm"), orientation = "x", dist = 5);

		left = -od_a / 2;
		side_b_z = length_a + reduction_distance;

		// Side a annotations
		// length side a
		translate([ left, 0, 0 ])
		arrow(length_a, str("length_a=", length_a, "mm"), dist = 5);
		// inner diameter side a
		translate([ -id_a / 2, 0, 0 ])
		arrow(id_a, str("id_a=", id_a, "mm"), orientation = "x", dist = 25);
		// outer diameter side a
		translate([ left, 0, 0 ])
		arrow(od_a, str("od_a=", od_a, "mm"), orientation = "x", dist = 35);
		if (reduction_a > 0 && reduction_distance_a > 0)
		{
			// reduction diameter side a
			translate([ -id_a / 2 + reduction_a / 2, 0, reduction_distance_a ])
			arrow(id_a - reduction_a,
			      t = [ str("@ reduction_a=", reduction_a, "mm"), str("id reduction to=", id_a - reduction_a, "mm") ],
			      orientation = "x", dist = 10);
			// reduction distance side a
			translate([ od_a / 2, 0, 0 ])
			arrow(reduction_distance_a, t = [ "reduction_distance_a", str("=", reduction_distance_a, "mm") ],
			      dist = -15);
		}
		// chamfer side a
		if (chamfer_a > 0)
			translate([ od_a / 2, 0, 0 ])
		arrow(chamfer_a, t = str("chamfer=", chamfer_a, "mm"), dist = -5);

		// Reduction annotations
		// reduction distance
		translate([ left, 0, length_a ])
		arrow(reduction_distance, str("reduction_distance=", reduction_distance, "mm"), dist = 15);

		// Side b annotations
		// length side b
		translate([ -od_a / 2, 0, side_b_z ])
		arrow(length_b, str("length_b=", length_b, "mm"), dist = 5);
		// inner diameter side b
		translate([ -id_b / 2, 0, length_a + reduction_distance + length_b ])
		arrow(id_b, str("id_b=", id_b, "mm"), orientation = "x", dist = -15);
		// outer diameter side b
		translate([ -od_b / 2, 0, side_b_z + length_b ])
		arrow(od_b, str("od_b=", od_b, "mm"), orientation = "x", dist = -25);
		if (reduction_b > 0 && reduction_distance_b > 0)
		{
			// reduction diameter side b
			translate(
			    [ -id_b / 2 + reduction_b / 2, 0, length_a + length_b + reduction_distance - reduction_distance_b ])
			arrow(id_b - reduction_b,
			      t = [ str("id reduction to=", id_b - reduction_b, "mm"), str("@ reduction_b=", reduction_b, "mm") ],
			      orientation = "x", dist = -10);
			// reduction distance side b
			translate([ od_b / 2, 0, length_a + reduction_distance ])
			arrow(reduction_distance_b, t = [ "reduction_distance_b", str("=", reduction_distance_b, "mm") ],
			      dist = -15);
		}
		// chamfer side b
		if (chamfer_b > 0)
			translate([ od_b / 2, 0, length_a + reduction_distance + length_b - chamfer_b ])
		arrow(chamfer_b, t = str("chamfer=", chamfer_b, "mm"), dist = -5);
	}
}
