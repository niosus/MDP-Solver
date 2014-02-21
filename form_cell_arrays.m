function [coords, occupancy_vector, P, R, gap_period, parking_rows, parking_cols] = form_cell_arrays(filename)
    printf("Writing coordinates to cell array\n");
    fid = fopen(filename);
    init_str = fgetl(fid);
    [P, R, gap_period, parking_rows, parking_cols] = init_P_R(init_str);
    num_of_lots = size(P, 1);
    coords = cell(1, num_of_lots);
    occupancy_vector = zeros(1, num_of_lots);
    for i = 1:num_of_lots
        str = fgetl(fid);
        [x, y, p] = read_parking_lots(str); 
        coords{i} = [x, y];
        occupancy_vector(i) = p;
    endfor
    printf("Done.");
endfunction

