%Core function for single-class case
%@a: Normal vector of the hyperplane
%@b: Scalar of the hyperplane
%@xBar: Estimated expectation of x
%@xCov: Estimated covariance matrix of x
function [a, b] = CoreSingle(xBar, xCov, alpha)

    % ========CONSTANTS========
    kappa = sqrt(alpha / (1.0 - alpha));
    zeta = sqrt(xBar' * (xCov \ xBar));
    
    % ========RETURN========
    a = a_k;
    b = a_k' * xBar - (beta_k) / (betaEtasum);
    kappa = 1 / betaEtasum;
    alpha = kappa^2 / (1 + kappa^2);
    disp('Worst misclassification probability:');
    disp(1 - alpha);
end

% Utility function.
function d2 = Squared(input)
    d2 = input' * input;
end