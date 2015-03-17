% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ y ] = NNClassify( samples, prototypes )
% [ y ] = nnclassify( samples, prototypes )
% each sample is a row

edges = KNN(samples, prototypes, 1);
y = edges(:, 2);
