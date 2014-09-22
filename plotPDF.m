function plotPDF(fig_h, name, plotSize)
	if nargin < 3	
		plotSize = [10 6]
	end

	set(fig_h, 'PaperSize', plotSize);
	set(fig_h, 'PaperPositionMode', 'manual');
	set(fig_h, 'PaperPosition', [0 0 plotSize]);

	set(fig_h, 'PaperUnits', 'inches');
	% set(fig_h, 'PaperSize', plotSize);
	% set(fig_h, 'PaperPositionMode', 'manual');
	% set(fig_h, 'PaperPosition', [0 0 plotSize]);

	set(fig_h, 'renderer', 'painters');
    % set(fig_h, 'renderer', 'zbuffer');
	print(fig_h, '-dpdf', '-r600', name);
end