%Core function for determining the classifying hyperplane
%@a: Normal vector of the hyperplane
%@b: Scalar of the hyperplane
%@xBar: Estimated expectation of x
%@yBar: Estimated expectation of y
%@xCov: Estimated covariance matrix of x
%@yCov: Estimated covariance matrix of y
function [a, b] = Core(xBar, yBar, xCov, yCov)

    % ========CONSTANTS========
    % Tolerance threshould
    tolerance = 1e-5;
    % Delta value for the least-square
    delta = 1e-6;
    % Maximum iteration amount
    maxIteration = 100;
    % Use relative error
    relative = true;

    % ========PREPARATIONS========
    % \Bar{x} - \Bar{y}
    xBarMyBar = xBar - yBar;
    a_0 = xBarMyBar / Squared(xBarMyBar);
    % F orthogonal to \Bar{x} - \Bar{y}
    F = GenerateOrthogonal(xBarMyBar);
    %confirmF(F, xBarMyBar)
    % G, H matrices
    G = F' * xCov * F;
    H = F' * yCov * F;
    % g, h vector
    g = F' * xCov * a_0;
    h = F' * yCov * a_0;
    [n, ~] = size(xBarMyBar);
    
    % ========INIT========
    a_k = zeros(n);
    % beta_1 = 1, eta_1 = 1, k = 1
    beta_k = 1; eta_k = 1; k = 1;
    % Absolute threshold
    betaEtasum = (beta_k + eta_k);
    % Relative threshold
    threshold = 1;
    % Identity delta
    deltaI = delta * eye(n - 1);
    
    % ========LOOP========
    while and(k < maxIteration, threshold > tolerance)
        % Building the least squares matrix
        M_LS = (1 / beta_k) * G + (1 / eta_k) * H + deltaI;
        b_LS = -(1 / beta_k) * g - (1 / eta_k) * h;
        % Solving for a
        % u_k = M_LS \ b_LS;
        u_k = pcg(M_LS, b_LS);
        a_k = a_0 + F * u_k;
        
        % Updating beta and eta
        beta_kup = sqrt(a_k' * xCov * a_k);
        eta_kup = sqrt(a_k' * yCov * a_k);
        
        % Convergence criterion
        betaEtasum_up = beta_kup + eta_kup;
        if (relative)
            % Use relative error
            threshold = abs(betaEtasum_up - betaEtasum) / betaEtasum;
        else
            % Use absolute error
            threshold = betaEtasum_up;
        end
        
        % Update the parameters
        beta_k = beta_kup;
        eta_k = eta_kup;
        betaEtasum = betaEtasum_up;
        k = k + 1;
    end
    
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