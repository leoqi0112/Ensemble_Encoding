function result = genLocation_num(amount_left, amount_right, margin, wWidth, wHeight, diam)
%This function supports the dots_num experiment generating appropriate
%coords
    rects = zeros([amount_left+amount_right, 4]);

    % Define boundary matrix
    xLoc = 0; yLoc = 0;
    xTemp_left = zeros([1 amount_left]); yTemp_left = zeros([1 amount_left]);
    xTemp_right = zeros([1 amount_right]); yTemp_right = zeros([1 amount_right]);

    for i = 1:amount_left
        validLocation = false;
        rad = diam/2;

        % Left side
        while ~validLocation
            xLoc = randi([margin, wWidth/2 - margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                % Check the distance from other
                if all(sqrt((xTemp_left - xLoc).^2 + (yTemp_left - yLoc).^2) > diam)
                    validLocation = true;
                end
            end
        end

        xTemp_left(i) = xLoc; yTemp_left(i) = yLoc;
        rects(i, :) = [xLoc - rad, yLoc - rad, xLoc + rad, yLoc + rad];

    end

    for i = 1:amount_right
        validLocation = false;
        rad = diam/2;

        % Left side
        while ~validLocation
            xLoc = randi([wWidth/2 + margin, wWidth - margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                % Check the distance from other
                if all(sqrt((xTemp_right - xLoc).^2 + (yTemp_right - yLoc).^2) > diam)
                    validLocation = true;
                end
            end
        end

        xTemp_right(i) = xLoc; yTemp_right(i) = yLoc;
        rects(amount_left+i, :) = [xLoc - rad, yLoc - rad, xLoc + rad, yLoc + rad];

    end

    result = rects;
end