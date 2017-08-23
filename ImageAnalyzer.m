% Auhor: John
% Purpose: Analyze the rgb data from pictures of video game cases and determine their corresponding console (xbox, playstation, or other)
%
% Note: may need to change mydir and writedir filepaths
% 

%slice_percentage and significance can be modified. Please do not modify anything else unless familiar with matlab
mydir = 'Image database\game cases\cases';
writedir = 'results';
slice_percentage = 0.2;
significance = 0.0;

% initialize variables
files = dir(mydir);
[y1,y2]=size(files);
full_image = zeros(y1-2,3);
slice_image = zeros(y1-2,3);
classified = zeros(y1-2,3);
average = zeros(y1-2,3);
percentages_full = zeros(y1-2,3);
percentages_slice = zeros(y1-2,3);
percentages_average = zeros(y1-2,3);

% for loop that analyzes all database files 
for i=1:y1-2
    % analysis of the entire image
    img = imread(strcat(mydir,'\',files(i+2).name)); % Read image
    [x1,x2,~] = size(img);
    sums = sum(img)/x1;
    sums = sum(sums)/x2;
%   imshow(img)
    full_image(i,1:3) = [sums(1,1,1),sums(1,1,2),sums(1,1,3)];
    percentages_full(i,1:3) = [sums(1,1,1)/sum(sums),sums(1,1,2)/sum(sums),sums(1,1,3)/sum(sums)];
    values = find(sums==max(sums));
    [t1,~] = size(values);
    if t1 > 1
        classified(i,1) = 1;
    else
        classified(i,1) = values(1);
    end
    
    % analysis of the slice of the image
    slice_of_image = img(1:round(x1*slice_percentage),:,:);
%    imshow(slice_of_image);
    [x1,x2,x3] = size(slice_of_image);
    sums = sum(slice_of_image)/x1;
    sums = sum(sums)/x2;
    slice_image(i,1:3) = [sums(1,1,1),sums(1,1,2),sums(1,1,3)];
    percentages_slice(i,1:3) = [sums(1,1,1)/sum(sums),sums(1,1,2)/sum(sums),sums(1,1,3)/sum(sums)];
    values = find(sums==max(sums));
    [t1,~] = size(values);
    if t1 > 1
        classified(i,2) = 1;
    else
        classified(i,2) = values(1);
    end
    
    % analysis of the averages of the images
    temp = [(full_image(i,1)+slice_image(i,1))/2,(full_image(i,2)+slice_image(i,2))/2,(full_image(i,3)+slice_image(i,3))/2];
    percentages_average(i,1:3) = [temp(1,1)/sum(temp),temp(1,2)/sum(temp),temp(1,3)/sum(temp)];
    average(i,1:3) = temp;
    values = find(temp==max(temp));
    [t1,~] = size(values);
    if t1 > 1
        classified(i,3) = 1;
    else
        classified(i,3) = values(1);
    end
end

temp = cell(y1-2,4);
for i=1:y1-2
    if classified(i,1) == 2
        temp(i,1) = {'Xbox'};
    elseif classified(i,1) == 3
        temp(i,1) = {'Playstation'};
    else
        temp(i,1) = {'Unclassified'};
    end
    
    if classified(i,2) == 2
        temp(i,2) = {'Xbox'};
    elseif classified(i,2) == 3
        temp(i,2) = {'Playstation'};
    else
        temp(i,2) = {'Unclassified'};
    end
    
    if classified(i,3) == 2
        temp(i,3) = {'Xbox'};
    elseif classified(i,3) == 3
        temp(i,3) = {'Playstation'};
    else
        temp(i,3) = {'Unclassified'};
    end
    temp(i,4) = {files(i+2).name};
end

test = [full_image, slice_image, average, classified];
[t1,t2,t3] = size(test);
for i=0:(t2/3)-1
    red = test(1:y1-2,(i*3+1));
    green = test(1:y1-2,(i*3+2));
    blue = test(1:y1-2,(i*3+3));
    if i == 0
        filename = strcat(writedir,'\','full_image_rbg_data.xlsx');
        writetable(table(red,green,blue),filename,'Sheet',1,'WriteVariableNames',false);
    elseif i == 1
        filename = strcat(writedir,'\','slice_of_image_rgb_data.xlsx');
        writetable(table(red,green,blue),filename,'Sheet',1,'WriteVariableNames',false);
    elseif i == 2
        filename = strcat(writedir,'\','average_rgb_data.xlsx');
        writetable(table(red,green,blue),filename,'Sheet',1,'WriteVariableNames',false);
    else
        filename = strcat(writedir,'\','classification_of_ full_image_rgb_data.xlsx');
        writetable(table(temp(1:y1-2,4),temp(1:y1-2,1)),filename,'Sheet',1,'WriteVariableNames',false);
        filename = strcat(writedir,'\','classification_of_ sliced_image_rgb_data.xlsx');
        writetable(table(temp(1:y1-2,4),temp(1:y1-2,2)),filename,'Sheet',1,'WriteVariableNames',false);
        filename = strcat(writedir,'\','classification_of_average_rgb_data.xlsx');
        writetable(table(temp(1:y1-2,4),temp(1:y1-2,3)),filename,'Sheet',1,'WriteVariableNames',false);
    end
end