err_per_pl_m = mean(err_per_pl,3)*100;
err_per_gs_m = mean(err_per_gs,3)*100;
% csvwrite('E:\my\mit\school\6.867\project\temp.csv',m)
%%
figure(20)
imshow(err_per_pl_m, 'InitialMagnification', 'fit')
    %axis([1 size(X,1) 1 size(X,2)]); 
    axis on
    colormap(jet)
    h = colorbar ;
    caxis auto
title('Classification error(%)','FontSize',20)
xlabel('log_{10} C','FontSize',10)
ylabel('D','FontSize',10)
set(gca, 'xtick',[1:12])
set(gca, 'ytick',[1:12])
set(gca, 'xticklabel',logC_v)
set(gca, 'yticklabel',D_v)
format_fig2(1)

%%
figure(21)
imshow(err_per_gs_m, 'InitialMagnification', 'fit')
    %axis([1 size(X,1) 1 size(X,2)]); 
    axis on
    colormap(jet)
    h = colorbar ;
    caxis auto
title('Classification error(%)','FontSize',20)
xlabel('log_{10} C','FontSize',10)
ylabel('log_{10} D','FontSize',10)

set(gca, 'ytick',[1:12])
set(gca, 'xtick',[1:12])
set(gca, 'xticklabel',logC_v)
set(gca, 'yticklabel',logDgs_v)
format_fig2(1)
%%
print(20 ,'-dpng','-r300', [fig_path,num2str(fig_num, '%03d'),'.png']) ; 
print(20 ,'-dpdf','-r300', [fig_path,num2str(fig_num, '%03d'),'.pdf']) ; fig_num = fig_num +1 ; save([work_path, 'startup.mat'], 'fig_num');
print(21 ,'-dpng','-r300', [fig_path,num2str(fig_num, '%03d'),'.png']) ; 
print(21 ,'-dpdf','-r300', [fig_path,num2str(fig_num, '%03d'),'.pdf']) ; fig_num = fig_num +1 ; save([work_path, 'startup.mat'], 'fig_num');   