function dataExp(file, data)
    
    nArq = strcat(file, ".dat");
    arq = fopen(nArq,'at');
    
    tam = size(data);
    tamL = tam(1,1);
    tamC = tam(1,2);
    for iL=1:tamL
        for iC=1:tamC
            
            if iC == tamC
                
                fprintf(arq,'%e',data(iL,iC));
            else
                
                fprintf(arq,'%e ',data(iL,iC));
            end
        end
        fprintf(arq,'\n');
    end
    fclose(arq);
end