
function [] = svm_plot(data,svm)

plot_data(data); hold on;

% plot support vectors
h=plot(svm.XS(:,1),svm.XS(:,2),'ko');
set(h,'MarkerSize',10); 
 
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
