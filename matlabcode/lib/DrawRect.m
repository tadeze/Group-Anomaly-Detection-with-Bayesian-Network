% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [  ] = DrawRect( tblr, width, color, style)
%DrawRect( tblr ) draw a rectangle on the axis

if nargin < 4
    style = '-';
end

xi=[3 4 4 3 3];
yi=[1 1 2 2 1];

if nargin < 3
    color = 'k';
    if nargin < 2
        width = 2;
    end
end

if ~iscell(color)
    color = repmat({color}, 1, size(tblr, 2));
end

for ind=1:size(tblr,2)
    r=tblr(:,ind);
    line(r(xi),r(yi),'LineWidth',width,'Color',color{ind}, 'LineStyle', style);
end
