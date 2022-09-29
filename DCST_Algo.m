%image watermarking using DWT-SVD
clc
clear all
close all

alpha = 0.75; %embedding strength
I = double(imread('cameraman.tif'));
%figure(1); imshow(I); title('the image in which we insert watermark');
dcst2 = dcst2(I);
%figure(2); imshow(I); title('the image in which we insert watermark& DOST applied');
[LL1,HL1,LH1,HH1] =dwt2(dcst2,'haar');
[LL2,HL2,LH2,HH2] =dwt2(LL1,'haar');
p=size(LL2);
%applying SVD on LL2
[Uy,Sy,Vy]=svd(LL2);
q=size(Sy);

%define watermark

I_w=imread('watermark.jpg');
I_w=I_w(:,:,1);
I1_w=imresize(I_w,p);
I_b=mat2gray(I1_w);
%figure(3);imshow(I_b);title('original b/w watermark');

%applying SVD on  watermark
[Uw,Sw,Vw]=svd(double(I_b));

%embed wartermark
Smark = Sy + alpha*Sw;

%Rebuild the sub-hands using SVD
LL2_1=Uy*Smark*Vy';

%Apply inverse dwt to get watermarkedimage
LL1_1=idwt2(LL2_1,HL2,LH2,HH2,'haar');
I_1=idwt2(LL1_1,HL1,LH1,HH1,'haar');
%figure(4);imshow(uint8(I_1));title('Watermarked Image');


J = awgn(I_1,0,'measured');
%   J=imnoise(I_1,'salt', 0, 0.0001);
%  J=imnoise(I_1,'gaussian');
%J=imnoise(I_1,'salt & pepper',0.0001);
%J = histeq(I_1);
% J=uint8(J);
%figure(5), imshow(uint8(J)); title(' noisy watermarked image');



%EXTRACTION
[LL1_wmv,HL1_wmv,LH1_wmv,HH1_wmv]=dwt2(J,'haar');
[LL2_wmv,HL2_wmv,LH2_wmv,HH2_wmv]=dwt2(LL1_wmv,'haar');
[Uy_wmv,Sy_wmv,Vy_wmv]=svd(LL2_wmv);
Swrec=(Sy_wmv - Sy)/alpha;
WMy=Uw*Swrec*Vw';
%WMy=1-WMy;
%figure(5); imshow(double(WMy));title('Extracted Watermark');
%IDOST
%J=double(J);
recdcst = idcst2(J);
%image(real(recdost));
%figure(6);imshow(uint8(recdost));title('host image after applying noise and IDOST ');

X22=corr2(WMy,I_b);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
subplot(1,3,1)
imagesc(I)
title('host image')
axis equal 
axis tight
subplot(1,3,2)
%imagesc(log(abs(dcst2))) 
imagesc([-.5 .5], [-.5 .5], log(abs(dcst2))) 
title('(log of the norm of the) dcst2 of the test signal')
axis equal
axis tight
subplot(1,3,3)
imagesc(real(recdcst))
title('reconstructed test signal')
axis equal
axis tight
colormap gray

final2_psnr=psnr((recdcst),I);
