clc
close all;
clear all;
[fname path] =uigetfile('*.jpg');
fname = strcat(path,fname);

im = imread(fname);
snr=10;
SNR=[-10:2:20]
BER=[];
for(snr=1:length(SNR))
    im1=double(im);
    [x y z]=size(im1);
    data=reshape(im1,1,x*y*z);
    numChannels=8;
    
    dataParCh=length(data)/numChannels;
    for(i=0:numChannels-1)
        p=data(i*dataParCh+1:i*dataParCh+dataParCh);
        if(i>0)
            if(length(p)~=length(parData(i,:)))
                p=[0 p];
            end
        end
        parData(i+1,:)=p;
    end
    %%
    
    %%Normalising data
    M=16;
    parData = ceil(parData/20);
    Q=qammod(parData,M);
    transmitted=ifft(Q);
    
    err=awgn(transmitted,SNR(snr));
    %% Receied
    rcv=fft(err);
    QD=qamdemod(rcv,M);
    QD=QD*20;
    
    R =[];
    for(i=1:numChannels)
        R=[R real(QD(i,:))];
    end
    im2=reshape(R,x,y,z);
    imshow(uint8(im2));
    figure
    A=uint8(rgb2gray(im1));
    B=uint8(rgb2gray(im2));
    ber=biterr(A,B)/(x*y);
    BER=[BER ber];
end
semilogy(SNR,BER);

    
    