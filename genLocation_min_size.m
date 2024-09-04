function result = genLocation_min_size(amount, margin, wWidth, wHeight, min_size_choice)
%This function supports the min_size experiment generating appropriate
%coords
%   It also takes selected set for standard deviation

    % Separate means for left and right sides
    mu_left = min_size_choice(1);
    mu_right = min_size_choice(2);
    sigma = 25;

    % Generate normally distributed random numbers for both sides
    normal_distribution_left = mu_left + sigma * randn(amount, 1);
    normal_distribution_right = mu_right + sigma * randn(amount, 1);

    distribution_left = round(normal_distribution_left);
    distribution_right = round(normal_distribution_right);

    rects = zeros([2*amount, 4]);

    % Define boundary matrix
    xLoc = 0; yLoc = 0;
    xTemp_left = zeros([1 amount]); yTemp_left = zeros([1 amount]);
    xTemp_right = zeros([1 amount]); yTemp_right = zeros([1 amount]);
    
    for i = 1:amount
        validLocation = false;
        
        diam_left = distribution_left(i);
        diam_right = distribution_right(i);

        rad_left = diam_left/2;
        rad_right = diam_right/2;

        % Left side
        while ~validLocation
            xLoc = randi([margin, wWidth/2 - margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad_left && abs(yLoc - wHeight/2) > rad_left
                % Check the distance from other
                if all(sqrt((xTemp_left - xLoc).^2 + (yTemp_left - yLoc).^2) > (diam_left + distribution_left) / 2)
                    validLocation = true;
                end
            end
        end

        xTemp_left(i) = xLoc; yTemp_left(i) = yLoc;
        rects(i, :) = [xLoc - rad_left, yLoc - rad_left, xLoc + rad_left, yLoc + rad_left];
        
        validLocation = false;
        
        % Right side
        while ~validLocation
            xLoc = randi([wWidth/2 + margin, wWidth - margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad_right && abs(yLoc - wHeight/2) > rad_right
                % Check the distance from other
                if all(sqrt((xTemp_right - xLoc).^2 + (yTemp_right - yLoc).^2) > (diam_right + distribution_right) / 2)
                    validLocation = true;
                end
            end
        end

        xTemp_right(i) = xLoc; yTemp_right(i) = yLoc;
        rects(amount + i, :) = [xLoc - rad_right, yLoc - rad_right, xLoc + rad_right, yLoc + rad_right];
    end

    result = rects;

end