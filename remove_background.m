function result = remove_background(img)
    % Get the size of the image
    [rows, cols, ~] = size(img);

    % Create an oval mask
    % Assuming the oval is centered and fills most of the image
    centerX = cols / 2;
    centerY = rows / 2;
    radiusX = cols / 2;
    radiusY = rows / 2;

    % Create a meshgrid for the mask
    [x, y] = meshgrid(1:cols, 1:rows);

    % Create the oval mask using the ellipse equation
    ovalMask = ((x - centerX) / radiusX).^2 + ((y - centerY) / radiusY).^2 <= 1;

    % Convert the mask to uint8 and scale to match image intensity
    alphaChannel = uint8(ovalMask * 255);

    % Initialize the image with an alpha channel
    imgWithAlpha = uint8(zeros(rows, cols, 4));

    % Copy the RGB channels from the original image
    imgWithAlpha(:,:,1:3) = img;

    % Copy the alpha channel
    imgWithAlpha(:,:,4) = alphaChannel;

    % Return the resulting image with the alpha channel
    result = imgWithAlpha;
end