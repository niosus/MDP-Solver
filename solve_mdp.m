%% solve_mdp: a small function to solve MDPs
function solve_mdp(ParkingOccupancyFile, GroundTruthOccupancyFile, DriveSpeed, WalkSpeed, WaitingTime, GraphNamePrefix, Artificial)
	global FREE
	global OCCUPIED
	global UP
    global DOWN
    global RIGHT
    global LEFT
    global TO_GOAL

    FREE = 1;
	OCCUPIED = 0;
	UP = 1;
	DOWN = 2;
	RIGHT = 3;
	LEFT = 4;
	TO_GOAL = 5;

	[P, R, Coordinates, GoalState]=formulate_problem(ParkingOccupancyFile, DriveSpeed, WalkSpeed, WaitingTime);
	ErrorMessage = mdp_check(P, R);
	if length(ErrorMessage) > 0
		error(ErrorMessage);
	else
		disp('P and R correct');
	end
	Discount = 0.9999999999;
	% [V, Policy, iter, cpu_time] = mdp_policy_iteration (P, R, Discount);
	StartState = 1;
	Parked = false;

	% for now generate the ground truth also here
	% it has 1 if a cell is free and 0 is occupied
	GroundTruth = generate_ground_truth(GroundTruthOccupancyFile);

	% artificial ground truth for testing
    if (Artificial == 1)
        GroundTruth(1:60) = FREE;
        GroundTruth(61:end) = OCCUPIED;
    end
        

	% set the goal state as FREE
	GroundTruth = [GroundTruth; FREE];


	AllVisitedStates = [];

	% plot_states(Coordinates, GoalState, P, GraphNamePrefix);

	Iteration = 1;
	while (Parked == false)
		[V, Policy, iter, cpu_time] = mdp_policy_iteration (P, R, Discount);
		[Visited, P, Parked] = carry_out_strategy(GroundTruth, StartState, Policy, P);
		StartState = Visited(end);
		plot_strategies(Coordinates, GoalState, Policy, P, AllVisitedStates, Visited, GroundTruth, GraphNamePrefix, Iteration);
		AllVisitedStates = [AllVisitedStates Visited];
		Iteration=Iteration+1;
	end
end
