function s = logmulexp(a,b)
%LOGMULEXP        Matrix multiply in the log domain.
% logmulexp(a,b) returns log(exp(a)*exp(b)) while avoiding numerical underflow.
% The * is matrix multiplication.

% Written by Tom Minka
% (c) Microsoft Corporation. All rights reserved.

% s = repmat(a,size(b,2),1) + kron(b',ones(size(a,1),1));
% s = reshape(logsumexp(s,2),size(a,1),size(b,2));

%% the following is by lxiong

ma = max(a, [], 2);
mb = max(b, [], 1);
a = bsxfun(@plus, a, -ma);
b = bsxfun(@plus, b, -mb);

s = log(exp(a)*exp(b));
s = bsxfun(@plus, bsxfun(@plus, s, ma), mb);
