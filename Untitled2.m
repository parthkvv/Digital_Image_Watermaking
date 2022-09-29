
%image watermarking using DWT-SVD
clc
close all


alpha = 0.75; %embedding strength
I = imread('cameraman.tif');
figure(1); imshow(I); title('the image in which we insert watermark');
[LL1,HL1,LH1,HH1] =dwt2(I,'haar');
[LL2,HL2,LH2,HH2] =dwt2(LL1,'haar');
[LL3,HL3,LH3,HH3] =dwt2(LL2,'haar');
[LL4,HL4,LH4,HH4] =dwt2(LL3,'haar');
p=size(LL4);
%applying SVD on LL4
[Uy,Sy,Vy]=svd(LL4);
q=size(Sy);

%define watermark

I_w=imread('watermark.jpg');
I_w=I_w(:,:,1);
I1_w=imresize(I_w,p);
%I_b=im2bw(I1_w);
I_b=I1_w
figure(2);imshow(I_b);title('original b/w watermark');

%applying SVD on  watermark
[Uw,Sw,Vw]=svd(double(I_b));

%embed wartermark
Smark = Sy + alpha*Sw;

%Rebuild the sub-hands using SVD
LL4_1=Uy*Smark*Vy';

%Apply inverse dwt to get watermarkedimage
LL3_1=idwt2(LL4_1,HL4,LH4,HH4,'haar');
LL2_1=idwt2(LL3_1,HL3,LH3,HH3,'haar');
LL1_1=idwt2(LL2_1,HL2,LH2,HH2,'haar');
I_1=idwt2(LL1_1,HL1,LH1,HH1,'haar');
figure(3);imshow(uint8(I_1));title('Watermarked Image');
% 
% %applying hauffman encoding
% 
% % calculate the frequency of each pixel
% [frequency,pixelValue] = imhist(I_1);
% 
% % sum all the frequencies
% tf = sum(frequency) ;
% 
% % calculate the frequency of each pixel
% probability = frequency ./ tf ;
% 
% % create a dictionary
% dict = huffmandict(pixelValue,probability);
% 
% % get the image pixels in 1D array
% imageOneD = I_1(:) ;
% 
% % encoding
% testVal = imageOneD ;
% encodedVal = huffmanenco(testVal,dict);
% 
% 
% 
% 













%   J=imnoise(I_1,'salt', 0, 0.0001);

  J=imnoise(I_1,'gaussian');
% I_1=imnoise(I_1,'salt & pepper',0.0001);
% J = histeq(I_1);
% J=uint8(J);


  figure(4), imshow(J); title(' noisy watermarked image');


%hauffman decoding

% I_1 = arithdeco(J,unique_symbols);
%EXTRACTION
[LL1_wmv,HL1_wmv,LH1_wmv,HH1_wmv]=dwt2(J,'haar');
[LL2_wmv,HL2_wmv,LH2_wmv,HH2_wmv]=dwt2(LL1_wmv,'haar');
[LL3_wmv,HL3_wmv,LH3_wmv,HH3_wmv]=dwt2(LL2_wmv,'haar');
[LL4_wmv,HL4_wmv,LH4_wmv,HH4_wmv]=dwt2(LL3_wmv,'haar');
[Uy_wmv,Sy_wmv,Vy_wmv]=svd(LL4_wmv);
Swrec=(Sy_wmv - Sy)/alpha;
WMy=Uw*Swrec*Vw';
 WMy=1-WMy;
figure(5); imshow(uint8(WMy));title('Extracted Watermark');


X11=corr2(WMy,I_b);