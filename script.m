% solve_mdp('global_parkings_graph.dat', 'log_11_12_2013_parkings_graph.dat', 10, 4, 10, 'log_11_12_13__params_10_4_10');
% solve_mdp('global_parkings_graph.dat', 'log_11_12_2013_parkings_graph.dat', 10, 4, 90, 'log_11_12_13__params_10_4_90');

solve_mdp('global_parkings_graph.dat', 'log_5_12_2013_parkings_graph.dat', 10, 4, 10, 'log_5_12_14__params_10_4_10_real', 0);
solve_mdp('global_parkings_graph.dat', 'log_5_12_2013_parkings_graph.dat', 10, 4, 20, 'log_5_12_14__params_10_4_20_real', 0);

solve_mdp('global_parkings_graph.dat', 'log_5_12_2013_parkings_graph.dat', 10, 4, 10, 'log_5_12_14__params_10_4_10_artificial', 1);
solve_mdp('global_parkings_graph.dat', 'log_5_12_2013_parkings_graph.dat', 10, 4, 20, 'log_5_12_14__params_10_4_20_artificial', 1);