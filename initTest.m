function [test_x, test_y] = initTest()
% This script extracts testing data from the MIT-BIH Arrythmia Database
% 
% Output values returned are:
%   data_x: 4-D double containing the input data in the following form
%       [128 1 1 numberOfReadings]
%   target_y: 1-D Categorial containing the signal labels
%       [numberOfReadings 1]
%
% Author: 06/15/17 - by Arshan Hashemi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num = 1;
fs = 360; % sample rate for MIT-BIH Arrhytmia Database
%samples = 646400; % samples for 30 minutes
samples = 646400;

test_files = {'mitdb/101', 'mitdb/107', 'mitdb/111', 'mitdb/119',... 
    'mitdb/200', 'mitdb/209', 'mitdb/222', 'mitdb/212', 'mitdb/214',...
    'mitdb/124'};

% Training files to split data by time or random(Test 1 and 2)
%training_files = {'mitdb/100', 'mitdb/232','mitdb/109', 'mitdb/106'...
 %   'mitdb/102', 'mitdb/118', 'mitdb/207','mitdb/231', 'mitdb/103',...
  %  'mitdb/208', 'mitdb/112', 'mitdb/214', 'mitdb/104', 'mitdb/201',...
   % 'mitdb/203', 'mitdb/116', 'mitdb/215','mitdb/101', 'mitdb/107',... 
    %'mitdb/111', 'mitdb/119', 'mitdb/200', 'mitdb/209', 'mitdb/222',...
   % 'mitdb/212', 'mitdb/217','mitdb/124', 'mitdb/115', 'mitdb/213',...
   % 'mitdb/222', 'mitdb/209', 'mitdb/234', 'mitdb/221', 'mitdb/223',...
   % 'mitdb/209', 'mitdb/114', 'mitdb/108', 'mitdb/121', 'mitdb/123'...
   % 'mitdb/231', 'mitdb/233'};

j = 1;

for f = 1 : length(test_files)
filename = char(test_files(f))
[tm, signal]=rdsamp(filename, 1, samples);
signal = signal(:,1);

[ann,type,~,~]=rdann(filename,'atr',[],samples);

for k = 1 : size(ann,1)
  if ann(k) <= samples
      stop = k;
  end
end

ann = ann(1 : stop);
type = type(1 : stop);

data = zeros(1000, 128);
target(500) = char(0);

%start = 1;
%set start to 5 minutes into recording (recording ~30 minutes in length)
start = ceil(stop/6);

%if (ann(1) < 64)
%    start = 3;
%end

stop = stop - 5;

% 6 Types of beats: Normal, Paced, Left BBB, PVC, APC, RIGHT BBB
%                   N, /, L, V, A, R
for k = start : stop    
    if type(k) == 'N' || type(k) == '/' || type(k) == 'L' ||...
            type(k) == 'V' || type(k) == 'A' || type(k) == 'R'
        for i = 1 : 128
            data(j,i) = signal(ann(k) - 63 + i);
        end
        test_x(:,1,1,j) = data(j, :);
        target(j) = type(k);
        %j = j + 1;
    end
end
end

test_y = categorical(cellstr(target'));