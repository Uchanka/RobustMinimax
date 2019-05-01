%Core function for determining the classifying hyperplane
%@a: Normal vector of the hyperplane
%@b: Scalar of the hyperplane
%@xBar: Estimated expectation of x
%@yBar: Estimated expectation of y
%@xCov: Estimated covariance matrix of x
%@yCov: Estimated covariance matrix of y
function [a, b] = Core(xBar, yBar, xCov, yCov)
end

%Determine the orthogonal matrix F given expectation difference.
%@F: The generated matrix
%@xBarMyBar: \Bar{x} - \Bar{y}
function F = GenerateOrthogonal(xBarMyBar)
end