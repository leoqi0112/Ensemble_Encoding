function result = remove_background(img, chunkSize)
    % Ensure the image has 3 color channels (RGB)
    if size(img, 3) == 1
        img = repmat(img, [1 1 3]);
    end
    
    [rows, cols, ~] = size(img);
    imgRGBA = cat(3, img, 255 * ones(rows, cols, 'uint8'));  % Add alpha channel initialized as fully opaque

    % Process the image in chunks (split the image into patches)
    for rowStart = 1:chunkSize:rows
        for colStart = 1:chunkSize:cols
            % Define the patch size
            rowEnd = min(rowStart + chunkSize - 1, rows);
            colEnd = min(colStart + chunkSize - 1, cols);
            
            % Extract the patch
            patch = img(rowStart:rowEnd, colStart:colEnd, :);
            
            tolerance = 20;  % Adjust tolerance for detecting near-white pixels
            whiteMask = all(patch(:, :, 1:3) > 255 - tolerance, 3);  % Find white pixels
            
            grayPatch = rgb2gray(patch);  % Convert to grayscale
            edges = edge(grayPatch, 'Canny');  % Detect edges
            filledPersonMask = imfill(edges, 'holes');  % Fill the person region
            
            patchAlpha = 255 * ones(size(patch, 1), size(patch, 2), 'uint8');  % Initialize as fully opaque
            patchAlpha(whiteMask & ~filledPersonMask) = 0;  % Set alpha to 0 for white background
            
            imgRGBA(rowStart:rowEnd, colStart:colEnd, :) = cat(3, patch, patchAlpha);
        end
    end
    
    % Output the image matrix with transparency
    result = imgRGBA;
end


% function result = remove_background(img)
%     % Get the size of the image
%     [rows, cols, ~] = size(img);
% 
%     % Create an oval mask
%     % Assuming the oval is centered and fills most of the image
%     centerX = cols / 2;
%     centerY = rows / 2;
%     radiusX = cols / 2;
%     radiusY = rows / 2;
% 
%     % Create a meshgrid for the mask
%     [x, y] = meshgrid(1:cols, 1:rows);
% 
%     % Create the oval mask using the ellipse equation
%     ovalMask = ((x - centerX) / radiusX).^2 + ((y - centerY) / radiusY).^2 <= 1;
% 
%     % Convert the mask to uint8 and scale to match image intensity
%     alphaChannel = uint8(ovalMask * 255);
% 
%     % Initialize the image with an alpha channel
%     imgWithAlpha = uint8(zeros(rows, cols, 4));
% 
%     % Copy the RGB channels from the original image
%     imgWithAlpha(:,:,1:3) = img;
% 
%     % Copy the alpha channel
%     imgWithAlpha(:,:,4) = alphaChannel;
% 
%     % Return the resulting image with the alpha channel
%     result = imgWithAlpha;
% end