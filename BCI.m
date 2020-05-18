[rest_data, task_data] = get_data();

rest_psd_data = get_psd(rest_data);
task_psd_data = get_psd(task_data);

% [4, 8]: theta band
% [13, 30]: beta band
% [30, 45]: gamma band
frequency_scopes = [[4, 8]; [13, 30]; [30, 45]];
for index = 1:length(frequency_scopes)
    start_frequency = frequency_scopes(index, 1);
    end_frequency = frequency_scopes(index, 2);
    
    band_power_of_rest_data = get_band_power(rest_psd_data, start_frequency, end_frequency);
    band_power_of_task_data = get_band_power(task_psd_data, start_frequency, end_frequency);
    
    figure;
    plot(band_power_of_rest_data(1, :), band_power_of_rest_data(2, :), 'ro',...
         band_power_of_task_data(1, :), band_power_of_task_data(2, :), 'bo');
    title(compose("Data's band power at %d ~ %d Hz", start_frequency, end_frequency));
    legend('rest', 'task');
    xlabel('F7');
    ylabel('F8');
end


function [rest_data, task_data] = get_data()
    current_folder_path = pwd; % pwd is meant current folder
    eeglab_path = [current_folder_path, '\eeglab14_1_1b\eeglab.m'];
    data_path = [current_folder_path, '\data\ARTRED.CNT'];

    rest_data = cut(data_path, eeglab_path, current_folder_path, 'rest', '11');
    task_data = cut(data_path, eeglab_path, current_folder_path, 'task', '21');
end


function psd_data = get_psd(data)
    data_length = length(data);
    
    psd_data = cell(data_length, 1);
    for row_index = 1:data_length
        psd_data{row_index, 1} = abs(fft(data{row_index, 1}, [], 2)) .^ 2;
    end
end


% get band power at the specified frequency
function band_power = get_band_power(data, start_frequency, end_frequency)
    % frequency resolution is 500/1500 = 1/3
    start_frequency = start_frequency * 3;
    end_frequency = end_frequency * 3;
    
    data_length = length(data);
    
    band_power = zeros(2, data_length);
    for row_index = 1:data_length
        % (5:6, ...) is meant 'get F7 and F8 data'
        band_power(1, row_index) = sum(data{row_index, 1}(5, start_frequency:end_frequency));
        band_power(2, row_index) = sum(data{row_index, 1}(6, start_frequency:end_frequency));
    end
end