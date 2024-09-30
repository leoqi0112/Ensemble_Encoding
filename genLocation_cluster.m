function result = genLocation_cluster(amount, x1, x2, y1, y2, wWidth, wHeight, diam, cluster_variety)
    % Define boundary matrix
    rects = zeros([amount 4]);
    xTemp = zeros([1 amount]); yTemp = zeros([1 amount]);
    
    for i = 1:amount
        validLocation = false;
    
        rad = diam/2;
        boundary_center_x = (x1 + x2) / 2;
        boundary_center_y = (y1 + y2) / 2;
    
        while ~validLocation
            % Generate points based on the boundary provided by x1, x2, y1, y2
            switch cluster_variety
                case 'tight'
                    % Use smaller standard deviation for tighter clusters within the boundary
                    xLoc = round(normrnd((x1+x2)/2, (x2-x1)/6));
                    yLoc = round(normrnd((y1+y2)/2, (y2-y1)/6));
                case 'spread'
                    % Use larger standard deviation for more spread clusters within the boundary
                    xLoc = round(normrnd((x1+x2)/2, (x2-x1)/3));
                    yLoc = round(normrnd((y1+y2)/2, (y2-y1)/3));
                case 'elongated'
                    % Create elongated clusters by controlling the spread in one direction
                    xLoc = round(normrnd((x1+x2)/2, (x2-x1)/4));
                    yLoc = round(normrnd((y1+y2)/2, (y2-y1)/8)); % More spread in y-direction
                otherwise
                    % Random selection within the boundary
                    xLoc = randi([x1, x2]);
                    yLoc = randi([y1, y2]);
            end
            
            % Ensure the location is within the boundary
            xLoc = max(min(xLoc, x2), x1);
            yLoc = max(min(yLoc, y2), y1);
    
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad + 20 && abs(yLoc - wHeight/2) > rad + 20
                % Check the distance from other points
                if all(sqrt((xTemp - xLoc).^2 + (yTemp - yLoc).^2) > 3/2 * diam)
                    validLocation = true;
                end
            end
        end
    
        xTemp(i) = xLoc; yTemp(i) = yLoc;
        rects(i, :) = [xLoc - rad, yLoc - rad, xLoc + rad, yLoc + rad];
    end

    % Post-process to align the average center with the boundary center
    avg_x = mean(xTemp);
    avg_y = mean(yTemp);
    
    shift_x = boundary_center_x - avg_x;
    shift_y = boundary_center_y - avg_y;
    
    xTemp = xTemp + shift_x;
    yTemp = yTemp + shift_y;
    
    % Update rects with the shifted coordinates
    for i = 1:amount
        rects(i, :) = [xTemp(i) - rad, yTemp(i) - rad, xTemp(i) + rad, yTemp(i) + rad];
    end

    result = rects;
end
