
function f = svm_discrim_func(X,svm)

f = svm.w0 + feval(svm.kernel,X,svm.XS)*svm.beta;

