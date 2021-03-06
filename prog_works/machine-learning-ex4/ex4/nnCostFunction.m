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

%part 1 forward propagation
% X = [ones(m,1) X];
% a2 = sigmoid(Theta1*X');

% a2 = [ones(m,1) a2'];
% a3 = sigmoid(Theta2*a2');
% a3 = a3';

% J = (1/m)*(-y.*sum(log(a3),2)+(1-y).*sum(log(1-a3),2));

% ys = zeros(m, num_labels);
% for i = 1:m
% 	ys(i,y(i)) = 1;
% end

% %part 2 back propagation
% for i = 1:m
%     delta3 = a3(i,:) - ys'(i,:);
%     delta2 = (Theta2' * delta3) .* (sigmoidGradient(z2));
% end


% Part1 Feedfoward the neural network
% 1.Calculate the cost
X = [ones(m,1) X];                 % add a column of ones
for i = 1:m
    a1 = X(i,:);
    a1 = a1';                      % a1 is a column vector
    % layer 2
    z2 = Theta1 * a1;              % z2 is a 25x1 column vector
    a2 = sigmoid(z2);              % calculate the a2, a2 is a 25x1 column vector
    a2 = [1; a2];                  % add a bias term
    % layer 3
    z3 = Theta2 * a2;              
    a3 = sigmoid(z3);              % calculate the a3 which is the output, a3 is a column vector

    p = zeros(num_labels, 1);      % p is 10x1 column vector
    p(y(i)) = 1;
    J = J + sum((-p).*log(a3) - (1-p).*log(1-a3));

    % backpropagation;
    delta3 = a3 - p;                                            % delta3 is a 10x1 column vector
    delta2 = Theta2(:,2:end)' * delta3 .* sigmoidGradient(z2);  % delta2 is a 25x1 column vector
    Theta1_grad = Theta1_grad + delta2 * a1';
    Theta2_grad = Theta2_grad + delta3 * a2';
end
J = J / m;
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

% 2.Regularization for cost
temp1 = Theta1(:,2:size(Theta1,2)).^2; 
temp2 = Theta2(:,2:size(Theta2,2)).^2;
    % notice that subtract bias terms
reg = lambda / (2*m) * (sum(temp1(:)) + sum(temp2(:)));
J = J + reg; 
% 3.Regularization for backpropagation (not to regularize bias terms)
Theta1(:,1) = 0;
Theta2(:,1) = 0;
Theta1_grad = Theta1_grad + lambda / m * Theta1;
Theta2_grad = Theta2_grad + lambda / m * Theta2;






% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end