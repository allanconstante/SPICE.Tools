function dataAlter(file, data, variable)
        
    nArq = strcat(file, '.alter');
    arq = fopen(nArq,'at');
    tam = size(data);
    cont = 1;
    
    tamL = tam(1,1);
    tamC = tam(1,2);
    
    fprintf(arq,'* Parameters #####################################################\n');
    fprintf(arq,'*\n');
    for iC=1:tamC
        
        fprintf(arq,'* + %s\n', variable(iC,:));
    end
    fprintf(arq,'* : %d\n', tamL);
    fprintf(arq,'*\n');
    fprintf(arq,'* ################################################################\n\n');
    
    for iL=1:tamL
        
        fprintf(arq,'.alter case %d\n', cont);
        for iC=1:tamC
            
            fprintf(arq,'.param %s=%e\n', variable(iC,:) ,data(iL,iC));
        end
        cont = cont + 1;
    end
    fclose(arq);
end