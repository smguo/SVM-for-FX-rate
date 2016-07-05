
function [svm gamma]= svm_build(data,kernel,C)

y = data.Y;
X = data.X;

n = length(y);  % y is n x 1

% initialize A matrix
A = feval(kernel,X,X); 
A = diag(y)*A*diag(y);

% solve dual problem...
options_org = optimset(@quadprog);
options = optimset(options_org, 'MaxIter',int32(10000));
alpha = quadprog(A,-ones(n,1),[],[],y',0,zeros(n,1),repmat(C,n,1), zeros(n,1), options);

% select support vectors
svm_eps = max(alpha)*1e-8; 
S = find(alpha > svm_eps);
NS = length(S);

beta = alpha(S).*y(S);
XS = X(S,:);

% also, calculate w0 offset parameter

index=find(alpha(S)<C);
y_w_phi = A(S(index),S)*alpha(S); % sum_j y_i K(x_i,x_j) y_j$. 

w0_est = y(S(index)) - y(S(index)).*y_w_phi; % y_i - sum_j K(x_i,x_j) y_j

% display(index);
% display(w0_est);
w0 = median(w0_est);  % median of slightly varying estimates of w0

svm.kernel = kernel;
svm.NS = NS; 
svm.w0 = w0;
svm.beta = beta;
svm.XS = XS;
svm.C  = C;

%computing the margin gamma
theta_norm=sqrt(alpha(S)'*(A(S,S)*alpha(S)));
gamma=1/theta_norm;
svm.gamma=gamma;
