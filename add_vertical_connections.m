%% add_vertical_connections: add ver
function [P, R] = add_vertical_connections(P, R, parking_rows, car_cost)

	% define directions for actions:
    up = 1;
    down = 2;
    right = 3;
    left = 4;
    to_goal = 5;

	% vertical connections
	indicators = ones(1, columns(R{up}) - 1);
    indicators(parking_rows:parking_rows:end) = 0;
    P{up} = set_off_diag(P{up}, 1, indicators);
    P{down} = set_off_diag(P{down}, -1, indicators);
    
    % also update the rewards matrix
    costs = indicators .* (- car_cost);
    R{up} = set_off_diag(R{up}, 1, costs);
    R{down} = set_off_diag(R{down}, -1, costs);
end