function [whisk_pow,conditions,all_combos, ntrials] = plot_whisk_pow(data_table,varargin)

% defaults parameters
params = struct(...
    'CNO'                , [false true],... 
    'postlesion_ION'     , [false true],...
    'essai_tente'        , [      true],...
    'reward_zone_width'  , [        30],...
    'essai_interessai'   , [      true],...
    'hold_time'          , 1           ,...
    'reussite'           , [      true],...
    ...
    'wind'         , 400,  ... % in ms, length of Hamming window
    'noverlap'     , 75,   ... % window overlap, in % of 'wind'
    'nlog'         , false, ... % log normalize
    ...
    'fs'           ,1000,...
    'whisk_band'   ,[5 12]...
    );

params = parse_input_params(params,varargin);

[whisk_pow,conditions,all_combos, ntrials] = whisker_freq(data_table,params);

num_combos = size(all_combos,1);

varied_conds_idx = find(any(diff(all_combos)));
varied_conds     = conditions(any(diff(all_combos)));
other_conds_idx  = find(~any(diff(all_combos)));
other_conds      = conditions(~any(diff(all_combos)));

% [mean, sem];
whisk_all = nan(num_combos,2);
whisk_hold= nan(num_combos,2);

% low_all = nan(num_combos,2);
% med_all = nan(num_combos,2);
% hi_all  = nan(num_combos,2);
% low_hold= nan(num_combos,2);
% med_hold= nan(num_combos,2);
% hi_hold = nan(num_combos,2);
leg_str = cell(num_combos,1);

for combo = 1:num_combos
    whisk_all(combo,1)  = mean(cell2mat(whisk_pow.all(combo,:)));
    whisk_all(combo,2)  = std(cell2mat(whisk_pow.all(combo,:)))./sqrt(ntrials(combo));
    whisk_hold(combo,1) = mean(cell2mat(whisk_pow.hold(combo,:)));
    whisk_hold(combo,2) = std(cell2mat(whisk_pow.hold(combo,:)))./sqrt(ntrials(combo));
    
%     low_all(combo,1)  = mean(freq_pow.low_band(combo,1:ntrials(combo)));
%     low_all(combo,2)  = std(freq_pow.low_band(combo,1:ntrials(combo)))./sqrt(ntrials(combo));
%     low_hold(combo,1) = mean(freq_pow.low_band_hold(combo,1:ntrials(combo)));
%     low_hold(combo,2) = std(freq_pow.low_band_hold(combo,1:ntrials(combo)))./sqrt(ntrials(combo));
%     
%     med_all(combo,1)  = mean(freq_pow.med_band(combo,1:ntrials(combo)));
%     med_all(combo,2)  = std(freq_pow.med_band(combo,1:ntrials(combo)))./sqrt(ntrials(combo));
%     med_hold(combo,1) = mean(freq_pow.med_band_hold(combo,1:ntrials(combo)));
%     med_hold(combo,2) = std(freq_pow.med_band_hold(combo,1:ntrials(combo)))./sqrt(ntrials(combo));
%     
%     hi_all(combo,1)  = mean(freq_pow.hi_band(combo,1:ntrials(combo)));
%     hi_all(combo,2)  = std(freq_pow.hi_band(combo,1:ntrials(combo)))./sqrt(ntrials(combo));
%     hi_hold(combo,1) = mean(freq_pow.hi_band_hold(combo,1:ntrials(combo)));
%     hi_hold(combo,2) = std(freq_pow.hi_band_hold(combo,1:ntrials(combo)))./sqrt(ntrials(combo));  
    
    for i = 1:length(varied_conds)
        leg_str{combo} = [leg_str{combo} strrep(sprintf('%s=%d ',varied_conds{i},all_combos(combo,varied_conds_idx(i))),'_','\_')];
    end
    leg_str{combo} = sprintf('%s, N=%d',leg_str{combo},ntrials(combo));
end

figure;

% bar_data_all = [low_all(:,1) med_all(:,1) hi_all(:,1)]';
% bar_err_all  = [low_all(:,2) med_all(:,2) hi_all(:,2)]';
% 
% bar_data_hold = [low_hold(:,1) med_hold(:,1) hi_hold(:,1)]';
% bar_err_hold  = [low_hold(:,2) med_hold(:,2) hi_hold(:,2)]';

bar_data = [whisk_all(:,1)'; whisk_hold(:,1)'];
bar_err  = [whisk_all(:,2)'; whisk_hold(:,2)'];
% bar_data_hold= whisk_hold(:,1);
% bar_err_hold = whisk_hold(:,2);

% subplot(2,1,1);
% barwitherr(bar_err_all, bar_data_all);
barwitherr(bar_err,bar_data);

    set(gca,'XTickLabel',{'entire trials', 'hold time'})
    legend(leg_str)
    ylabel('mean power');
    title('mean power in [5-12]Hz band');
%     
% subplot(2,1,2);
% barwitherr(bar_err_hold, bar_data_hold);
% 
%     set(gca,'XTickLabel',{'[5-12]Hz Power'})
%     legend(leg_str)
%     ylabel('mean power');
%     title('mean power for hold time');
    
note_str = {};    
for i = 1:length(other_conds)
    note_str = [note_str strrep(sprintf('%s=%d ',other_conds{i},all_combos(1,other_conds_idx(i))),'_','\_')];
end
annotation('textbox',[0 0 1 1],'String',note_str,'FitBoxToText','on');


end