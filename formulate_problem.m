#######################################################
#  This function formulates the problem for further
#   use with the MDP{1} solver
######################################################

function [P, R] = formulate_problem(filename, car_cost)
    [coords, occupancy_vector, P, R, gap_period, parking_rows, parking_cols] = form_cell_arrays(filename);
    indicators = ones(1, columns(R{1}) - 1);
    # vertical connections
    indicators(parking_rows:parking_rows:end) = 0;
    P{1} = P{1} + diag(indicators, 1);
    P{2} = P{2} + diag(indicators, -1);
    costs = indicators .* -car_cost;
    R{1} = R{1} + diag(costs, 1);
    R{2} = R{2} + diag(costs, -1);
    # add horizontal connections
    indicators = zeros(1, columns(R{1}) - parking_rows);
    indicators(1:parking_rows:end) = 1;
    indicators(parking_rows:parking_rows:end) = 1;
    P{3} = P{3} + diag(indicators, parking_rows);
    P{4} = P{4} + diag(indicators, -parking_rows);
    costs = indicators .* -car_cost;
    R{3} = R{3} + diag(costs, parking_rows);
    R{4} = R{4} + diag(costs, -parking_rows);

    # define goal
    goal = coords{end}; # for now - the last pos
    # now add a vector with rewards for reaching goal
    rewards = zeros(1, length(coords));
    for i = 1:length(coords)
        dist = get_distance(coords{i}, goal);
        rewards(i) = -dist;
    endfor
    %row_probs = (1 - occupancy_vector') ./ sum(P{1},2);
    %row_probs = repmat(row_probs, 1, columns(P{1}));
    %P{5} = P{5} .* row_probs; # assign probabilities
    
    R{5} = [R{5} rewards']; # append rewards to R{1} as a column
    P{5} += diag(1 - occupancy_vector);
    P{5} = [P{5} occupancy_vector']; # same for P{1}
    
    rsize = size(R{5});
    rsize(1) += 1; # increment size
    for i = 1:5
        R{i} = resize(R{i}, rsize);
        P{i} = resize(P{i}, rsize);
        difference = 1 - sum(P{i}, 2);
        P{i} = P{i} + diag(difference);
        R{i} = sparse(R{i});
        P{i} = sparse(P{i});
    endfor
    P{5}(end,end) = 1;
    P{4}(end,end) = 1;
    P{3}(end,end) = 1;
    P{2}(end,end) = 1;
    P{1}(end,end) = 1;
endfunction

