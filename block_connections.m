%% add_vertical_connections: add ver
function [P, R] = block_connections(P, R, parking_rows, car_cost)

    global UP;
    global DOWN;

    % vertical connections
    indicators = ones(1, size(R{UP}, 2) - 1);
    indicators(parking_rows:parking_rows:end) = 0;
    P{UP}(15,16) = 0;
    P{DOWN}(16,15) = 0;
end
