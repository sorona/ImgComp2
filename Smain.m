function [X,Y] = Smain(FEATURE_IND,activeInd,markerSize,marker)
% use: [X,Y] = Smain(FEATURE_IND,ACTIVEVALUES,markerSize,marker)
% exp: [X,Y] = Smain(4,[4,5,6],10,'.');
% exp: [X,Y] = Smain(4,0,10,'.'); ACTIVEVALUES = [0] means all values
% 
% Feature vector:
% X = [PSNR                  ...
%     ,Kpar.targetPSNR       ...
%     ,Kpar.trainPSNR        ...
%     ,Gpar.pSizeBig         ...
%     ,Gpar.pSizeSmall       ... 
%     ,wave_ind              ...
%     ,Kpar.Rbig             ... 
%     ,Kpar.Rsmall           ... 
%     ,Kpar.dictBigMaxAtoms  ... 
%     ,Kpar.dictSmallMaxAtoms... 
%     ,Qpar.GAMMAbins        ...
%     ,Qpar.Dictbins         ...
%     ];
% TAGS vector
% Y = [NNZD,NNZG,BPP];

    if(nargin>0);
        [X,Y] = SmainTOP(FEATURE_IND,activeInd,markerSize,marker);
    else
        FEATURE = 11;
        VALS    = 20:10:80;
        for i =1:length(VALS)
            SmainTOP(FEATURE,VALS(i),10,'.');        
        end
        X=0;Y=0;
    end

end



function [X,Y] = SmainTOP(FEATURE_IND,activeInd,markerSize,marker)

%% Get data

s    = what('dataSimul');
LEN = length(s.mat); 
X   = [];
Y   = [];
for i=1:LEN 
   fullpath = sprintf('%s/%s',s.path,s.mat{i});
   tmpl=load(fullpath);
   X=[X;tmpl.XTOT]; %#ok<AGROW>
   Y=[Y;tmpl.YTOT]; %#ok<AGROW>
end

%% Plot Bpp vs PSNR

% FEATURE_IND = 5;
    global MarkerSize;
    global Marker;
    global ActiveInd;
    MarkerSize = markerSize;
    Marker     = marker;
    ActiveInd  = activeInd;
    
    switch FEATURE_IND
        % natural
        case 0  
            BPP     = Y(:,3);   
            figure;plot(BPP,X(:,1),'.');title('PSNR vs bpp');
        % Patch size Big
        case 4
            FEATURE = 4;
            VALS = 3:8;
            map = lines(length(VALS));
            TITLE = 'Color by Patch Size Big';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % Patch size Small
        case 5
            FEATURE = 5;
            VALS = 3:6;
            map = lines(length(VALS));
            TITLE = 'Color by Patch Size Small';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % wavelet ind
        case 6
            FEATURE = 6;
            VALS = 1:3;
            map = lines(length(VALS));
            TITLE = 'Color by Wavelet';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % Rbig
        case 7 
            FEATURE = 7;
            VALS = 1:0.5:3.5;
            map = lines(length(VALS));
            TITLE = 'Color by Rbig';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % RSmall
        case 8 
            FEATURE = 8;
            VALS = 1:0.5:3.5;
            map = lines(length(VALS));
            TITLE = 'Color by RSmall';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % dictBigMaxAtoms
        case 9
            FEATURE = 9;
            VALS = 7:-1:1;
            map = lines(length(VALS));
            TITLE = 'Color by dictBigMaxAtoms';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % dictSmallMaxAtoms
        case 10
            FEATURE = 10;
            VALS = 7:-1:1;
            map = lines(length(VALS));
            TITLE = 'Color by dictSmallMaxAtoms';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % GAMMAbins
        case 11
            FEATURE = 11;
            VALS = 20:10:80;
            map = lines(length(VALS));
            TITLE = 'Color by GAMMAbins Quant';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);
        % Dictbins
        case 12
            FEATURE = 12;
            VALS = 20:10:80;
            map = lines(length(VALS));
            TITLE = 'Color by Dictbins Quant';
            paint_and_leg(X,Y,map,FEATURE,VALS,TITLE);


    end
end

function paint_and_leg(X,Y,map,FEATURE,VALS,TITLE)
    global MarkerSize;
    global Marker;
    global ActiveInd;
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1);
    xyBestFit = inf(2,10);
    
    for i=1:length(X)
        BPPTMP = Y(i,3); % Bpp
        PSNRTMP = X(i,1); % PSNR
        for m=1:length(xyBestFit)
            if(abs(m+25-PSNRTMP)<0.4)
                if(BPPTMP<xyBestFit(1,m))
                    xyBestFit(1,m)=BPPTMP;
                    xyBestFit(2,m)=PSNRTMP;
                end
            end
        end
    end
    xyBestFit(xyBestFit==inf)=NaN;

    % sperate colors by feature values
    BPP  = NaN(length(VALS),size(X,1));
    PSNR = NaN(length(VALS),size(X,1));
    for i=1:size(X,1)
        ind  = (X(i,FEATURE)==VALS);
        if(max(VALS(ind)==ActiveInd) || max(ActiveInd==0))
            BPP (ind,i) = Y(i,3);
            PSNR(ind,i) = X(i,1);
        end
    end
    % plot values
    for i=1:length(VALS)
        plot(BPP(i,:),PSNR(i,:),Marker,'color',map(i,:),'MarkerSize',MarkerSize); hold on;
    end
        
    plot(xyBestFit(1,:),xyBestFit(2,:),'MarkerSize',30);
    xlim([0 0.2]);
    ylim([25 36]);
    
    title(sprintf('%s, activeValues:%s',TITLE,mat2str(ActiveInd)));

    LEG = cell(1,length(VALS));
    subplot(1,2,2);
    for i=1:size(map,1)
        plot(VALS(i),VALS(i),'.','color',map(i,:),'MarkerSize',30); hold on;
         LEG{i} = sprintf('%g',VALS(i));
    end
    legend(LEG);
    title(TITLE);
    
    
    
end