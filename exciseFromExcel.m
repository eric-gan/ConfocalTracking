%=========================================================================
% exciseFromExcel.m
%   Loads two excel spreadsheets, one with the file names as Strings and 
%   one with the start and end indices as Integers. Then calls
%   exciseTrackingData to add the start and end indices to the original
%   data file.
%
%   INPUTS:
%       nameFile: excel spreadsheet with data file names in String
%       indicesFile: excel spreadsheet with start and end indices in
%                    Integers
%
%   OUTPUT: none
%
%   Written by: Eric Gan
%=========================================================================
function exciseFromExcel(nameFile, indicesFile)

%Read in the nameFile and indicesFile into cell arrays
[~, txt, ~] = xlsread(nameFile);
indices = xlsread(indicesFile);

%Loop through each file and excise the desired indices
for I = 1:size(txt, 1)
        exciseTrackingData(txt{I,1}, indices(I,1), indices(I,2));
end