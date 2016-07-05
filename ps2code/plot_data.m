
function [] = plot_data(data)

set(0,'DefaultLineLineWidth',2)    
set(0,'DefaultAxesFontSize',14)        

neg = find(data.y < 0); 
pos = find(data.y > 0); 

h=plot(data.X(neg,1),data.X(neg,2),'ro'); hold on;
set(h,'MarkerSize',5);

h=plot(data.X(pos,1),data.X(pos,2),'b+'); hold off;
set(h,'MarkerSize',5);

