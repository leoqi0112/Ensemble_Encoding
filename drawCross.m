function drawCross(window, xVal, yVal, Length, color)
    % Function to draw a cross at the specified coordinates (xVal, yVal)
    % with the specified length and color on the given window.

    % Draw horizontal line of the cross
    Screen('DrawLine', window, color, xVal - Length, yVal, xVal + Length, yVal, 2);
    
    % Draw vertical line of the cross
    Screen('DrawLine', window, color, xVal, yVal - Length, xVal, yVal + Length, 2);
end