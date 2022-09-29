clc
clear all
close all                                                                                                                                                                                                                                                               

alpha = 0.75; %embedding strength
I = imread('cameraman.tif');
figure(1); imshow(I); title('the image in which we insert watermark');
[LL1,HL1,LH1,HH1] =dwt2(I,'haar');
[LL2,HL2,LH2,HH2] =dwt2(LL1,'haar');
[LL3,HL3,LH3,HH3] =dwt2(LL2,'haar');

I_w=imread('watermark.jpg');
I_w=I_w(:,:,1);
I_w=imresize(I_w, [128 16]);
I_b=im2bw(I_w);
figure(2); imshow(I_b); title('binary watermark');
I_b=I_b(:);
k=1;
%m=0; n=0; k=0;
for i=1:32
   
    for j=1:16
       
       
        if (I_b(k)==1)
         if (HL3(i,2*j-1)<HL3(i,2*j))
                temp = HL3(i,2*j-1);
                HL3(i,2*j-1)= HL3(i,2*j);
                HL3(i,2*j) = temp;
                k=k+1;          
            end
        end
       
              
     if (I_b(k)==0)
        if (HL3(i,2*j-1)> HL3(i,2*j))
                temp = HL3(i,2*j-1);
                HL3(i,2*j-1)= HL3(i,2*j);
                HL3(i,2*j) = temp;
                    k=k+1;      
            end
        end
       end  
    
end

for i=1:32
   
    for j=1:16
       
       
        if (I_b(k)==1)
        if (LH3(i,2*j-1)<LH3(i,2*j))
                temp = LH3(i,2*j-1);
                LH3(i,2*j-1)= LH3(i,2*j);
                LH3(i,2*j) = temp;
                 k=k+1;         
            end
        end
       
              
     if (I_b(k)==0)
        if (LH3(i,2*j-1)> LH3(i,2*j))
                temp = LH3(i,2*j-1);
                LH3(i,2*j-1)= LH3(i,2*j);
                LH3(i,2*j) = temp;
              k=k+1;            
            end
        end
       end  
    
end
for i=1:32
   
    for j=1:16
       
       
        if (I_b(k)==1)
        if (HH3(i,2*j-1)<HH3(i,2*j))
                temp = HH3(i,2*j-1);
                HH3(i,2*j-1)= HH3(i,2*j);
                HH3(i,2*j) = temp;
                 k=k+1;         
            end
        end
       
              
     if (I_b(k)==0)
        if (HH3(i,2*j-1)> HH3(i,2*j))
                temp = HH3(i,2*j-1);
                HH3(i,2*j-1)= HH3(i,2*j);
                HH3(i,2*j) = temp;
                k=k+1;            
            end
        end
       end  
    
end

LL2_1=idwt2(LL3,HL3,LH3,HH3,'haar');
LL1_1=idwt2(LL2_1,HL2,LH2,HH2,'haar');
I_1=idwt2(LL1_1,HL1,LH1,HH1,'haar');

figure(3), imshow((I_1),[]); title('watermarked image');

X=psnr(uint8(I_1),I);

%   J=imnoise(I_1,'salt', 0, 0.0001);
%  J=imnoise(I_1,'gaussian');
%  J=imnoise(I_1,'salt & pepper',0.0001);
J = histeq(I_1);
% J=uint8(J);
 figure(4), imshow(J,[]); title(' noisy watermarked image');
%extraction



E=zeros(2048);
E=imresize(E,[2048 1]);
[LL1_E,HL1_E,LH1_E,HH1_E]=dwt2(J,'haar');
[LL2_E,HL2_E,LH2_E,HH2_E]=dwt2(LL1_E,'haar');
[LL3_E,HL3_E,LH3_E,HH3_E]=dwt2(LL2_E,'haar');

% figure(4);imshow(I_B_E);title('blank image')

p=1;
for i=1:32

    for j=1:16
 
       
            if (HL3_E(i,2*j-1)>HL3_E(i,2*j))
              E(p)=1;p=p+1;
            elseif (HL3_E(i,2*j-1)<HL3_E(i,2*j))
               E(p)=0;p=p+1;
            end
        end
    end

for i=1:32

    for j=1:16
 
       
            if (LH3_E(i,2*j-1)>LH3_E(i,2*j))
              E(p)=1;p=p+1;
            elseif (LH3_E(i,2*j-1)<LH3_E(i,2*j))
               E(p)=0;p=p+1;
            end
        end
    end

for i=1:32

    for j=1:16
 
       
            if (HH3_E(i,2*j-1)>HH3_E(i,2*j))
              E(p)=1;p=p+1;
            elseif (HH3_E(i,2*j-1)<HH3_E(i,2*j))
               E(p)=0;p=p+1;
            end
        end
    end
% E=imresize(E,[128 16]);
figure(5);imshow(E,[]);title('extracted watermark');
X11=corr2(E,I_b);

% XJ=psnr(uint8(J),I);
% XJ_1=psnr(uint8(J_1),I);
 