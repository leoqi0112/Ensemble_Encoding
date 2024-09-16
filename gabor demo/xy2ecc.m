function eccmat = xy2ecc(varargin)
%XY2ECC Converts x- and y-values into eccentricities.
%
%   ECCMAT = XY2ECC(BX ,BY) returns a matrix with the same size as BX and BY,
%   whose value is an eccentricity calculated from the given BX and BY.
%
%   Arguments:
%      BX - matrix containing x-values.
%      BY - matrix containing y-values.
%
%   See also BASE_XY.

	bx = pretina_arg(varargin, 1, mfilename, 'bx', [], {'numeric'}, {'real', 'finite', 'nonnan'});
	by = pretina_arg(varargin, 2, mfilename, 'by', [], {'numeric'}, {'real', 'finite', 'nonnan', 'size', size(bx)});

	eccmat = sqrt((bx .^ 2) + (by .^ 2));
end