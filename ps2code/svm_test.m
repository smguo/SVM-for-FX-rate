function [errors] =svm_test(data,svm)

y_p=sign(svm_discrim_func(data.X,svm));
error_indices = find(y_p~=data.Y);
errors=length(error_indices);

% if data is 2D make a plot indicating the misclassified points.
sz = size(data.X);
if sz(2) == 2
    misclassified_points = data.X(error_indices,1:2);

    plot_data(data); hold on;

    h=plot(misclassified_points(:,1),misclassified_points(:,2),'yx');
    set(h,'MarkerSize',10); 
    tle =['n(error)= ', num2str(errors)] ;
    title(tle, 'FontSize',18);

    myax = axis;
    m = 50; % grid points for contour
    tx = myax(1) + (myax(2)-myax(1))*(0:m)'/m;
    ty = myax(3) + (myax(4)-myax(3))*(0:m)'/m;
    [n,d] = size(data.X);

    Z = zeros(m+1,m+1);
    for i=1:m+1,
        X = [tx,repmat(ty(i),m+1,1)];
        Z(:,i) = svm_discrim_func(X,svm);
    end;

    contour(tx,ty,Z',[0 0],'LineWidth',2,'LineColor','k'); 
    contour(tx,ty,Z',[1 1],'LineWidth',1,'LineStyle','--','LineColor','k'); 
    contour(tx,ty,Z',[-1 -1],'LineWidth',1,'LineStyle','--','LineColor','k');
    hold off;
end;