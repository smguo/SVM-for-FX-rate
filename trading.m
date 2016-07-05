%% Load data
close all
cd('E:\Google Drive\my code\6.867\project\')
addpath(genpath(pwd))
filename = 'EURUSD_D1.csv' ; % EUR/USD daily data 
fid = fopen(filename, 'rt');
a = textscan(fid, '%s %s %f %f %f %f %f', ...
      'Delimiter',',', 'CollectOutput',1, 'HeaderLines',1);
fclose(fid);
%% Parse data and construct features 
b = [a{2}] ;
t = [a{1}] ; % date and time 
ma_max = 40 ; % maximum moving average period, first ma_max-1 data points need to be deleted for every feature for data size consistence 
cls = b(:,4) ; % closing rate
cls_n = cls/std(cls) ;  % normalization
cls_d1 = diff(cls); % first derivative of the closing rate
cls_d1n = cls_d1/std(cls_d1) ;  % normalization
cls_n(1:ma_max,:)= [] ; % delete data points for data size consistence
cls_d1n(1:(ma_max-1),:)= [] ; % delete data points for data size consistence


opn = b(:,1) ; % opening rate
opn_n = opn/std(opn) ;  % normalization
opn_d1 = diff(opn); % first derivative of the opening rate
opn_d1n = opn_d1/std(opn_d1) ;  % normalization
opn_n(1:ma_max,:)= [] ; % delete data points for data size consistence
opn_d1n(1:(ma_max-1),:)= [] ; % delete data points for data size consistence

low = b(:,3) ; % lowest rate
low_n = low/std(low) ;  % normalization
low_d1 = diff(low); % first derivative of the lowest rate
low_d1n = low_d1/std(low_d1) ;  % normalization
low_n(1:ma_max,:)= [] ; % delete data points for data size consistence
low_d1n(1:(ma_max-1),:)= [] ; % delete data points

hgh = b(:,2) ; % highest rate
hgh_n = hgh/std(hgh) ;  % normalization
hgh_d1 = diff(hgh); % first derivative of the highest rate
hgh_d1n = hgh_d1/std(hgh_d1) ;  % normalization
hgh_n(1:ma_max,:)= [] ; % delete data points for data size consistence
hgh_d1n(1:(ma_max-1),:)= [] ; % delete data points
%% Relative Strength Index
rsi = rsindex(cls, 20) ;
rsi(1:ma_max,:)= [] ;
rsi_n = rsi/100 ;
rsi70 = find(rsi>=70);
rsi30 = find(rsi<=30);
rsi_lab = zeros(size(rsi));
rsi_lab(rsi70) = -1 ;
rsi_lab(rsi30) = 1 ;
for j =2:length(rsi_lab)
    if rsi_lab(j) == 0
      rsi_lab(j)=rsi_lab(j-1) ;
    else
    end
end
%% Moving Average Convergence/Divergence
[macd_v, macd9ma] = macd(cls) ; macd_d = macd_v - macd9ma ;
macd_d(1:ma_max)= [] ;
macd_lab = sign(macd_d) ;
macd_d = macd_d./std(macd_d) ;

%% Stochastic oscillator
sto = stochosc(b(:,2:4)) ;
sto(1:ma_max,:)= [] ;
sto_n = sto/100 ;
stok_n = sto_n(:,1) ;
stod_n = sto_n(:,2) ;
sto80 = find(sto(:,1)>80 & sto(:,2)>80);
sto20 = find(sto(:,1)<20 & sto(:,2)<20);
sto_lab = zeros(size(sto,1),1);
sto_lab(sto80) = -1 ;
sto_lab(sto20) = 1 ;
for j =2:length(sto)
    if sto_lab(j) == 0
      sto_lab(j)=sto_lab(j-1) ;
    else
    end
end
%% Moving average
% moving average of the first derivative of the closing rate with exponetial weight and window size 3
c_d1_ma3 = tsmovavg(cls_d1, 'e', 3, 1) ; 
c_d1_ma3((1:ma_max-1),:)= [] ;
c_d1_ma3 = c_d1_ma3./std(c_d1_ma3) ;

% moving average of the first derivative of the closing rate with
% exponetial weight and window size 5
c_d1_ma5 = tsmovavg(cls_d1, 'e', 5, 1) ;
c_d1_ma5(1:(ma_max-1),:)= [] ;
c_d1_ma5 = c_d1_ma5./std(c_d1_ma5) ;

% moving average of the first derivative of the closing rate with
% uniform weight and window size 5
c_d1_sma5 = tsmovavg(cls_d1, 's', 5, 1) ;
c_d1_sma5(1:(ma_max-1),:)= [] ;
c_d1_sma5 = c_d1_sma5./std(c_d1_sma5) ;

% moving average of the first derivative of the highest rate with
% uniform weight and window size 5
h_d1_sma5 = tsmovavg(hgh_d1, 's', 5, 1) ;
h_d1_sma5(1:(ma_max-1),:)= [] ;
h_d1_sma5 = h_d1_sma5./std(h_d1_sma5) ;

% moving average of the first derivative of the opening rate with
% uniform weight and window size 5
o_d1_sma5 = tsmovavg(opn_d1, 's', 5, 1) ;
o_d1_sma5(1:(ma_max-1),:)= [] ;
o_d1_sma5 = o_d1_sma5./std(o_d1_sma5) ;

% moving average of the first derivative of the lowest rate with
% uniform weight and window size 5
l_d1_sma5 = tsmovavg(low_d1, 's', 5, 1) ;
l_d1_sma5(1:(ma_max-1),:)= [] ;
l_d1_sma5 = l_d1_sma5./std(l_d1_sma5) ;


%% Feature marix and labels
f = [cls_d1n, opn_d1n, hgh_d1n, low_d1n...    
    c_d1_sma5, h_d1_sma5, o_d1_sma5,  l_d1_sma5,...
    rsi_n, macd_d, stok_n, stod_n] ;

f(end,:) = [] ; % delete data points for data size consistence

f_name = {'cls_d1n', 'opn_d1n', 'hgh_d1n', 'low_d1n',...    
    'c_d1_sma5', 'h_d1_sma5',  'o_d1_sma5',  'l_d1_sma5',...
    'rsi_n','macd_d', 'stok_n', 'stod_n'} ;

fea = f(:, [1:12]) ;
f_name = f_name(:, [1:12]) ;

label = sign([hgh_d1n, cls_d1n, low_d1n]); % 3 differnet labels 
label(label == 0) = -1 ;
label(1,:)= [] ; % delete the first data points to make the label are one more time interval than the features

fea_plot = fea(1:1000,:) ; % select the subset of data for plotting
label_plot = label(1:1000,:) ;

%% build SVM classifier
n_train = 200 ; % size of the training set
n_group = 10 ; % number of fold for cross-validation
logC_v = [-1:10] ; % range of log C for grid search 
D_v = [1:5] ; % range of D for grid search for polynomial kernel
logDgs_v = [-0.5:0.5:2.5] ; % range of D for grid search for Gaussian kernel

for lab_ind = 1:size(label,2) 
    
    figure(1) % plot the features
    [h,ax,bigax] = gplotmatrix(fea_plot,[],label_plot(:,lab_ind),...
    'br','so',[1 1],'off','hist',f_name, f_name);
    set(ax, 'TickLabelInterpreter','none')
    set(ax, 'FontSize',6)
%     set(gcf,'position',get(0,'screensize'));
%     legend(gca, 'position', 'eastoutside')
%     lh=findall(gcf,'tag','legend');
%      set(lh,'location','northeastoutside');
%     legend(ax(1,1),'location','northeastoutside');
    print(1 ,'-dpng','-r600', [fig_path,num2str(fig_num, '%03d'),'.png']) ; % export the figure
    print(1 ,'-dpdf','-r300', [fig_path,num2str(fig_num, '%03d'),'.pdf']) ; fig_num = fig_num +1 ; save([work_path, 'startup.mat'], 'fig_num');
   
    errors_pl = zeros(numel(D_v), numel(C_v), n_group) ; % pre-allocate error matrix 
    errors_gs = zeros(numel(logDgs_v), numel(C_v), n_group) ;
    for g = 1:n_group % cross-validation    
        start_ind = n_train*(g-1) ;
         % where the training set begins

        data_train.X = fea(start_ind+1:start_ind+n_train,:) ;
        data_train.Y = label(start_ind+1:start_ind+n_train,lab_ind) ;

        data_test.X = fea ;
        data_test.Y = label(:,lab_ind) ;
        data_test.X(start_ind+1:start_ind+n_train,:)= [] ; % delete training set from the data, use the rest of of data as test set 
        data_test.Y(start_ind+1:start_ind+n_train,:) =[] ;


        % Ploynominal Kernel        
        for Cind = 1:numel(C_v)
            for Dind = 1:numel(D_v)
                C = 10^logC_v(Cind) ;
                D = D_v(Dind) ;
                svm = svm_build(data_train,@(u,v)K_poly(u,v,D),C); % build SVM classifier
                % figure
                %svm_plot(data_train,svm) ;
                % Ds = num2str(D)
                % title(['Poly  D= ' num2str(D)]);
                
                errors_pl(Dind,Cind,g) = svm_test(data_test,svm) ; % test the classifier with test set, save the number of mis-classification events 
                
            end
        end

        % Gaussian Kernel 
        for Cind = 1:numel(C_v)
            for Dind = 1:numel(logDgs_v)       
                D = 10^logDgs_v(Dind) ;
                C = 10^logC_v(Cind) ;
                svm = svm_build(data_train,@(u,v)K_gaussian(u,v,D),C);
                % figure

                %svm_plot(data_train,svm) ;
                % Ds = num2str(D)
                % title(['Poly  D= ' num2str(D)]);                
                errors_gs(Dind,Cind,g) = svm_test(data_test,svm) ;                
            end
        end
    end
    err_per_pl = errors_pl./length(data_test.Y) ; % compute errorrate
    err_per_gs = errors_gs./length(data_test.Y) ;
    fig_gener % plot error rate matrix 
end