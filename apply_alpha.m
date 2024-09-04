function appliedmap = apply_alpha(varargin)
%APPLY_ALPHA Blends two matrices based on the provided alpha map.
%
%   APPLIEDMAP = APPLY_ALPHA(GROUNDMAP, IMAGEMAP, ALPHAMAP) returns a matrix
%   with the same size as GROUNDMAP. IMAGEMAP is superimposed on the GROUNDMAP
%   to produce an APPLIEDMAP, and the opacity of the PIXELMAP is modulated by
%   the ALPHAMAP.  
%
%   Arguments:
%      GROUNDMAP - a background image matrix, filled with .5 if empty or not
%         provided. If a scalar value is provided, a uniform grayscale image
%         will be generated for the background.
%      IMAGEMAP  - a foreground image matrix.
%      ALPHAMAP  - an alpha map, whose values range from 0 (transparent) to
%         1 (opaque). If empty or not provided, the last layer of the IMAGEMAP
%         will be used as an ALPHAMAP.

	imagemap  = pretina_arg(varargin, 2, mfilename, 'pixelmap',  [], {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan'});
	alphamap  = pretina_arg(varargin, 3, mfilename, 'alphamap',  [], {'numeric'}, {'real', 'finite', 'nonnan', '2d'});
	if isempty(alphamap)
		alphamap = imagemap(:, :, end);
		imagemap = imagemap(:, :, 1:max(1, end - 1));
	else
		validateattributes(alphamap, {'numeric'}, {'size', [size(imagemap, 1), size(imagemap, 2)]}, mfilename, 'alphamap', 3);
	end
	groundmap = pretina_arg(varargin, 1, mfilename, 'groundmap', .5, {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan'});
	if isscalar(groundmap)
		groundmap = ones(size(imagemap)) * groundmap;
	else
		validateattributes(groundmap, {'numeric'}, {'size', size(imagemap)}, mfilename, 'groundmap', 1);
	end

	alphamap = repmat(alphamap, [1, 1, size(imagemap, 3)]);
	appliedmap = (imagemap .* alphamap) + (groundmap .* (1 - alphamap));
end