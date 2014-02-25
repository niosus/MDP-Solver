%% solve_mdp: a small function to solve MDPs
function solve_mdp(path_to_mdp_solver, parking_lots_file_name, car_cost)
	addpath(path_to_mdp_solver);
	[P, R, coords] = formulate_problem(parking_lots_file_name, car_cost);
	error_message = mdp_check(P, R);
	if length(error_message) > 0
		error(error_message);
	else
		disp('P and R correct');
	end
	discount = 0.99;
	[V, policy, iter, cpu_time] = mdp_policy_iteration (P, R, discount);
	coords_mat = cell2mat(coords);
	goal = coords{end}; 
    goal(1) += 10;
    goal(2) -= 10;
	coords_mat = [coords_mat; goal];

	% define directions for actions:
    up = 1;
    down = 2;
    right = 3;
    left = 4;
    to_goal = 5;

	angles = policy;
	angles(angles == up) = 0;
	angles(angles == down) = pi;
	angles(angles == right) = pi/2;
	angles(angles == left) = -pi/2;
	angles(angles == to_goal) = pi/4;
	color = P{to_goal}(:, end);
	color = [1-color, color, zeros(size(color))];
	figure(1);
	clf;
	hold on;
	h = quiver (coords_mat(:,1), coords_mat(:,2), sin(angles), cos(angles), 2);
	set (h, 'maxheadsize', 0.2);
	h = scatter(coords_mat(:,1), coords_mat(:,2), 10, color, 'filled');
	axis equal;
	hold off;
	% axis ([871900, 872000, 6077450, 6077550]);

	result = carry_out_strategy(policy, P)
end