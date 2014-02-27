%% carry_out_strategy: this is a function to carry out
%% the strategy when we have a Policy
function [StatesVisited, P, parked] = carry_out_strategy(GroundTruth, StartState, Policy, P)

	global OCCUPIED FREE
	global TO_GOAL

	Observations = zeros(size(Policy)) .- 1;

	parked = false;
	CurrentState = StartState;
	StatesVisited = [];
	iter = 0;
	while (parked == false)
		Observations(CurrentState) = GroundTruth(CurrentState);
		StatesVisited = [StatesVisited CurrentState];
		CurrentAction = Policy(CurrentState);
		if (CurrentAction == TO_GOAL && GroundTruth(CurrentState) == FREE)
			% add a goal state to drawing
			disp('TRYING TO PARK!!!')
			StatesVisited = [StatesVisited 181];
			parked = true;
		elseif (CurrentAction == TO_GOAL && GroundTruth(CurrentState) == OCCUPIED)
			% we should update the matrix after this
			% it means that we want to park in an occupied position
			% we need to update P for re-planning
			P = update_occupancy_prob(StatesVisited, GroundTruth, P);
			break;
		else
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
		iter+=1;
		if (iter > 1000)
			error('1000 iterations exceeded');
		end
	end
end
