function  [GAMMAdiffCol] = EntropyDecodediffColDict(code,counts,countsBins,level,Kpar)
    m = 3;
    n = level;
    GAMMAdiffCol = cell(m,n);
    LENCELL      = cell(m,n);
    
    LEN = 0 ;
    for j=1:n
        for i=1:m
            LENCELL{i,j} = DictSize(j,Kpar);
            LEN = LEN + LENCELL{i,j};
        end
    end
    
    % de quantize counts
    probLOGQ   = counts; 
    probLOGRE  = probLOGQ/(countsBins-1);
    probRE     = 2.^(probLOGRE*13.3);
    counts     = round(probRE)+1;  

    dseq = arithdeco(code,counts,LEN);
    dseq = dseq-1;
    
    ptr =1;
    for j=1:n
        for i=1:m   
             TMPLEN = LENCELL{i,j};
             GAMMAdiffCol{i,j} = dseq(ptr:ptr+TMPLEN-1);
             ptr=ptr+TMPLEN;        
        end
    end

end

