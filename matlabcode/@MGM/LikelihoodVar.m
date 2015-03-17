% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [L] = LikelihoodVar(self, lnpdf, group_id)
% [L] = LikelihoodVar(lnpdf, group_id, params)
% the variational likelihood of data.
% lnpdf is the log-density of points under each topic. n x K

phi = self.phi;
gama = self.gama;
logsafe = eps(0.0);

l_point = sum(phi*log(self.chi + logsafe).*gama(:, group_id)', 2) + ...
    sum(phi.*lnpdf, 2) - sum(phi.*log(phi + logsafe), 2);
l_group = log(self.pi' + logsafe)*gama - sum(gama.*log(gama + logsafe), 1);
L = l_group + accumarray(group_id, l_point)';
