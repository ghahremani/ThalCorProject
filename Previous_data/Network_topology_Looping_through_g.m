% Network Topology
clear; clc; 
addpath('/Users/RChenLab/Documents/TVB_Distribution/demo_scripts/Github/ThalCorProject/BCT/BCT/2017_01_15_BCT')
count=0;
for G={'0.0', '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.8', '1.0'}
    
count=count+1;
Data=load(['FC_with_thal_gLoop' char(G) '.mat'])
net=Data.data_struct;
SC_Data=load('data_struct.mat')
struct=SC_Data.data_struct;
% if you want to get rid of negative weights
% optional
% net(net<0)=0;
%net=abs(net);
% net=threshold_proportional(net, 0.90); % see Hwang, tried 0.1 to 0.15 and averaged the result
%% Community structure
nNodes=size(net,1);
ci = zeros(nNodes,1);
gamma = 1;
tau = 0.1; 
nReps = 10;

for x = 1:500
    [ci_temp(:,x),q_temp(x,1)] = community_louvain(net,gamma,1:1:nNodes,'negative_asym'); 
end

%estimate a 'consensus' partition (tau and nReps can be altered to change threshold - see https://sites.google.com/site/bctnet/)
D = agreement(ci_temp);
ci = consensus_und(D,tau,nReps);
q = nanmean(q_temp);

%% Participation index (BA)  First do the community structure estimation before this step
BA = zeros(nNodes,1);
BA = participation_coef_sign(net,ci);
Integ_BA(count)=mean(BA)
BA([41, 42, 43, 89, 90, 91])

% subplot(2,4,6)
% info_plot=BA
% hist(info_plot)
% thal.deg=info_plot([41, 42, 43, 89, 90, 91])
% min(thal.deg)
% max(thal.deg)
% title('participation_coef')
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*min(thal.deg);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*max(thal.deg);
% plot(x, y, 'r') % but is not large enough

%% Integration: inverse modularity Q^-1
Integ_q(count)=q^-1;

%% Global efficiency
L=net.^(-1);  % is this correct? Shine do not explain how they convert their weight matrix into a distance matrix
[D,B] = distance_wei(L);
[lambda,efficiency,ecc,radius,diameter] = charpath(D);

%% Clustering coefficient
[C_pos,C_neg,Ctot_pos(count),Ctot_neg] = clustering_coef_wu_sign(net);  % (default) Onnela et al. formula, used in original clustering_coef_wu.m. Computed separately for positive & negative weights

%% Plot grid_communities
% [X,Y,INDSORT] = grid_communities(ci); % call function
% figure
% imagesc(net(INDSORT,INDSORT));           % plot ordered adjacency matrix
% hold on;                                 % hold on to overlay community visualization
% plot(X,Y,'r','linewidth',2);   


%% compute correlation between structural and functional data
CORR(count)=corr(reshape(net,[96*96,1]),reshape(struct,[96*96,1]))

end

%% This explores SC data and calculates which nodes fall into the same degree match
%% Degree calculation and find degree matched nodes (falling in Mean+-2SD)
% figure
% [is,os,str] = strengths_dir(struct)
% 
% subplot(2,4,2)
% info_plot=str
% hist(info_plot)
% thal.deg=info_plot([41, 42, 43, 89, 90, 91])
% MEAN=mean(thal.deg);
% SD=sqrt(var(thal.deg))
% min(thal.deg)
% max(thal.deg)
% title('strength measure')
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*(MEAN+2*SD);
% plot(x, y, 'r') % but is not large enough
% % Thalamic nodes do not seem to be that high degree
% 
% hold on
% y=0:0.001:20; % How much is long
% x=ones(size(y))*(MEAN-2*SD);
% plot(x, y, 'r') % but is not large enough
% [a,deg_matched_indeces]=find((MEAN+2*SD)<str & str>(MEAN-2*SD));

%% Plot as a function of global coupling
g=[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0]
figure
subplot(1,5,1)
plot(g,Integ_q,'b')
title('inverse modularity')
subplot(1,5,2)
plot(g,Integ_BA,'b')
title('participation coefficient')
subplot(1,5,3)
plot(g,Ctot_pos,'b')
title('clustering coefficient')
subplot(1,5,4)
plot(g,CORR,'b')
title('SC FC correlation')



    
    