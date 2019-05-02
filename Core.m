%Core function for determining the classifying hyperplane
%@a: Normal vector of the hyperplane
%@b: Scalar of the hyperplane
%@xBar: Estimated expectation of x
%@yBar: Estimated expectation of y
%@xCov: Estimated covariance matrix of x
%@yCov: Estimated covariance matrix of y
function [a, b] = Core(xBar, yBar, xCov, yCov)
% Tolerance threshould
tolerance = 1e-5;
% Maximum iteration amount
maxIteration = 100;
% \Bar{x} - \Bar{y}
% Preparations
dist = xBar - yBar;
a0 = dist / Squared(dist);
% Orthogonal to x - y
F = GenerateOrthogonal(dist);

end

%Determine the orthogonal matrix F given expectation difference.
%@F: The generated matrix
%@xBarMyBar: \Bar{x} - \Bar{y}
function F = GenerateOrthogonal(xBarMyBar)
end

function d2 = Squared(input)
    d2 = transpose(input) * input;
end