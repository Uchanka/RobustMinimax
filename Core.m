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
% Maximum iteration amount
maxIteration = 100;

% ========PREPARATIONS========

% \Bar{x} - \Bar{y}
xBarMyBar = xBar - yBar;
a0 = xBarMyBar / Squared(xBarMyBar);
% F orthogonal to \Bar{x} - \Bar{y}
F = GenerateOrthogonal(xBarMyBar);

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