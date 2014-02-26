%% carry_out_strategy: this is a function to carry out
%% the strategy when we have a Policy
function [StatesVisited, P, parked] = carry_out_strategy(StartState, Policy, P)

	global OCCUPIED FREE
	global TO_GOAL

	% for now generate the ground truth also here
	GroundTruth = zeros(size(Policy));
	GroundTruth(50:end) = OCCUPIED;

	Observations = zeros(size(Policy)) .- 1;

	parked = false; 
	CurrentState = StartState;
	StatesVisited = [];
	while (parked == false)
		Observations(CurrentState) = GroundTruth(CurrentState);
		StatesVisited = [StatesVisited CurrentState];
		CurrentAction = Policy(CurrentState);
		if (CurrentAction == TO_GOAL && GroundTruth(CurrentState) == FREE) 
			parked = true;
		elseif (CurrentAction == TO_GOAL && GroundTruth(CurrentState) == OCCUPIED)
			% we should update the matrix after this
			% it means that we want to park in an occupied position
			% we need to update P for replanning
			P = update_occupancy_prob(StatesVisited, GroundTruth, P);
			break;
		else
			disp(CurrentState)
			ProbVector = P{CurrentAction}(CurrentState, :);
			Index = find(ProbVector);
			if (length(Index) > 1)
				error(['this should not happen']);
				disp(ProbVector)	
			end
			if (Index == CurrentState)
				break;
			end
			CurrentState = Index;
		end
	end
end
