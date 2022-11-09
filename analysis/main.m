%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022 Meta Platforms, Inc. and affiliates
%
% This repository contains Matlab code associated with our paper:
% 
% Geo-metric: A Perceptual Dataset of Distortions on Faces
% Krzysztof Wolski, Laura Trutoiu, Zhao Dong, Zhengyang Shen, Kevin MacKenzie, Alexandre Chapiro
% Journal track of SIGGRAPH Asia 2022
%
% Contact:
% Krzysztof Wolski (wolskikrzys@gmail.com)
% Alex Chapiro (alex@chapiro.net) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% clear all variables and close all figures
clear all
close all

%% paths
% path to pairwise comparison scaling package by Perez-Ortiz et al.
% package can be downloaded from: https://github.com/mantiuk/pwcmp 
addpath('<scaling_package_path_here>');
% path to the directory containing functions used below
addpath('functions')

%% modify options here
% enables removal of the outliers
remove_outliers = true;
% unifies the labels in the plots so they do not contain unnecessary details
user_firendly_labels = true;
% sets number of bootstrap samples used to compute the confidence intervals
bootstrap_samples = 2000;

%% reading data
S = dataset( 'File', '../SubjectiveData.csv', 'Delimiter', ',' );
D = dataset( 'File', '../Dataset.csv', 'Delimiter', ',' );

% outliers analysis and removal
S = outliers_removal(S);

%% JOD scaling and correlation coefficeints 
% JOD scaling averged over all basemeshes
JODs = fit_and_plot_jod_average(S, bootstrap_samples, user_firendly_labels);
% JOD scaling per basemesh
JODs_per_mesh = fit_jod_per_mesh(S);
% correlation coefficients computation
correlation_coefficients = compute_correlation_coefficients(D, JODs_per_mesh);

%% writing results to CSV files
writetable(JODs,'results/JODs.csv');
writetable(correlation_coefficients,'results/correlation_coefficients.csv');