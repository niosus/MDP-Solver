function [P, R, gap_period, parking_rows, parking_cols] = init_P_R(str)
   [misc, numbers] = strread (str, '%s%n');
   parking_rows = numbers(1);
   parking_cols = numbers(2);
   gap_period = numbers(3);
   num = parking_rows * parking_cols;
   P = cell(1,5);
   R = cell(1,5);
   for i=1:5
       P{i} = zeros(num);
       R{i} = zeros(num);
   end
end

