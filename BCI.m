% get data, see line 39
[rest_data, task_data] = get_data();

% get psd of signal data
rest_psd_data = get_psd(rest_data);
task_psd_data = get_psd(task_data);

% [4, 8]: theta band
% [13, 30]: beta band
% [30, 45]: gamma band
frequency_scopes = [[4, 8]; [13, 30]; [30, 45]];
for index = 1:length(frequency_scopes)
    % - first:
    %    - start_frequency = 4
    %    - end_frequency = 8
    % - second:
    %    - start_frequency = 13
    %    - end_frequency = 30
    % - ...
    start_frequency = frequency_scopes(index, 1);
    end_frequency = frequency_scopes(index, 2);
    
    % get band power of signal between start_frequency and end_frequency
    band_power_of_rest_data = get_band_power(rest_psd_data, start_frequency, end_frequency);
    band_power_of_task_data = get_band_power(task_psd_data, start_frequency, end_frequency);
    
    % ↓↓↓ plotting ↓↓↓
    figure;
    plot(band_power_of_rest_data(1, :), band_power_of_rest_data(2, :), 'ro',...
         band_power_of_task_data(1, :), band_power_of_task_data(2, :), 'bo');
    title(compose("Data's band power at %d ~ %d Hz", start_frequency, end_frequency));
    legend('rest', 'task');
    xlabel('F7');
    ylabel('F8');
    % ↑↑↑ plotting ↑↑↑
end


function [rest_data, task_data] = get_data()
    % path setting
    current_folder_path = pwd; % pwd is meant current folder
    eeglab_path = [current_folder_path, '\eeglab14_1_1b\eeglab.m'];
    data_path = [current_folder_path, '\data\ARTRED.CNT'];
    
    % TA provided, and we could get rest_data and task data by this function
    rest_data = cut(data_path, eeglab_path, current_folder_path, 'rest', '11');
    task_data = cut(data_path, eeglab_path, current_folder_path, 'task', '21');
end


function psd_data = get_psd(data)
    % psd[n] = |F[n]|^2
    
    % get n, n is data length
    data_length = length(data);
    
    psd_data = cell(data_length, 1);
    % from F[1] to F[n]
    for row_index = 1:data_length
        % | sth. | = abs() in matlab, for example:
        % -----
        % >>> x = 3 + 4j
        % >>> disp(abs(x))
        % 5
        % -----
        % and we can consider F[n] = fft(signal) in matlab = x, thus:
        % psd[n] = abs(fft(F[n])) .^ 2
        %
        % P.S. .^ is meant square each element of a matrix in matlab
        psd_data{row_index, 1} = abs(fft(data{row_index, 1}, [], 2)) .^ 2;
    end
end


% get band power between two specified frequencies
function band_power = get_band_power(data, start_frequency, end_frequency)
    % band power is also called bp
    % bp = sum psd[n], n between two specified frequencies
    
    % frequency resolution (Fr)
    % Fr = Fs / n
    %
    % - Fs: sampling frequency, this HW's Fs = 500
    % - n: data length
    %     - n = Fs * t(time)
    %     - n = 500 * 3 = 1500
    
    % thus, Fr = 500 / 1500 = 1/3
    %
    % in spectrum, ω_k = k * Fr, k = 0, 1, 2, ..., n - 1
    % and we can assume ω = [4, 8] (theta band)
    %          ω_k = k * Fr
    %       [4, 8] = k * 1/3
    %            k = [4, 8] * 3
    %            k = [12, 24]
    % thus, start_frequency and end_frequency times 3
    start_frequency = start_frequency * 3;
    end_frequency = end_frequency * 3;
    
    % get n, n is data length
    data_length = length(data);
    
    band_power = zeros(2, data_length);
    for row_index = 1:data_length
        % (5:6, ...) is meant 'get F7 and F8 data'
        band_power(1, row_index) = sum(data{row_index, 1}(5, start_frequency:end_frequency));
        band_power(2, row_index) = sum(data{row_index, 1}(6, start_frequency:end_frequency));
    end
end
