%% add_horizontal_connections: function description
function [P, R] = add_horizontal_connections(P, R, ParkingRows, CarCost)

	global LEFT RIGHT

    GAP_PERIOD = 2;

    % set indicator values
    indicators = zeros(1, size(R{1},2) - ParkingRows);
    indicators(1:ParkingRows:end) = 1;
    indicators(ParkingRows:ParkingRows:end) = 1;

    % add horizontal connections
    P{RIGHT} = set_off_diag(P{RIGHT}, ParkingRows, indicators);
    P{LEFT} = set_off_diag(P{LEFT}, -ParkingRows, indicators);

    % add horizontal middle connections
    indeces = [1:size(R{LEFT},2)];
    div_res = floor((indeces - 1) ./ ParkingRows);
    mod_res = mod(div_res, GAP_PERIOD);
    indeces = indeces(mod_res == 1);
    for i = indeces
    	if (i + ParkingRows < size(P{LEFT},2))
    		P{RIGHT}(i, i + ParkingRows) = 1;
    		P{LEFT}(i + ParkingRows, i) = 1;
    	end
    end

    % also update the rewards matrix
    costs = indicators .* (- CarCost);
    R{RIGHT} = set_off_diag(R{RIGHT}, ParkingRows, costs);
    R{LEFT} = set_off_diag(R{LEFT}, -ParkingRows, costs);

    % set the same cost for staying in one place as for moving
    R{RIGHT} = R{RIGHT} + eye(size(R{RIGHT})) .* (-CarCost);
    R{LEFT} = R{LEFT} + eye(size(R{LEFT})) .* (-CarCost);
end

