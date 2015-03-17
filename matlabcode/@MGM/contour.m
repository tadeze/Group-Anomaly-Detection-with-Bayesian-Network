% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [gmms] = contour(self)
% [gmms] = contour(self)
% draw the contour plot of this MGM model
% this contour shows the modes of normal behaviors of groups

pi = self.pi;
chi = self.chi;
mus = self.mus;
sigmas = self.sigmas;
[K,T] = size(chi);

gmms = cell(1, T);
for ind = 1:T
    subplot(ceil(sqrt(T)),ceil(sqrt(T)),ind);
    gmms{ind} = GMM(chi(:,ind), mus, sigmas);
    contour(gmms{ind});title(sprintf('Weight = %g', pi(ind)));
end
