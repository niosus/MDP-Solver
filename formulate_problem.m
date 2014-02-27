
% This function formulates the problem for further
% use with the MDP{1} solver

function [P, R, coords, goal] = formulate_problem(filename, car_cost)

    global TO_GOAL LEFT RIGHT UP DOWN

    [coords, occupancy_vector, P, R, gap_period, parking_rows, parking_cols] = form_cell_arrays(filename);

    % vertical connections
    [P, R] = add_vertical_connections(P, R, parking_rows, car_cost);

    % add horizontal connections
    [P, R] = add_horizontal_connections(P, R, parking_rows, car_cost);

    % define goal
    % for now - the last position + 10 meters to the right
    goal = coords{end};
    goal(1) += 10;
    goal(2) -= 10;
    % now add a vector with rewards for reaching goal
    rewards = reward_from_dist(coords, goal);

    % append rewards to R{TO_GOAL} as a column
    R{TO_GOAL} = [R{TO_GOAL} rewards'];

    % set "park" action probabilities
    P{TO_GOAL} += diag(1 - occupancy_vector);
    P{TO_GOAL} = [P{TO_GOAL} occupancy_vector'];

    rsize = size(R{TO_GOAL});
    rsize(1) += 1; % increment size
    for i = 1:5
        R{i} = resize(R{i}, rsize);
        P{i} = resize(P{i}, rsize);
        % set the diagonal non-set elements to 1
        difference = 1 - sum(P{i}, 2);
        P{i} = P{i} + diag(difference);
        R{i} = sparse(R{i});
        P{i} = sparse(P{i});
    end
    P{TO_GOAL}(end,end) = 1;
    P{LEFT}(end,end) = 1;
    P{RIGHT}(end,end) = 1;
    P{DOWN}(end,end) = 1;
    P{UP}(end,end) = 1;
end
