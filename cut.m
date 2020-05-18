function data = cut(loaddata_path, loadEEGlab_path, save_path, data_name, trigger )
    % run(loadEEGlab_path);
    
    EEG.etc.eeglabvers = '14.1.1'; 
    EEG = pop_loadcnt(loaddata_path , 'dataformat', 'auto', 'memmapfile', ''); 
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  trigger  }, [-1  3], 'newname', 'CNT file epochs', 'valuelim', [-80000  80000], 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, [-100  0]);
    EEG = eeg_checkset( EEG );

    test_data = double(EEG.data(:,501:end,:)); 
    test_data(1:2,:,:) = [];
    trails = size(test_data,3);
    channel = [1,2,3,4,5,6,25];
    data = cell( trails , 1 );
    for i = 1:trails
        data{i,1} = test_data( channel , 1+1500*(i-1):1500*i );
    end
    save([save_path, data_name,'.mat'], 'data') 

end