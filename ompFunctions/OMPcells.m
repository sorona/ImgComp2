function [GAMMA] = OMPcells(Coef,Dict,Wpar,Kpar)
    fprintf('**********GOMP RUN**********\n');
    H = Coef(1,:);
    V = Coef(2,:);
    D = Coef(3,:);
    level   = Wpar.level;
    GAMMA   = cell(3,level);
    PSNR    = Kpar.targetPSNR;
    MSE     = 255^2*10^(-PSNR/10);
    band = {'H','V','D'};
    % for each level each dirction train dictionary
    mm = size(GAMMA,1);
    nn = size(GAMMA,2);
    count = 1;
    if(Kpar.gomp_test) figure; suptitle('GOMP run test');end
    for j = 1:nn
        for i=1:mm
            name    =  sprintf('%s{%d}',band{i},j);
            Im      =  eval(name);
            [X,m]   =  Im2colgomp(Im);
            R       =  Kpar.R; % dictionary reduandancy
            dictLen =  R*m;
            phi = kron(odctdict(sqrt(m),sqrt(dictLen)),odctdict(sqrt(m),sqrt(dictLen)));
            DD  = phi*Dict{i,j}; % Xr = phi*A*Gamma;
            epsilon = sqrt(MSE*numel(X));
            GAMMA{i,j} = gomp(DD,X,'error',epsilon);
            if(Kpar.gomp_test)
               Xr   = DD*GAMMA{i,j};
               pMSE  = norm(Xr-X,'fro')^2/numel(X);
               fprintf('GOMP for %s MSE:%.4f nnz(GAMMA):%d::%d\n',name,pMSE,nnz(GAMMA{i,j}),numel(GAMMA{i,j}));
               ImRe  = col2im(Xr,[sqrt(m) sqrt(m)],size(Im),'distinct');
                      subplot(nn,mm*2,count*2-1);imshow(Im,[]);title(sprintf('Original %s',name));
                      subplot(nn,mm*2,count*2);imshow(ImRe,[]);title(sprintf('Reconstruction mse%.4f',pMSE));
                      count = count+1;
            end
        end
    end
end

function [X,m] = Im2colgomp(Im)
imLen  = size(Im,1); 
if(imLen>=64)
    pSize = 8;
else
    pSize = 4;
end
    X = im2col(Im,[pSize pSize],'distinct');
    m = pSize^2;
end