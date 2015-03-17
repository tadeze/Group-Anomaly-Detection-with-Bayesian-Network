% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [ v ] = choose( cond, v1, v2 )
%[ v ] = choose( cond, v1, v2 )
%CHOOSE immitate the '?' operator in C

if cond
    v=v1;
else
    v=v2;
end
