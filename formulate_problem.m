#######################################################
#  This function formulates the problem for further
#   use with the MDP solver
######################################################

function [P, R] = formulate_problem(filename, car_cost)
    [coords, occupancy_vector, P, R, gap_period, parking_rows, parking_cols] = form_cell_arrays(filename);
    indicators = ones(1, columns(R) - 1);
    # vertical connections
    indicators(parking_rows:parking_rows:end) = 0;
    P = P + diag(indicators, 1);
    P = P + diag(indicators, -1);
    costs = indicators .* -car_cost;
    R = R + diag(costs, 1);
    R = R + diag(costs, -1);
    # add horizontal connections
    indicators = zeros(1, columns(R) - parking_rows);
    indicators(1:parking_rows:end) = 1;
    indicators(parking_rows:parking_rows:end) = 1;
    P = P + diag(indicators, parking_rows);
    P = P + diag(indicators, -parking_rows);
    costs = indicators .* -car_cost;
    R = R + diag(costs, parking_rows);
    R = R + diag(costs, -parking_rows);

    # define goal
    goal = coords{end}; # for now - the last pos
    # now add a vector with rewards for reaching goal
    rewards = zeros(1, length(coords));
    for i = 1:length(coords)
        dist = get_distance(coords{i}, goal);
        rewards(i) = -dist;
    endfor
    row_probs = (1 - occupancy_vector') ./ sum(P,2);
    row_probs = repmat(row_probs, 1, columns(P));
    P = P .* row_probs; # assign probabilities
    
    R = [R rewards']; # append rewards to R as a column
    P = [P occupancy_vector']; # same for P
    rsize = size(R);
    rsize(1) += 1; # increment size
    resize(R, rsize); # make the matrix square again
    resize(P, rsize); # same for P matrix
    # now make the matrices sparse
    P = sparse(P);
    R = sparse(R);
    
endfunction

