clear all; close all; clc   
   filename = 'barbara.gif';
   outfilename = 'bar1';
%% Global param
    global Gpar;
    Gpar.pSizeBig    = 8;
    Gpar.pSizeSmall  = 4;
    Gpar.plotReconst = 0;
    Gpar.plotBppPie  = 1;
%% Wavelet param
    Wpar.wavelet_name = 'sym16'; dwtmode('per','nodisp');  
    Wpar.plots = 0;
    Wpar.level = 6; % DONOT change for now
%% Sparse KSVD (Train Dictionaries)
    Kpar.Rbig              = 3;
    Kpar.Rsmall            = 3;
    Kpar.dictBigMaxAtoms   = 2; 
    Kpar.dictSmallMaxAtoms = 2;    % (MAX = dictLen = R*pSize;)
    Kpar.trainPSNR         = 32;
    Kpar.iternum           = 2;
    Kpar.printInfo         = 0;
    Kpar.plots             = 0;
%% GOMP (Sparse representations) 
    Kpar.gomp_test  = 0;
    Kpar.targetPSNR = 32;
%% Quantization (GAMMA,Dict)
    Qpar.GAMMAbins = 64;
    Qpar.Dictbins  = 64;
    Qpar.infoDyRange = 0;
%% Optimazie Gamma
    Opar.plots = 0;
    Opar.order = 'GAMMA'; % gamma columned descend population

[NNZD,NNZG,PSNR,BPP] = ImgComp(filename,outfilename,Kpar,Wpar,Qpar,Opar);
ImRE = ImgRead(outfilename,Kpar,Wpar,Qpar,Opar);
figure;imshow(ImRE,[])
% TODO:
% remove DC's
% combine same levels
% combine differently
% save diffcol by a symbol to skeep to the next line instead of different
% symbols
% Haar transform really bad -> need a better wavelet
% check the overhead of zeros padd im2col