function [P, R, gap_period, parking_rows, parking_cols] = init_P_R(str)
   [misc, numbers] = strread (str, "%s%n");
   parking_rows = numbers(1);
   parking_cols = numbers(2);
   gap_period = numbers(3);
   num = parking_rows * parking_cols;
   P = cell(1);
   R = cell(1);
   P{1} = zeros(num);
   R{1} = zeros(num);
endfunction

