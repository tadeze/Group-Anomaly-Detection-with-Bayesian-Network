
function [] = ADAMSRun(infile, T, K)
%%
in = csvread(infile, 1, 0);
group_id = int32(in(:,1));
if min(group_id) < 1
    group_id = group_id + 1;
end

X = in(:,2:size(in,2));
options = struct('n_try', 3, 'para', false, 'verbose', true, ...
    'epsilon', 1e-5, 'max_iter', 50, 'ridge', 1e-2);


%% apply MGM

mgm = MGM.Train(X, group_id, T, K, options);
ts_mgm = -mgm.ScoreVar(X, group_id);
scores_mgm = ProcScore(ts_mgm);

% Group Type inference
lnpdf = GMM([], mgm.mus, mgm.sigmas).GetProb(X, false);
m = length(unique(group_id));
probGr = zeros(m, T);
for i = 1:m
    for t = 1:T
        probGr(i,t) = log(mgm.pi(t));
        idx = find(group_id==i);
        for n = 1:length(idx)
            probGr(i,t) = probGr(i,t) + log(sum(mgm.chi(:,t)' .* lnpdf(idx(n),:)));
        end
    end
end

%%
csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_Score.csv'), scores_mgm);
csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_GroupType.csv'), probGr);
 csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_Pi.csv'), mgm.pi)
 csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_Chi.csv'), mgm.chi)
 csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_Mus.csv'), mgm.mus)
 csvwrite(strcat('T', num2str(T), '_K', num2str(K), '_Sigmas.csv'), mgm.sigmas)
