function [x, y, p] = read_parking_lots(str)
   [misc, numbers] = strread (str, '%s%n');
   x = numbers(1);
   y = numbers(2);
   p = numbers(3);
end
