% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

classdef MGM
    %MGM multinomial genre model
    % refer to "Liang Xiong, Barnabas Poczos, Jeff Schneider, Hierarchical
    % Probabilistic Models for Group Anomaly Detection, AISTATS 2011" 
    % for details
    
    properties
        pi % T x 1
        chi % K x T
        mus % dim x K
        sigmas % dim x dim x K
        gama % T x M
        phi % N x K
        
        X
        group_id
    end
    
    methods
        function [model] = MGM(pi, chi, mus, sigmas, gama, phi)
            if nargin >= 4
                model.pi = pi;
                model.chi = chi;
                model.mus = mus;
                model.sigmas = sigmas;
                if nargin == 6
                    model.gama = gama;
                    model.phi = phi;
                end
            end
        end
        function [t] = T(self)
            t = size(self.chi, 2);
        end
        function [k] = K(self)
            k = size(self.chi, 1);
        end
    end
    
    methods(Static)
        [mgm, L] = Train(X, group_id, T, K, options);
        [mgm, L] = Train1(X, group_id, T, K, options);
    end
end
