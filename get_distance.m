function dist = get_distance(p1, p2)
    diff = p1 - p2;
    dist = sqrt(diff * diff');
end
