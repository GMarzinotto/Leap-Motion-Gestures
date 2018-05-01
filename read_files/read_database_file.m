function [fileContent] = read_database_file(path)

    %TODO: Adapt this to your type of files
    
    [fid, message]=fopen(path, 'r');

    if~isempty(message)
       disp(message)      
    else
        fileContent = fscanf(fid,'%f#%f;%f;%f;%f;%f;%f;%f;%f;%f', [10,inf])';
        fclose(fid);
    end
    
end