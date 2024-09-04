function result = genLocation(amount, choice, margin, wWidth, wHeight, diam)
    % Fuction to generate location matrix based on type of experiment

    if (choice == 1 || choice == 3)
        result = make_basic(amount, choice, margin, wWidth, wHeight, diam);
    end

    if (choice == 2)
        result = make_oval(amount, margin, wWidth, wHeight, diam);
    end

    if (choice == 4)
        diam_array = repmat(diam, 1, amount);
        result = gabors(amount, diam_array, [margin,margin,wWidth-margin,wHeight-margin]...
            , [wWidth/2-margin, wHeight/2-margin, wWidth/2+margin, wHeight/2+margin]);
    end

end

function result = make_basic(amount, choice, margin, wWidth, wHeight, diam)
    
    if (choice == 1)
        % Create standard distribution around diam with stdev of 25
        mu = diam;
        sigma = 25;

        % Generate normally distributed random numbers using randn
        normal_distribution = mu + sigma * randn(amount, 1);
        distribution = round(normal_distribution);
    end
    
    rects = zeros([amount 4]);

    % Define boundary matrix
    xLoc = 0; yLoc = 0;
    xTemp = zeros([1 amount]); yTemp = zeros([1 amount]);
    
    for i = 1:amount
        validLocation = false;
        
        if (choice == 1)
            diam = distribution(i);
        end

        rad = diam/2;

        while ~validLocation
            xLoc = randi([margin,wWidth-margin]);
            yLoc = randi([margin,wHeight-margin]);
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

function result = make_oval(amount, margin, wWidth, wHeight, diam)
    ratio = 1.585;
    width = diam;
    height = double(int16(width * ratio));
    rad = max(width, height) / 2;
    diam = sqrt((width / 2)^2 + (height / 2)^2) * 2;

    rects = zeros([amount 4]);

    % Define boundary matrix
    xLoc = 0; yLoc = 0;
    xTemp = zeros([1 amount]); yTemp = zeros([1 amount]);
    
    for i = 1:amount
        validLocation = false;
        while ~validLocation
            xLoc = randi([margin,wWidth-margin]);
            yLoc = randi([height,wHeight-height]);
            % Check if the location is valid (not in the center circle)
            if abs(xLoc - wWidth/2) > rad && abs(yLoc - wHeight/2) > rad
                % Check the distance from other
                if all(sqrt((xTemp-xLoc).^2+(yTemp-yLoc).^2) > diam)
                    validLocation = true;
                end
            end
        end

        xTemp(i) = xLoc; yTemp(i) = yLoc;
        rects(i, :) = [xLoc - width / 2, yLoc - height / 2, xLoc + width / 2, yLoc + height / 2];
    end

    result = rects;

end

function [crect] = gabors(NofGratings, gratingSize, rect, fix_rect)
	r_max = ceil(max(gratingSize));	% maximum radius
    center_edge = 2;

    map = rand(rect(4), rect(3)); % random matrix with the size of screen rect

	% if the randomly chosen points cannot be the center of the next circle, it comes to be 0 (periphery of the screen + fixation cross).
	map(:, [1:r_max, (rect(3) - r_max):rect(3)]) = 0;
	map([1:r_max, (rect(4) - r_max):rect(4)], :) = 0;
    if length(fix_rect) >1
        map((fix_rect(2)-r_max*2):(fix_rect(4)+r_max*2), (fix_rect(1)-r_max*2):(fix_rect(3)+r_max*2)) = 0;
        map((fix_rect(2)-r_max-center_edge):(fix_rect(4)+r_max+center_edge), (fix_rect(1)-r_max-center_edge):(fix_rect(3)+r_max+center_edge)) = 0;
    end

    % Initialize crect
    crect = zeros(NofGratings, 4);

    for i = 1 : NofGratings % 24: the number of circles needed each trial
	    % look for the maximum value of map matrix and determine cx and cy. 
		max_row = max(map, [], 1);
		max_value = max(max_row);
		if max_value == 0
		    error('no space left for drawing');	% there is no space for drawing a circle
		end
		cx = find(max_row == max_value);
		max_col = max(map, [], 2);
		cy = find(max_col == max_value);

		% determine the random radius and draw a circle
		cr = round(gratingSize(i));
        crect(i,:) = [cx - cr, cy - cr, cx + cr, cy + cr];

        mr = cr + r_max+2;
		mask = repmat((0.5 - mr):(mr - 0.5), mr * 2, 1);
		mask = (mask .^2 + mask' .^ 2) > mr ^ 2;

		mrange_x = max(mr - cx + 1, 1):(mr * 2 + min(0, rect(3) - cx - mr));
		mrange_y = max(mr - cy + 1, 1):(mr * 2 + min(0, rect(4) - cy - mr));
		range_x = max(1, cx - mr + 1):min(rect(3), cx + mr);
		range_y = max(1, cy - mr + 1):min(rect(4), cy + mr);

		map(range_y, range_x) = map(range_y, range_x) .* mask(mrange_y, mrange_x);
    end

end
