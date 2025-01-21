save_dir = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/Figures/Paper/sub_2/A_D';

% load.load_area_info
% mData = load.load_rmaps(mData, data,[2:5])
% load.load_classification
% load.load_selectivity

whichSignal  = 'deconv';
z_score_level = 3;

for i = length(data)-1
    rmaps_A_all_sequenceA =  [];
    rmaps_B_all_sequenceA =  [];
    
    rmaps_A_all_sequenceB = [];
    rmaps_B_all_sequenceB = [];
    
    
    for f = 1:length(data(i).sessionIDs)
        
        sequence = [mData(i,f).OdorA.indices; mData(i,f).TimeA.indices];
        rmaps_A = cat(1,mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence));
        rmaps_B = cat(1,mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence));
        
        rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
        rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
        
        signal_all = [rmaps_A';rmaps_B'];
        normedSignal    = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
        normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
        
        rmaps_A_all_sequenceA = [rmaps_A_all_sequenceA;normedSignal_A];
        rmaps_B_all_sequenceA = [rmaps_B_all_sequenceA;normedSignal_B];
        
        sequence = [mData(i,f).OdorB.indices; mData(i,f).TimeB.indices];
        
        rmaps_A = cat(1,mData(i,f).(whichSignal).rmapsAA(:,1:60,sequence),mData(i,f).(whichSignal).rmapsAB(:,1:60,sequence));
        rmaps_B = cat(1,mData(i,f).(whichSignal).rmapsBB(:,1:60,sequence),mData(i,f).(whichSignal).rmapsBA(:,1:60,sequence));
        
        rmaps_A  = reshape(nanmean(rmaps_A,1),size(rmaps_A,2),size(rmaps_A,3));
        rmaps_B  = reshape(nanmean(rmaps_B,1),size(rmaps_B,2),size(rmaps_B,3));
        
        signal_all = [rmaps_A';rmaps_B'];
        normedSignal   = normalize(signal_all,2,'zscore');%(signal_all  - min(signal_all , [], 2))./(max(signal_all , [], 2) - min(signal_all , [], 2));
        normedSignal_A = normedSignal(1:size(rmaps_A,2),:);
        normedSignal_B = normedSignal(size(rmaps_A,2)+1:end,:);
        
        rmaps_A_all_sequenceB = [rmaps_A_all_sequenceB;normedSignal_A];
        rmaps_B_all_sequenceB = [rmaps_B_all_sequenceB;normedSignal_B];
    end
    
    
    fig = figure();
    [~, idx] = max(rmaps_A_all_sequenceA(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, rmaps_A_all_sequenceA); % Appends idx column array to the ROI matrix.
    sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_B_all_sequenceA);
    sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    rmap_to_plot = sortedMatrix_A; %  ;sortedMatrix_B];
    ax = subplot(2,2,1);
    imagesc(rmap_to_plot,[0,z_score_level]);
    %     yline(size(sortedMatrix_A,1),'Color','w', 'linewidth', 2)
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    set(ax,'FontSize',15)
    xlabel("Time (s)")
    ylabel('Sequence A cells')
    title('Odor A trials')
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    yticks([1 size(sortedMatrix_A,1)])%, size(sortedMatrix_A,1)+size(sortedMatrix_B,1)])
    % yticklabels([1 size(sortedMatrix_A,1), size(sortedMatrix_B,1)])
    
    rmap_to_plot = sortedMatrix_B; %  ;sortedMatrix_B];
    ax = subplot(2,2,2);
    imagesc(rmap_to_plot,[0,z_score_level]);
    %     yline(size(sortedMatrix_B,1),'Color','w', 'linewidth', 2)
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    yticks([1 size(sortedMatrix_B,1)])%
    
    set(ax,'FontSize',15)
    xlabel("Time (s)")
    title('Odor B trials')
    
    [~, idx] = max(rmaps_B_all_sequenceB(:,1:37), [], 2); % Returns 2 arrays. Val is the max value of each ROI, idx is the column index of the max value of each ROI.
    idxMatrix = horzcat(idx, rmaps_A_all_sequenceB); % Appends idx column array to the ROI matrix.
    sortedMatrix_A = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_A(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    idxMatrix = horzcat(idx, rmaps_B_all_sequenceB);
    sortedMatrix_B = sortrows(idxMatrix, 1); % Sorts ROI matrix by the index of their max values in ascending order.
    sortedMatrix_B(: , 1) = []; % Removes indexes from first column of sortedMatrix.
    
    rmap_to_plot = sortedMatrix_A;%;sortedMatrix_B];
    ax2 = subplot(2,2,3);
    imagesc(rmap_to_plot,[0,z_score_level]);
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    set(ax2,'FontSize',15)
    xlabel("Time (s)")
    ylabel('Sequence B cells')
    
    yticks([1 size(sortedMatrix_A,1)])
    yticklabels([1 size(sortedMatrix_A,1)])
    
    rmap_to_plot = sortedMatrix_B;
    ax2 = subplot(2,2,4);
    imagesc(rmap_to_plot,[0,z_score_level]);
    
    xline(1,'Color','r', 'linewidth', 1.5) ; hold on
    xline(6.2,'Color','r', 'linewidth', 1.5)
    xline(37.2,'Color','r', 'linewidth', 1.5)
    xline(43.4,'Color','r', 'linewidth', 1.5)
    
    xticks([1:6.1996:60])
    xticklabels([0:10])
    xlim([1 60])
    set(ax2,'FontSize',15)
    xlabel("Time (s)")
    
    yticks([1 size(sortedMatrix_B,1)])
    yticklabels([1 size(sortedMatrix_B,1)])
    saveas(fig,fullfile(save_dir,strcat('fig_',data(i).area,'.fig')),'fig')
    saveas(fig,fullfile(save_dir,strcat('fig_',data(i).area,'.pdf')),'pdf')
    saveas(fig,fullfile(save_dir,strcat('fig_',data(i).area,'.png')),'png')
end

