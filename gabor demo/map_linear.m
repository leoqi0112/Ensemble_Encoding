function pixelmap = map_linear(varargin)
%MAP_LINEAR Generates a map of linearly increasing values.
%
%   PIXELMAP = MAP_LINEAR(ROWS [,COLS] [,TILT]) returns a ROWS-by-COLS matrix,
%   whose value increases as its location moves along the x-axis tilted by
%   TILT degrees. The element has value of 0 at the center of the output matrix.
%
%   Arguments:
%      ROWS - number of rows of the output matrix.
%      COLS - number of columns, the same as ROWS if empty or not provided.
%      TILT - tilt angle of the x-axis, 0 if empty or not provided.
%
%   See also MAP_SYMMETRIC.

	rows = pretina_arg(varargin, 1, mfilename, 'rows', [],   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	cols = pretina_arg(varargin, 2, mfilename, 'cols', rows, {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	tilt = pretina_arg(varargin, 3, mfilename, 'tilt', 0,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan'});

	pixelmap = base_xy(cols, rows, tilt);
end