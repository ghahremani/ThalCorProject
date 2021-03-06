% This file explores the topology of structural connectivity in the 96 parcellation (structural matrix)
% thalamic nodes are 41, 42, 43, 89, 90, 91
% Load structural matrix
clear; clc; close all
addpath('/Users/RChenLab/Documents/TVB_Distribution/demo_scripts/Github/ThalCorProject/BCT/BCT/2017_01_15_BCT')
SC_Data=load('Struct_data.mat')
net=SC_Data.data_struct;

% load region labels
load('Region_labels');    % use label to investigate the region labels
%imagesc(net)
figure

%%---------------- thresholding optional
%net=threshold_proportional(net, 0.90) % see Hwang, tried 0.1 to 0.15 and averaged the result

% %% degre measure 
% [id,od,deg] = degrees_dir(net)
% 
% subplot(2,4,1)
% info_plot=deg
% hist(info_plot)
% thal.deg=info_plot([42,44,90,91])
% min(thal.deg)
% max(thal.deg)
% title('degree measure')
% 
% hold on
% 
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(1);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(3);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree

%% ------------------------ strength measure
[is,os,str] = strengths_dir(net)

degree_strength=str; 
subplot(2,4,2)
info_plot=is
hist(info_plot)
thal.deg=info_plot([42,44,90,91])
min(thal.deg)
max(thal.deg)
title('strength measure')

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(1);
plot(x, y, 'r') % but is not large enough
% Thalamic nodes do not seem to be that high degree

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(3);
plot(x, y, 'r') % but is not large enough
%Thalamic nodes do not seem to be that high degree (is it in middle range)
%% ----------------------- Centrality on weighted, directed matrix
BC=betweenness_wei(net);

Bet_cent=BC;  % betweenness centrality on weighted, directed matrix
subplot(2,4,3)
info_plot=BC
hist(info_plot)
thal.deg=info_plot([42,44,90,91])
min(thal.deg)
max(thal.deg)
title('centrality-betweenness_wei')

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(1);
plot(x, y, 'r') % but is not large enough
% Thalamic nodes do not seem to be that high degree

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(3);
plot(x, y, 'r') % but is not large enough
% Two thalamic nuclei have a very high betweenness centrality 347

% %% Centrality measure on the binarized matrix
% W_nrm = weight_conversion(net, 'binarize')
% 
% subplot(2,4,4)
% BC=betweenness_bin(W_nrm);
% info_plot=BC
% hist(info_plot)
% thal.deg=info_plot([42,44,90,91])
% min(thal.deg)
% max(thal.deg)
% title('centrality-betweenness_bin')
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(1);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(3);
% plot(x, y, 'r') % but is not large enough
% % thalamic nuclei show high values for clustering measure
%% ----------------------------------- Clustering measure
W_nrm = weight_conversion(net, 'normalize')
C = clustering_coef_wd(W_nrm)

Clustering=C;
subplot(2,4,5)
info_plot=C
hist(info_plot)
thal.deg=info_plot([42,44,90,91])
min(thal.deg)
max(thal.deg)
title('clustering_coef_wd')
% thalamic nuclei show high values for clustering measure

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(1);
plot(x, y, 'r') % but is not large enough
% Thalamic nodes do not seem to be that high degree

hold on
y=0:0.001:20; % How much is long
x=ones(size(y))*thal.deg(3);
plot(x, y, 'r') % but is not large enough
% %% Community structure
% nNodes=size(net,1);
% ci = zeros(nNodes,1);
% gamma = 1;
% tau = 0.1; 
% nReps = 10;
% 
% for x = 1:500
%     [ci_temp(:,x),q_temp(x,1)] = community_louvain(net,gamma,1:1:nNodes); 
% end
% 
% %estimate a 'consensus' partition (tau and nReps can be altered to change threshold - see https://sites.google.com/site/bctnet/)
% D = agreement(ci_temp);
% ci = consensus_und(D,tau,nReps);
% q = nanmean(q_temp);
% %% flag: 1 out-degree, 2 in-degree, Participation index (BA)  First do the community structure estimation before this step
% BA = zeros(nNodes,1);
% BA = participation_coef(net,ci,2);
% mean(BA)
% BA([41,89, 90, 91])
% 
% subplot(2,4,6)
% info_plot=BA
% hist(info_plot)
% thal.deg=info_plot([42,44,90,91])
% min(thal.deg)
% max(thal.deg)
% title('participation_coef')
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(1);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(3);
% plot(x, y, 'r') % but is not large enough
% %% within-module degree
% Z=module_degree_zscore(net,ci)
% 
% subplot(2,4,7)
% info_plot=Z
% hist(info_plot)
% thal.deg=info_plot([42,44,90,91])
% min(thal.deg)
% max(thal.deg)
% title('within-module degree')
% % sort of towards the higher end
% % two thalamic nuclei have quite high within module degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(1);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*thal.deg(3);
% plot(x, y, 'r') % but is not large enough
% 
% 
% %% %Communicability (hat tip: Bratislav Misic)
% Comm = zeros(nNodes,nNodes);
% CIJ = net;
% N = size(CIJ,1);
% B = sum(CIJ')';
% C = diag(B);
% D = C^(-(1/2));
% E = D * CIJ * D;
% F = expm(E);
% Comm = F.*~eye(N);
% 
% log10_Comm = log10(Comm);
% 
% %% Newman's modularity
% 
% % gamma is the resolution parameter; gamma=1 classic modularity
% gamma=1;
% [Ci Q] = modularity_und(net,gamma);
% 
% %% Rich club 
% [Rw] = rich_club_wd(net);
% 
% % %% Global efficiency
% % L=net.^(-1);  % is this correct?
% % [D,B] = distance_wei(L);
% % [lambda,efficiency,ecc,radius,diameter] = charpath(D);


%% Save them into a matrix
save('SC_metrics.mat','degree_strength','Bet_cent','Clustering')