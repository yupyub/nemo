function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
n = size(Theta2,1); % This number may not be 10.
R = 0; % Variable for Regularization 
for i = 1:m
	X1 = [1;X(i,:)'];
	Z2 = [1;sigmoid(Theta1*X1)];
	Z3 = sigmoid(Theta2*Z2);
	Yi = zeros(n,1); 
	if(y(i) == 0)
		Yi(10) = 1;
	else 
		Yi(y(i,1)) = 1;
	end
	C = (-Yi).*log(Z3) - (ones(n,1).-Yi).*log(ones(n,1).-Z3);
	J += sum(C);
end;
R += sum(sum(Theta1(:,2:end).^2));
R += sum(sum(Theta2(:,2:end).^2));
J = J*(1/m) + (lambda/(2*m))*R;

%{
% For cost (J)
Z = sigmoid(X*theta);
C = (-y).*log(Z)-(ones(m,1).-y).*log(ones(m,1).-Z);
%oJ = theta.^2;
%oJ(1) = 0;
%same as bilow instruction
%oJ = theta(2:end).^2;
J = (1/m)*sum(C) + (lambda/(2*m))*sum(theta(2:end).^2);

% For grad
oT = (lambda/m)*theta;
% You should not Regularoze "theta(1)", it works for "Bias"
oT(1) = 0;
grad = (1/m)*(X'*(Z-y)) + oT;
%}

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
