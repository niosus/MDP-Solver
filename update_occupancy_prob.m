%% update_occupancy_prob: this is needed to account for observations in
%% our occupancy model
function P = update_occupancy_prob(Visited, GroundTruth, P)
	global TO_GOAL

	% drop elements that correspond to observations
	P{TO_GOAL}(Visited, :) = zeros(length(Visited), columns(P{TO_GOAL}));
	% set all observed probabilities to ground truth
	P{TO_GOAL}(Visited, end) = GroundTruth(Visited);

	% set diagonal elements for those that have zero probability
	% in the end of the vector
	difference = 1 - sum(P{TO_GOAL}, 2);
    P{TO_GOAL} = P{TO_GOAL} + diag(difference);
end
