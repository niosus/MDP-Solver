%% set_off_diag: a function to set off diagonal elements to a value
function M = set_off_diag(matrix, offset, values)
	M = matrix + diag(values, offset);
end
