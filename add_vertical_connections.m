%% add_vertical_connections: add ver
function [P, R] = add_vertical_connections(P, R, parking_rows, CarSpeed, WaitingTime)

	global UP;
	global DOWN;

    VerticalDist = 2.5 % meters

	% add vertical connections
	indicators = ones(1, size(R{UP}, 2) - 1);
    indicators(parking_rows:parking_rows:end) = 0;
    P{UP} = set_off_diag(P{UP}, 1, indicators);
    P{DOWN} = set_off_diag(P{DOWN}, -1, indicators);

    % also update the rewards matrix
    costs = indicators .* (-VerticalDist/CarSpeed);
    R{UP} = set_off_diag(R{UP}, 1, costs);
    R{DOWN} = set_off_diag(R{DOWN}, -1, costs);

    % set the same cost for staying in one place as for moving
    R{UP} = R{UP} + eye(size(R{UP})) .* (-WaitingTime);
    R{DOWN} = R{DOWN} + eye(size(R{DOWN})) .* (-WaitingTime);
end
