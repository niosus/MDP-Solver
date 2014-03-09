%% solve_mdp: a small function to solve MDPs
function solve_mdp(parking_lots_file_name, ground_truth_file, car_cost)
	global FREE = 1
	global OCCUPIED = 0
	global UP = 1;
    global DOWN = 2;
    global RIGHT = 3;
    global LEFT = 4;
    global TO_GOAL = 5;

    [~, path_to_mdp_solver] = system ('find ~/ 2>/dev/null -maxdepth 3 -type d -name MDPtoolbox', true);
    path_to_mdp_solver = path_to_mdp_solver(1:end-1);

	addpath(path_to_mdp_solver);
	[P, R, coords, goal] = formulate_problem(parking_lots_file_name, car_cost);
	error_message = mdp_check(P, R);
	if length(error_message) > 0
		error(error_message);
	else
		disp('P and R correct');
	end
	Discount = 0.9999999;
	[V, Policy, iter, cpu_time] = mdp_policy_iteration (P, R, Discount);
	StartState = 1;
	Parked = false;
	% for now generate the ground truth also here
	% it has 1 if a cell is free and 0 is occupied
	GroundTruth = generate_ground_truth(ground_truth_file);
	GroundTruth = [GroundTruth; FREE];

	AllVisitedStates = [];
	plot_strategies(coords, goal, Policy, P, AllVisitedStates);
	while (Parked == false)
		[Visited, P, Parked] = carry_out_strategy(GroundTruth, StartState, Policy, P);
		[V, Policy, iter, cpu_time] = mdp_policy_iteration (P, R, Discount, Policy);
		StartState = Visited(end);
		AllVisitedStates = [AllVisitedStates Visited];
		plot_strategies(coords, goal, Policy, P, AllVisitedStates);
	end
end
