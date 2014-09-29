%% plot_strategies: a function to plot
function plot_strategies(Coords, Goal, Policy, P, AllVisitedStates, VisitedStates, GroundTruth, NamePrefix, Iteration)

	global UP DOWN LEFT RIGHT
	global TO_GOAL

	OutName = [NamePrefix '_path.pdf'];
    
C = [255,0,0;
251,5,0;
245,10,0;
240,14,0;
235,19,0;
230,24,0;
225,29,0;
220,34,0;
214,38,0;
209,43,0;
204,48,0;
199,53,0;
194,58,0;
188,63,0;
183,69,0;
178,74,0;
172,80,0;
167,85,0;
162,91,0;
156,97,0;
151,102,0;
145,108,0;
140,113,0;
135,119,0;
129,125,0;
124,130,0;
118,136,0;
113,142,0;
107,147,0;
101,153,0;
96,159,0;
90,164,0;
85,170,0;
79,176,0;
73,181,0;
68,187,0;
62,193,0;
57,198,0;
52,203,0;
47,208,0;
43,213,0;
38,217,0;
33,222,0;
28,227,0;
24,232,0;
19,237,0;
14,241,0;
9,246,0;
5,251,0;
0,255,0];

    % colormap(C/255); % in matlab
    colormap('Autumn'); % in matlab
	CoordsMat = cell2mat(Coords);
	CoordsMat = [CoordsMat; Goal];
    
    % translate to zero
    MinRows = min(CoordsMat, [], 1);
    CoordsMat = CoordsMat - ones(size(CoordsMat,1), 1) * MinRows;
    
    % define coordinates for driving positions
    CoordsDrive = CoordsMat;
    OldVal = -1;
    Sign = 1;
    Gap = 3;
    for i=1:size(CoordsDrive, 1)
        if (CoordsDrive(i,1) ~= OldVal) 
            OldVal = CoordsDrive(i,1);
            Sign = Sign * -1;
        end
        if (i == size(CoordsDrive,1)) 
           break; 
        end
        CoordsDrive(i,1) = CoordsDrive(i,1) + Sign * Gap;
    end
    CoordsDrive

	angles = Policy;
	angles(angles == UP) = 0;
	angles(angles == DOWN) = pi;
	angles(angles == RIGHT) = pi/2;
	angles(angles == LEFT) = -pi/2;
	angles(angles == TO_GOAL) = pi/4;
	color = P{TO_GOAL}(:, end);
	%color = [1-color, color, zeros(size(color))];

	ColorGroundTruth = [1 - GroundTruth, GroundTruth, zeros(size(GroundTruth))];

	fh = figure(1);
	clf;
	hold on;
    whitebg([1 1 1]);
    h = plot(CoordsDrive(AllVisitedStates,1), CoordsDrive(AllVisitedStates,2), '-', 'color', [0.5, 0.5, 1],  'linewidth', 4);
	h = plot(CoordsDrive(VisitedStates,1), CoordsDrive(VisitedStates,2), '-', 'color', [0.5, 0.5, 1], 'linewidth', 5);
    
    h = scatter(CoordsMat(:,1), CoordsMat(:,2), 100 , color, 's', 'filled');
	h = scatter(CoordsMat(:,1), CoordsMat(:,2), 20, GroundTruth, 's', 'filled');
    
    h = quiver (CoordsDrive(:,1), CoordsDrive(:,2), sin(angles), cos(angles), 0.23, 'black');
    h = scatter(CoordsDrive(:,1), CoordsDrive(:,2), 30 , 'black', 'filled');
	
	%set (h, 'maxheadsize', 1);
	%set (h, 'linewidth', 0.5);
    hc = colorbar('horiz');       
    set(hc,'location','southoutside')
    title(hc,'occupancy probability')
    ticks = {'occupied', 'free'};
    set(hc, 'XTick', [0,1]);
    set(hc, 'XTickLabel', ticks);
	axis equal;
	grid on;
	axis off;
	hold off;
    %print(fh,'-dpdf','-r300','filename')
	plotPDF(fh, OutName, [7 5]);
%     plotPDF(fh, 'init', [7 5]);
% 	waitforbuttonpress ();
	% axis ([871900, 872000, 6077450, 6077550]);
end
