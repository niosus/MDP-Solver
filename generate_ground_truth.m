%% generate_ground_truth: A function to generate
%% ground truth information from file
function GroundTruth = generate_ground_truth(Filename)
    disp('Generating Ground Truth');
    fid = fopen(Filename);
    InitString = fgetl(fid);
    [P, R, GapPeriod, ParkingRows, ParkingCols] = init_P_R(InitString);
    NumOfParkingLots = size(P{1}, 1);
    Coordinates = cell(NumOfParkingLots, 1);
    GroundTruth = zeros(NumOfParkingLots, 1);
    for i = 1:NumOfParkingLots
        Str = fgetl(fid);
        [x, y, p] = read_parking_lots(Str);
        GroundTruth(i) = round(p);
    end
    disp('Done.');
