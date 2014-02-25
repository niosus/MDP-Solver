%% add_horizontal_connections: function description
function [P, R] = add_horizontal_connections(P, R, parking_rows, car_cost)

	% define directions for actions:
    up = 1;
    down = 2;
    right = 3;
    left = 4;
    to_goal = 5;

    gap_period = 2;

    % set indicator values
    indicators = zeros(1, columns(R{1}) - parking_rows);
    indicators(1:parking_rows:end) = 1;
    indicators(parking_rows:parking_rows:end) = 1;

    % add horizontal connections
    P{right} = set_off_diag(P{right}, parking_rows, indicators);
    P{left} = set_off_diag(P{left}, -parking_rows, indicators);

    % add horizontal middle connections
    indeces = [1:columns(R{left})];
    div_res = floor((indeces - 1) ./ parking_rows);
    mod_res = mod(div_res, gap_period);
    indeces = indeces(mod_res == 1);
    for i = indeces
    	if (i + parking_rows < columns(P{left}))
    		P{right}(i, i + parking_rows) = 1;
    		P{left}(i + parking_rows, i) = 1;
    	end
    end
    
    % also update the rewards matrix
    costs = indicators .* (- car_cost);
    R{right} = set_off_diag(R{right}, parking_rows, costs);
    R{left} = set_off_diag(R{left}, -parking_rows, costs);
end

