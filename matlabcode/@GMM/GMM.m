% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

classdef GMM
% gaussian mixture model

    properties
        weights % weights of each components. 1 x n
        means % mean vectors of each component. dim x n
        covars % covariance matrices. dim x dim x n
    end
    
    methods
        function [model] = GMM(weights, means, covars)
            % [model] = GMM(weights, means, covars)
            % covars: if a scalar: all components have covariances eye(dim)*covars
            %         if a n x 1 vector: i-th components have covariances eye(dim)*covars(i)
            %         if a dim x dim matrix: all components have the same covariances covars
            %         if a dim x dim x n tensor: i-th components have covars(:,:,i)
            
            if isempty(weights)
                weights = ones(1, size(means, 2));
            end
            assert(length(weights) == size(means,2), ...
                'number of components should match');
            model.weights = weights(:)';
            model.means = means;
            dim = size(model.means, 1);

            if isscalar(covars) % uniform iso covariance
                covars = repmat(covars*eye(dim), [1,1,length(weights)]);
            elseif size(covars,1) == numel(weights) && size(covars,2) == 1% iso covariance for each component
                assert(numel(weights) == length(covars), 'number of components should match');

                tmp = zeros(dim, dim, numel(weights));
                for ind = 1:numel(weights); 
                    tmp(:,:,ind) = eye(dim)*covars(ind); 
                end
                covars = tmp;
            elseif size(covars,1) == dim && size(covars,2) == dim% same covariance for all 

                if size(covars,3) == 1
                    covars = repmat(covars, [1,1,numel(weights)]);
                elseif size(covars,3) == length(weights) % complete covars
                    assert(size(covars,1) == dim & size(covars,2) == dim, 'dim should match');
                else
                    error('wrong input');
                end
            else
                error('wrong input');
            end

            model.covars = covars;
        end
        
        function [n] = size(self)
            % [n] = size(self)
            % number of components
            
            assert(length(self.weights) == size(self.means,2) ...
                & length(self.weights) == size(self.covars,3),...
                'parameters not consistent');
            n = length(self.weights);
        end
        
        function [d] = dim(self)
            % [dim] = dim(self)
            % dimension of the model
            
            assert(size(self.means,1) == size(self.covars, 1),...
                'parameters not consistent');
            
            d = size(self.means, 1);
        end
        
        function [X, labels] = GenData(self, n)
            % [data, labels] = GenData(self, n)
            % n: number of points
            % data: generated points. one row per point
            % labels: which components generated the points
            
            labels = randm(self.weights/sum(self.weights), n);
            
            X = zeros(n, self.dim());
            for l = 1:size(self)
                idx = labels == l;
                X(idx, :) = mvnrnd(self.means(:,l), self.covars(:,:,l), sum(idx));
            end
        end
        
        function [pdf] = GetProb(self, X, ln_pdf, lb)
            %[pdf] = GetProb(self, X, ln_pdf, lb)
            % probability of points from each component
            
            if nargin < 4
                lb = [];
                if nargin < 3
                    ln_pdf = true;
                end
            end

            K = size(self.means, 2);
            pdf = zeros(size(X, 1), K);
            for k = 1:K
                pdf(:, k) = mvnpdfex(X, self.means(:,k)', self.covars(:,:,k), true);
            end

            if ~isempty(lb); pdf = max(lb, pdf); end
            if ~ln_pdf; pdf = exp(pdf); end
        end
        
        function [L] = Likelihood(self, X)
            % [L] = Likelihood(self, X)
            % compute the log-likelihood of each point under this model
            
            lnpdf = self.GetProb(X, true);
            L = logmulexp(lnpdf, log(self.weights(:)/sum(self.weights) + eps(0.0)));
        end
                        
        function [] = contour(self, ln_pdf)
            % [] = contour(self, ln_pdf)
            % draw the contour plot of the current model's density
            % ln_pdf: if true, draw the log-probability contour
            
            if nargin < 2; ln_pdf = false; end
            
            if self.dim() == 1
                gm = gmdistribution(self.means', self.covars, self.weights./sum(self.weights));
                xmin = inf; xmax = -inf;
                for k = 1:length(self.weights)
                    xmin = min(xmin, self.means(1,k) - 5*sqrt(self.covars(1,1,k)));
                    xmax = max(xmax, self.means(1,k) + 5*sqrt(self.covars(1,1,k)));
                end
                x = linspace(xmin, xmax, 1000)';
                if ln_pdf
                    plot(x, log(pdf(gm, x)), 'b', 'LineWidth', 2);
                else
                    plot(x, pdf(gm, x), 'b', 'LineWidth', 2);
                end
                hold on; plot(self.means, zeros(1,size(self.means,2)), '+'); hold off;
                title(sprintf('GMM %sDensity', choose(ln_pdf, 'Log ', '')));
            elseif self.dim() == 2
                gm = gmdistribution(self.means', self.covars, self.weights./sum(self.weights));
                xmin = inf; xmax = -inf; ymin = inf; ymax = -inf;
                for k = 1:length(self.weights)
                    xmin = min(xmin, self.means(1,k) - 5*sqrt(self.covars(1,1,k)));
                    xmax = max(xmax, self.means(1,k) + 5*sqrt(self.covars(1,1,k)));
                    ymin = min(ymin, self.means(2,k) - 5*sqrt(self.covars(2,2,k)));
                    ymax = max(ymax, self.means(2,k) + 5*sqrt(self.covars(2,2,k)));
                end
                [X Y] = meshgrid(linspace(xmin, xmax, 100), linspace(ymin, ymax, 100));
                Z = pdf(gm, [X(:) Y(:)]);
                if ln_pdf
                    Z = log(Z);
                end
                contour(X, Y, reshape(Z, size(X)));
                hold on; plot(self.means(1,:),self.means(2,:),'k+');hold off;
            else
                warning('cannot draw high-dim models');
            end
            title(sprintf('GMM %sDensity', choose(ln_pdf, 'Log ', '')));
        end
    end
    
    methods(Static)
        function [gmm lh bic] = Train(X, K, options)
            % [gmm lh bic] = Train(X, K, options)
            % training gmm from data
            % K: 
            
            if nargin < 4; options = []; end
            [init, n_try, ridge, max_iter, epsilon, verbose] = GetOptions(options, ...
                'init', 'kmeans', 'n_try', 3, 'ridge', 1e-3, 'max_iter', 200, 'epsilon',1e-5,'verbose',false);
            verbose = choose(verbose, 'iter', 'off');
            
            warning off stats:gmdistribution:FailedToConverge
            if K == 1
                model = gmdistribution.fit(X, 1);
            elseif strcmp(init, 'kmeans')
                [codebook code] = Quantize(X, K);
                if length(unique(code)) < K
                    model = gmdistribution.fit(X, K, 'Start', 'randSample', ...
                        'Replicates', n_try, 'Regularize', ridge,'Options', struct('MaxIter', max_iter, 'Display', verbose));
                else
                    model = gmdistribution.fit(X, K, 'Start', code, ...
                        'Regularize', ridge,'Options', struct('MaxIter', max_iter, 'TolFun',epsilon, 'Display', verbose));
                end                
            else
                model = gmdistribution.fit(X, K, 'Start', 'randSample', ...
                    'Replicates', n_try, 'Regularize', ridge,'Options', struct('MaxIter', max_iter, 'Display', verbose));
            end
            warning on stats:gmdistribution:FailedToConverge
            if ~model.Converged
                fprintf('** GMM EM failed to converge in %d iterations\n', max_iter);
            end
            
            gmm = GMM(model.PComponents, model.mu', model.Sigma);
            lh = -model.NlogL;
            bic = model.BIC;
        end
    end
end
