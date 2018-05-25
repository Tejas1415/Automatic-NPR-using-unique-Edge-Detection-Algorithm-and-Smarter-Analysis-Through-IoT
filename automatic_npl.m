clc
close all
clear all

a=imread('car.jpg');
figure,imshow(a);
I2=rgb2gray(a);

I3=im2double(I2);
figure
imshow(I2); title('I2');

f1= fspecial('average',20);
Y=filter2(f1,I2,'same');
figure,imshow(Y/255);title('Y/255');

% A=ones(size(Y));
% H=A-(Y/255);
% figure,imshow(H);title('Ht');
H1=I3-(Y/255);
H1 = medfilt2(H1,[3 3]);

figure,imshow(H1);title('H1');
I5=zeros(size(H1));

[x,y]=size(H1);
H2=H1;
for i=1:x
    for j=1:y
        if H1(i,j) > 0.03
            H1(i,j)=1;
        end
        if H1(i,j)<0
            H1(i,j)=0;
        
    end
    end
end
H1=imclearborder(H1);
H1=edge(H1,'canny');
figure,imshow(H1);title('edge H1');

H1=imfill(H1,'holes');
% se3=strel('line',25,0);
 %H1=imdilate(H1,se3);
figure,imshow(H1);title('H1 after loop');
BW4 = bwpropfilt(H1,'FilledArea',1);
figure,imshow(BW4);title('BW4 prop filt');
BW4=im2double(BW4);
I7=immultiply(BW4,H2);
figure,imshow(I7);title('imageI7');
% I8=edge(I7,'sobel');
%figure,imshow(I8);

 I2=im2double(I2);
[x,y]=size(I7);
for i=1:x
    for j=1:y
        if I7(i,j)> 0.01
            I7(i,j)=1;
        end
    end
end

figure,imshow(I7);title('imageI711');

[Ilabel, num]=bwlabel(I7);
disp(num);


Iprops=regionprops(Ilabel);
Ibox=[Iprops.BoundingBox];
Ibox=reshape(Ibox,[4 num]);

for cnt=1:num
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
hold off

for i=1:num
   a17= imcrop(I7,Ibox(:,i));
   a17=imresize(a17,[176 731]);
   a17=im2bw(a17);
  % saveas(a17, sprintf('t%d.tiff',i) ,'tiff')
   imwrite(a17,sprintf('t%d.tiff' ,i));
   figure,imshow(a17);
end
 
 I8=imclearborder(imcomplement(a17));
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
    rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
hold off

for i=1:num
   a18= imcrop(I8,Ibox(:,i));
   a17=imresize(a17,[42 24]);
  % saveas(a17, sprintf('t%d.tiff',i) ,'tiff')
   imwrite(a18,sprintf('t%d.tiff' ,i));
   figure,imshow(a18);
end
 