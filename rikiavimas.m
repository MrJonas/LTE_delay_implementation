function rikiavimas( SINR_file, RSRP_file )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %SINR_rikiavimas
    fid = fopen(SINR_file);
	tline = fgets(fid);
    j = 1;
	while ischar(tline)
    		A = sscanf(tline,'%f');
            SINR_array(j, 1) = A(1);
            SINR_array(j, 2) = A(2);
            SINR_array(j, 3) = A(3);
            j = j + 1;
    		tline = fgets(fid);
	end
	fclose(fid);
    
    delete(SINR_file);
    
    SINR_array = sortrows(SINR_array,1);
    
    SINR_save_file = fopen(SINR_file, 'at');
    p = size(SINR_array);
    for j = 1:p(1)
        if ~(SINR_array(j,2) == 0)
            fprintf(SINR_save_file, '%f ', SINR_array(j,1));
            fprintf(SINR_save_file, '%f ', SINR_array(j,2));
            fprintf(SINR_save_file, '%f \n', SINR_array(j,3));
        end
    end
    fclose(SINR_save_file);
    %RSRP
    %RSRP_rikiavimas
    fid = fopen(RSRP_file);
	tline = fgets(fid);
    j = 1;
	while ischar(tline)
    		A = sscanf(tline,'%f');
            RSRP_array(j, 1) = A(1);
            RSRP_array(j, 2) = A(2);
            RSRP_array(j, 3) = A(3);
            j = j + 1;
    		tline = fgets(fid);
	end
	fclose(fid);
    
    delete(RSRP_file);
    
    RSRP_array = sortrows(RSRP_array,1);
    
    RSRP_save_file = fopen(RSRP_file, 'at');
    p = size(RSRP_array);
    for j = 1:p(1)
        if ~(RSRP_array(j,2) == 0)
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,1));
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,2));
            fprintf(RSRP_save_file, '%f \n', RSRP_array(j,3));
        end
    end
    fclose(RSRP_save_file);

end

