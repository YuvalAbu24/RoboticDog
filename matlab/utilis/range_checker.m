function range_checker(csvFile)
% RANGE_CHECKER  Display min-max range for every column in a CSV file
% ------------------------------------------------------------------
%   range_checker              – prompts for a CSV and displays table
%   range_checker('file.csv')  – processes the specified file
%
% Assumes the CSV has 13 numeric columns.  Non-numeric entries are read
% as NaN and automatically ignored in the min / max calculation.

    % --- Select file if none given ---
    if nargin < 1 || isempty(csvFile)
        [f, p] = uigetfile('*.csv', 'Select a 13-column CSV file');
        if isequal(f,0),  disp('No file selected.');  return;  end
        csvFile = fullfile(p, f);
    end

    % --- Import data ---
    data = readmatrix(csvFile);               % numeric matrix; NaNs for text
    [nRows, nCols] = size(data);

    % --- Basic sanity check ---
    expectedCols = 13;
    if nCols ~= expectedCols
        warning('Expected %d columns; file contains %d columns.', expectedCols, nCols);
    end

    % --- Compute statistics (NaNs ignored) ---
    colMin = min(data, [], 1, 'omitnan');
    colMax = max(data, [], 1, 'omitnan');

    % --- Build a results table for nice display ---
    results = table( (1:nCols).', colMin.', colMax.', ...
                     'VariableNames', {'Column', 'MinValue', 'MaxValue'});

    % --- Display ---
    fprintf('\nFile: %s  (rows: %d)\n', csvFile, nRows);
    disp(results);

    % --- Optional: save the table back to disk ---
    % writetable(results, 'column_ranges.csv');
end
