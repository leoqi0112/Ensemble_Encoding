function pixelmap = map_radial(varargin)
%MAP_RADIAL Generates a map of radially increasing values.
%
%   PIXELMAP = MAP_RADIAL(ROWS [,COLS] [,RATIO] [,TILT]) returns a ROWS-by-COLS
%   matrix, whose value increases from the center with a radial pattern.
%   The increment in the y-axis are determined by RATIO. The x- and y- axes will
%   be tilted by TILT degrees.
%
%   Arguments:
%      ROWS  - number of rows of the output matrix.
%      COLS  - number of columns, the same as ROWS if empty or not provided.
%      RATIO - aspect ratio of increments, 1 if empty or not provided.
%      TILT  - tilt angle of the x- and y- axes, 0 if empty or not provided.
%
%   See also MAP_RECTANGULAR, MAP_POLYGONAL.

	rows  = pretina_arg(varargin, 1, mfilename, 'rows',  [],   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	cols  = pretina_arg(varargin, 2, mfilename, 'cols',  rows, {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	ratio = pretina_arg(varargin, 3, mfilename, 'ratio', 1,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan', 'positive'});
	tilt  = pretina_arg(varargin, 4, mfilename, 'tilt',  0,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan'});

	[bx, by] = base_xy(cols, rows, tilt);
	pixelmap = xy2ecc(bx, by * ratio);
end