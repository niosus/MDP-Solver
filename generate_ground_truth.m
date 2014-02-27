%% generate_ground_truth: A function to generate
%% ground truth information from file
function GroundTruth = generate_ground_truth(filename)
    disp('Generating Ground Truth');
    fid = fopen(filename);
    init_str = fgetl(fid);
    [P, R, gap_period, parking_rows, parking_cols] = init_P_R(init_str);
    num_of_lots = size(P{1}, 1);
    coords = cell(num_of_lots, 1);
    GroundTruth = zeros(num_of_lots, 1);
    for i = 1:num_of_lots
        str = fgetl(fid);
        [x, y, p] = read_parking_lots(str);
        GroundTruth(i) = round(p);
    end
    disp('Done.');
