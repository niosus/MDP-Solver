
% This function formulates the problem for further
% use with the MDP{1} solver

function [P, R, coords] = formulate_problem(filename, car_cost)
    [coords, occupancy_vector, P, R, gap_period, parking_rows, parking_cols] = form_cell_arrays(filename);

    % define directions for actions:
    up = 1;
    down = 2;
    right = 3;
    left = 4;
    to_goal = 5;
    
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

    % append rewards to R{to_goal} as a column
    R{to_goal} = [R{to_goal} rewards'];     

    % set "park" action probabilities
    P{to_goal} += diag(1 - occupancy_vector);
    P{to_goal} = [P{to_goal} occupancy_vector']; 
    
    rsize = size(R{to_goal});
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
    P{to_goal}(end,end) = 1;
    P{left}(end,end) = 1;
    P{right}(end,end) = 1;
    P{down}(end,end) = 1;
    P{up}(end,end) = 1;
end