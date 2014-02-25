%% reward_from_dist: compute rewards from distance
function rewards = reward_from_dist(coords, goal)
	rewards = zeros(1, length(coords));
    dist = [];
    for i = 1:length(coords)
        dist = [dist get_distance(coords{i}, goal)];
    end
    rewards = (max(dist) .- dist);
end
