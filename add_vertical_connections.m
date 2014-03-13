%% add_vertical_connections: add ver
function [P, R] = add_vertical_connections(P, R, parking_rows, car_cost)

	global UP;
	global DOWN;

	% vertical connections
	indicators = ones(1, size(R{UP}, 2) - 1);
    indicators(parking_rows:parking_rows:end) = 0;
    P{UP} = set_off_diag(P{UP}, 1, indicators);
    P{DOWN} = set_off_diag(P{DOWN}, -1, indicators);

    % also update the rewards matrix
    costs = indicators .* (- car_cost);
    R{UP} = set_off_diag(R{UP}, 1, costs);
    R{DOWN} = set_off_diag(R{DOWN}, -1, costs);

    % set the same cost for staying in one place as for moving
    R{UP} = R{UP} + eye(size(R{UP})) .* (-car_cost);
    R{DOWN} = R{DOWN} + eye(size(R{DOWN})) .* (-car_cost);
end
