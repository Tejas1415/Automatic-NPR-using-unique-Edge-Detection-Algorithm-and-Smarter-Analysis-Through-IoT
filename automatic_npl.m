clc                    % Clear the MATLAB environment.
close all
clear all

a=imread('car.jpg');   % Input the image of the car with a visible number plate 
figure,imshow(a);
I2=rgb2gray(a);        % Convert to grey scale if the i/p is rgb.

I3=im2double(I2);
figure
imshow(I2); title('I2');

f1= fspecial('average',20);  % Blur the input image
Y=filter2(f1,I2,'same');
figure,imshow(Y/255);title('Y/255'); % Displaying blurred image

% A=ones(size(Y));
% H=A-(Y/255);
% figure,imshow(H);title('Ht');
H1=I3-(Y/255);                        % Subtract the blurred image with a white image of the same size.
H1 = medfilt2(H1,[3 3]);              % Now the edges of the images have been extracted and thickened.

figure,imshow(H1);title('H1');
I5=zeros(size(H1));

[x,y]=size(H1);
H2=H1;
for i=1:x
    for j=1:y
        if H1(i,j) > 0.03             % Apply threshold depending on the image.Change the constant depending on the image.
            H1(i,j)=1;
        end
        if H1(i,j)<0
            H1(i,j)=0;
        
    end
    end
end
H1=imclearborder(H1);                 % Delete all the ones in the image that are attached to any of the borders of the binary image.
H1=edge(H1,'canny');                  % Extract the edges of the binary region using canny edge detection algorithm.
figure,imshow(H1);title('edge H1');

H1=imfill(H1,'holes');                % Fill all the connected regions with ones.
% se3=strel('line',25,0);
 %H1=imdilate(H1,se3);
figure,imshow(H1);title('H1 after loop');  
BW4 = bwpropfilt(H1,'FilledArea',1);   % all the filled areas get popped out into new different images.
figure,imshow(BW4);title('BW4 prop filt');
BW4=im2double(BW4);
I7=immultiply(BW4,H2);                 % Multiply both the images.
figure,imshow(I7);title('imageI7');
% I8=edge(I7,'sobel');
%figure,imshow(I8);

 I2=im2double(I2);
[x,y]=size(I7);
for i=1:x
    for j=1:y
        if I7(i,j)> 0.01              % Threshold depending on the image
            I7(i,j)=1;
        end
    end
end

figure,imshow(I7);title('imageI711');

[Ilabel, num]=bwlabel(I7); 
disp(num);


Iprops=regionprops(Ilabel);     % Prop all the regions with distinguished white regions. This is mainly to extract the entire license plate from the i/p image.
Ibox=[Iprops.BoundingBox];      
Ibox=reshape(Ibox,[4 num]);     

for cnt=1:num
    rectangle('position',Ibox(:,cnt),'edgecolor','r'); % Mark a bounding box for the distinguished proped regions.
end
hold off

for i=1:num
   a17= imcrop(I7,Ibox(:,i));
   a17=imresize(a17,[176 731]);   % Resize all the Num Plate images to a constant dimension. The dimension depicted here, is ideal for most images.
   a17=im2bw(a17);
  % saveas(a17, sprintf('t%d.tiff',i) ,'tiff')
   imwrite(a17,sprintf('t%d.tiff' ,i));  % Save the cropped image with names t1, t2 etc.
   figure,imshow(a17);
end
 
 I8=imclearborder(imcomplement(a17));   % From the extracted num plates now we extract individual letters/digits in the same logic as presented above.
  figure,imshow(I8);title('I8');
 I8=logical(I8);
 I8=bwareafilt(I8,[1000 8000]);
 figure,imshow(I8);title('I8');
 [Ilabel, num]=bwlabel(I8);
disp(num);

Iprops=regionprops(Ilabel);
Ibox=[Iprops.BoundingBox];
Ibox=reshape(Ibox,[4 num]);

for cnt=1:num
    rectangle('position',Ibox(:,cnt),'edgecolor','r');  % Mark each digit with a red bounding box
end
hold off

for i=1:num
   a18= imcrop(I8,Ibox(:,i));       % Crop each bounding box marked
   a17=imresize(a17,[42 24]);       % Resize all the digits to an optimal size
  % saveas(a17, sprintf('t%d.tiff',i) ,'tiff')
   imwrite(a18,sprintf('t%d.tiff' ,i));
   figure,imshow(a18);
end
 
 % Now use basic machine learning program to recognise the letters and digits from the cropped images and then print the answer in a notepad file such that 
 % use manageFPS to transfer the written content in the notepad file to PHPmyAdmin to get the information updated in the website. Go through the paper for better understanding of 
 % Automatic NPR system and the innovative approach of uniting the search results using IoT techniques. 
