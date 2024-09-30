function result = genLocation_emotion(amount, margin, wWidth, wHeight, diam)
    % Oval shaped faces
    ratio = 1.585;
    width = diam;
    height = double(int16(width * ratio));
    rad = max(width, height) / 2;
    diam = sqrt((width / 2)^2 + (height / 2)^2) * 2;

    rects = zeros([2*amount, 4]);

    % Define boundary matrix
    xLoc = 0; yLoc = 0;
    xTemp_left = zeros([1 amount]); yTemp_left = zeros([1 amount]);
    xTemp_right = zeros([1 amount]); yTemp_right = zeros([1 amount]);
    
    for i = 1:amount
        validLocation = false;

        % Left side
        while ~validLocation
            xLoc = randi([margin, wWidth/2 - 2*margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                % Check the distance from other
                if all(sqrt((xTemp_left-xLoc).^2+(yTemp_left-yLoc).^2) > diam)
                    validLocation = true;
                end
            end
        end

        xTemp_left(i) = xLoc; yTemp_left(i) = yLoc;
        rects(i, :) = [xLoc - width / 2, yLoc - height / 2, xLoc + width / 2, yLoc + height / 2];
        validLocation = false;

        % Right side
        while ~validLocation
            xLoc = randi([wWidth/2 + 2*margin, wWidth - margin]);
            yLoc = randi([margin, wHeight - margin]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                % Check the distance from other
                if all(sqrt((xTemp_right-xLoc).^2+(yTemp_right-yLoc).^2) > diam)
                    validLocation = true;
                end
            end
        end

        xTemp_right(i) = xLoc; yTemp_right(i) = yLoc;
        rects(amount+i, :) = [xLoc - width / 2, yLoc - height / 2, xLoc + width / 2, yLoc + height / 2];
    end

    result = rects;

end
