%Core function for determining the classifying hyperplane with CVX library
%@a: Normal vector of the hyperplane
%@b: Scalar of the hyperplane
%@xBar: Estimated expectation of x
%@yBar: Estimated expectation of y
%@xCov: Estimated covariance matrix of x
%@yCov: Estimated covariance matrix of y
function [a, b] = CoreCVX(xBar, yBar, xCov, yCov)
    [n, ~] = size(xCov);
    %B = zeros(n, 2);
    xCovSqrt = sqrtm(xCov);
    yCovSqrt = sqrtm(yCov);
    %A1 = [B xCovSqrt];
    %A2 = [B yCovSqrt];
    xBarMyBar = xBar - yBar;
    
    cvx_begin
    
        variable betaK nonnegative
        variable etaK nonnegative
        variable a(n)
        
        minimize (betaK + etaK)
        
        subject to
        
        norm(xCovSqrt * a, 2) <= betaK
        norm(yCovSqrt * a, 2) <= etaK
        xBarMyBar' * a == 1
        
    cvx_end
    
    % ========RETURN========
    betaEtasumK = betaK + etaK;
    b = a' * xBar - (betaK) / (betaEtasumK);
    kappa = 1 / betaEtasumK;
    alpha = kappa^2 / (1 + kappa^2);
    disp('Worst misclassification probability:');
    disp(1 - alpha);
end
