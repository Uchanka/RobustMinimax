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
    % G, H n - 1 by n - 1
    G = transpose(F) * xCov * F;
    H = transpose(F) * yCov * F;
    % g, h n - 1 vector
    g = transpose(F) * xCov * a_0;
    h = transpose(F) * yCov * a_0;

    % ========INIT========
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
        u_k = M_LS \ b_LS;
        a_k = a_0 + F * u_k;
        
        % Updating beta and eta
        beta_kup = sqrt(transpose(a_k) * covX * a_k);
        eta_kup = sqrt(transpose(a_k) * covY * a_k);
        
        % Convergence criterion
        betaEtasum_up = beta_kup + eta_kup;
        threshold = abs(betaEtasum_up - betaEtasum) / betaEtasum;
        
        beta_k = beta_kup;
        eta_k = eta_kup;
        betaEtasum = betaEtasum_up;
        k = k + 1;
    end
end

% Validate our orthogonal matrix.
function zeroVal = confirmF(F, vector)
    [n, ~] = size(vector);
    randU = rand(n - 1, 1);
    zeroVal = transpose(vector) * F * randU;
end

function d2 = Squared(input)
    d2 = transpose(input) * input;
end