% This function formulates the problem for further
% use with the MDP{1} solver

function [P, R, Coordinates, Goal] = formulate_problem(Filename, DriveSpeed, WalkSpeed, WaitingTime)

    global TO_GOAL LEFT RIGHT UP DOWN

    [Coordinates, OccupancyVector, P, R, GapPeriod, ParkingRows, ParkingCols] = form_cell_arrays(Filename);

    % add vertical connections and rewards
    [P, R] = add_vertical_connections(P, R, ParkingRows, DriveSpeed, WaitingTime);

    % add horizontal connections
    [P, R] = add_horizontal_connections(P, R, ParkingRows, DriveSpeed, WaitingTime);

    % block some of the connections for testing
    [P, R] = block_connections(P, R, ParkingRows, DriveSpeed);

    % define Goal
    % for now - the last position + 10 meters to the right
    Goal = Coordinates{end};
    Goal(1) = Goal(1);
    Goal(2) = Goal(2) + 10;
    % now add a vector with rewards for reaching Goal
    rewards = reward_from_dist(Coordinates, Goal, WalkSpeed);

    % append rewards to R{TO_GOAL} as a column
    R{TO_GOAL} = [R{TO_GOAL} rewards'];

    % if we try to park but do not succeed, we lose time
    R{TO_GOAL} = R{TO_GOAL} + eye(size(R{TO_GOAL})).*(-WaitingTime);

    % set "park" action probabilities
    P{TO_GOAL} = P{TO_GOAL} + diag(1 - OccupancyVector);
    P{TO_GOAL} = [P{TO_GOAL} OccupancyVector'];

    rsize = size(R{TO_GOAL});
    rsize(1) = rsize(1) + 1; % increment size
    for i = 1:5
        R{i} = resize(R{i}, rsize);
        P{i} = resize(P{i}, rsize);
        % set the diagonal non-set elements to 1
        Difference = 1 - sum(P{i}, 2);
        P{i} = P{i} + diag(Difference);
        R{i} = sparse(R{i});
        P{i} = sparse(P{i});
    end
    P{TO_GOAL}(end,end) = 1;
    P{LEFT}(end,end) = 1;
    P{RIGHT}(end,end) = 1;
    P{DOWN}(end,end) = 1;
    P{UP}(end,end) = 1;
end
