%% plot_strategies: a function to plot 
function plot_strategies(Coords, Goal, Policy, P)

	global UP DOWN LEFT RIGHT
	global TO_GOAL

	CoordsMat = cell2mat(Coords);
	CoordsMat = [CoordsMat; Goal];

	angles = Policy;
	angles(angles == UP) = 0;
	angles(angles == DOWN) = pi;
	angles(angles == RIGHT) = pi/2;
	angles(angles == LEFT) = -pi/2;
	angles(angles == TO_GOAL) = pi/4;
	color = P{TO_GOAL}(:, end);
	color = [1-color, color, zeros(size(color))];
	figure(1);
	clf;
	axis equal;
	hold on;
	h = quiver (CoordsMat(:,1), CoordsMat(:,2), sin(angles), cos(angles), 2);
	set (h, 'maxheadsize', 0.2);
	h = scatter(CoordsMat(:,1), CoordsMat(:,2), 10, color, 'filled');
	hold off;
	waitforbuttonpress ();
	% axis ([871900, 872000, 6077450, 6077550]);
end