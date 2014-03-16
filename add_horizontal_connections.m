%% add_horizontal_connections: function description
function [P, R] = add_horizontal_connections(P, R, ParkingRows, CarSpeed, WaitingTime)

	global LEFT RIGHT

    GAP_PERIOD = 2;

    % define distance between horizontal lines in meters
    HorizontalDist = 5;

    % set indicator values
    Indicators = zeros(1, size(R{1}, 2) - ParkingRows);
    Indicators(1:ParkingRows:end) = 1;
    Indicators(ParkingRows:ParkingRows:end) = 1;

    % add horizontal connections
    P{RIGHT} = set_off_diag(P{RIGHT}, ParkingRows, Indicators);
    P{LEFT} = set_off_diag(P{LEFT}, -ParkingRows, Indicators);

    % add horizontal middle connections
    Indeces = [1:size(R{LEFT},2)];
    div_res = floor((Indeces - 1) ./ ParkingRows);
    mod_res = mod(div_res, GAP_PERIOD);
    Indeces = Indeces(mod_res == 1);
    for i = Indeces
    	if (i + ParkingRows < size(P{LEFT},2))
    		P{RIGHT}(i, i + ParkingRows) = 1;
    		P{LEFT}(i + ParkingRows, i) = 1;
            R{RIGHT}(i, i + ParkingRows) = -HorizontalDist/CarSpeed;
            R{LEFT}(i + ParkingRows, i) = -HorizontalDist/CarSpeed;
    	end
    end

    % also update the rewards matrix
    Costs = Indicators .* (- HorizontalDist/CarSpeed);
    R{RIGHT} = set_off_diag(R{RIGHT}, ParkingRows, Costs);
    R{LEFT} = set_off_diag(R{LEFT}, -ParkingRows, Costs);

    % set the cost for staying in one place
    R{RIGHT} = R{RIGHT} + eye(size(R{RIGHT})) .* (-WaitingTime);
    R{LEFT} = R{LEFT} + eye(size(R{LEFT})) .* (-WaitingTime);
end

