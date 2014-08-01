function main(TPSNR)
%% High PSNR patch size fit
PatchSize = 3:8;
expLevel  = 1:6;
iternum = 100;
IMNUM   = 10;


NNZD = -1*ones(length(expLevel),length(PatchSize));
NNZG = -1*ones(size(NNZD));
BPP = -1*ones(size(NNZD));


IMGS = cell(IMNUM,3);
for im =1:IMNUM
     filename = sprintf('images/%d.gif',im);
     for pp=1:length(PatchSize)
        for ll=1:length(expLevel) 
            [tNNZD,tNNZG,tPSNR,tBPP] = Pmain(expLevel(ll),PatchSize(pp),TPSNR,filename,iternum);
            if((tPSNR-TPSNR)<0.1)
                NNZD(ll,pp) = tNNZD;
                NNZG(ll,pp) = tNNZG;
                BPP (ll,pp) = tBPP;
            end
            save(sprintf('dataSimul/%dPSNRres',TPSNR));
        end
     end
     IMGS(im,:) = {NNZD,NNZG,BPP};
end

end
  