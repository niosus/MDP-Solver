%% plot_strategies: a function to plot
function plot_strategies(Coords, Goal, Policy, P, AllVisitedStates, VisitedStates, GroundTruth, NamePrefix, Iteration)

	global UP DOWN LEFT RIGHT
	global TO_GOAL

	OutName = [NamePrefix '_path_' num2str(Iteration) '.pdf'];

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

	ColorGroundTruth = [1 - GroundTruth, GroundTruth, zeros(size(GroundTruth))];

	fh = figure(1);
	clf;
	hold on;
	h = scatter(CoordsMat(:,1), CoordsMat(:,2), 60, color, 'filled');
	h = scatter(CoordsMat(:,1), CoordsMat(:,2), 30, ColorGroundTruth, 'filled');
	h = plot(CoordsMat(AllVisitedStates,1), CoordsMat(AllVisitedStates,2), '--', 'color', [0.5, 0.5, 1],  'linewidth', 15);
	h = plot(CoordsMat(VisitedStates,1), CoordsMat(VisitedStates,2), '-', 'color', [0.5, 0.5, 1], 'linewidth', 15);
	h = quiver (CoordsMat(:,1), CoordsMat(:,2), sin(angles), cos(angles), 2.2);
	set (h, 'maxheadsize', 0.6);
	set (h, 'linewidth', 3);
	axis auto;
	grid on;
	axis off;
	hold off;
	plotPDF(fh, OutName, [7 7]);
	waitforbuttonpress ();
	% axis ([871900, 872000, 6077450, 6077550]);
end
