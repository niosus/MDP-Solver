%% add_horizontal_connections: function description
function [P, R] = add_horizontal_connections(P, R, parking_rows, car_cost)

	global LEFT RIGHT

    gap_period = 2;

    % set indicator values
    indicators = zeros(1, columns(R{1}) - parking_rows);
    indicators(1:parking_rows:end) = 1;
    indicators(parking_rows:parking_rows:end) = 1;

    % add horizontal connections
    P{RIGHT} = set_off_diag(P{RIGHT}, parking_rows, indicators);
    P{LEFT} = set_off_diag(P{LEFT}, -parking_rows, indicators);

    % add horizontal middle connections
    indeces = [1:columns(R{LEFT})];
    div_res = floor((indeces - 1) ./ parking_rows);
    mod_res = mod(div_res, gap_period);
    indeces = indeces(mod_res == 1);
    for i = indeces
    	if (i + parking_rows < columns(P{LEFT}))
    		P{RIGHT}(i, i + parking_rows) = 1;
    		P{LEFT}(i + parking_rows, i) = 1;
    	end
    end
    
    % also update the rewards matrix
    costs = indicators .* (- car_cost);
    R{RIGHT} = set_off_diag(R{RIGHT}, parking_rows, costs);
    R{LEFT} = set_off_diag(R{LEFT}, -parking_rows, costs);
end

