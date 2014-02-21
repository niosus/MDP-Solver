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
    P{1} = P{1} + diag(indicators, -1);
    costs = indicators .* -car_cost;
    R{1} = R{1} + diag(costs, 1);
    R{1} = R{1} + diag(costs, -1);
    # add horizontal connections
    indicators = zeros(1, columns(R{1}) - parking_rows);
    indicators(1:parking_rows:end) = 1;
    indicators(parking_rows:parking_rows:end) = 1;
    P{1} = P{1} + diag(indicators, parking_rows);
    P{1} = P{1} + diag(indicators, -parking_rows);
    costs = indicators .* -car_cost;
    R{1} = R{1} + diag(costs, parking_rows);
    R{1} = R{1} + diag(costs, -parking_rows);

    # define goal
    goal = coords{end}; # for now - the last pos
    # now add a vector with rewards for reaching goal
    rewards = zeros(1, length(coords));
    for i = 1:length(coords)
        dist = get_distance(coords{i}, goal);
        rewards(i) = -dist;
    endfor
    row_probs = (1 - occupancy_vector') ./ sum(P{1},2);
    row_probs = repmat(row_probs, 1, columns(P{1}));
    P{1} = P{1} .* row_probs; # assign probabilities
    
    R{1} = [R{1} rewards']; # append rewards to R{1} as a column
    P{1} = [P{1} occupancy_vector']; # same for P{1}
    rsize = size(R{1});
    rsize(1) += 1; # increment size
    R{1} = resize(R{1}, rsize); # make the matrix square again
    P{1} = resize(P{1}, rsize); # same for P{1} matrix
    P{1}(end,end) = 1;
    # now make the matrices sparse
    P{1} = sparse(P{1});
    R{1} = sparse(R{1});
    
endfunction

