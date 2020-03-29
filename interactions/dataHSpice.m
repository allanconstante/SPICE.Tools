function dataHSpice(nome, nsinal, sinal, f)
        
    nArq = strcat(nome, ".data");
    arq = fopen(nArq,'at');
    fprintf(arq,'.data %s\n', nsinal);
    
    tam = size(sinal);
    for iC=1:tam(1,2)
        fprintf(arq,'%s ', sinal(1,iC));
    end
    fprintf(arq,'\n');
    
    
    tam = size(f);
    tamL = tam(1,1);
    tamC = tam(1,2);
    for iL=1:tamL
        for iC=1:tamC
            fprintf(arq,'%e ',f(iL,iC));
        end
        fprintf(arq,'\n');
    end
    fprintf(arq,'.enddata');
    fclose(arq);
end