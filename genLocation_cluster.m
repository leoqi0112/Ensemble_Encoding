function result = genLocation_cluster(amount, x1, x2, y1, y2, wWidth, wHeight, diam)
        % Make x and y the center of a mini screen
        % Define boundary matrix
        rects = zeros([amount 4]);
        xLoc = 0; yLoc = 0;
        xTemp = zeros([1 amount]); yTemp = zeros([1 amount]);
    
        for i = 1:amount
            validLocation = false;
    
            rad = diam/2;
    
            while ~validLocation
                xLoc = randi([x1,x2]);
                yLoc = randi([y1,y2]);
                % Check if the location is valid (not in the center circle)
                if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                    % Check the distance from other
                    if all(sqrt((xTemp-xLoc).^2+(yTemp-yLoc).^2) > diam)
                        validLocation = true;
                    end
                end
            end
    
            xTemp(i) = xLoc; yTemp(i) = yLoc;
            rects(i, :) = [xLoc - rad, yLoc - rad, xLoc + rad, yLoc + rad];
        end

        result = rects;

end