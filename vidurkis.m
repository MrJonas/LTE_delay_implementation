function  vidurkis( SINR_file, RSRP_file )
%UNTITLED2 Summary of this function goes here
%   Apskaiciuoja vidurkius SINR ir RSRP failams, išsaugo naujame faile
    
    %SINR histogramai:
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
    
    SINR_int = -10;
    id = 1;
    while (SINR_int < 16)
            cnt = 0;
            sum_delay = 0;
            sum_thput = 0;
        for i = 1:(j-1)
           if (SINR_array(i, 1) < (SINR_int + 1)) && (SINR_array(i, 1) >= (SINR_int - 1))
            sum_delay = sum_delay + SINR_array(i, 2);
            sum_thput = sum_thput + SINR_array(i, 3);           
            cnt = cnt + 1;
           end           
        end
        if ~(cnt == 0) 
            H_SINR_array(id,  1) = SINR_int;          
            H_SINR_array(id,  2) = sum_delay/cnt;                 
            H_SINR_array(id,  3) = sum_thput/cnt;
            id = id + 1;
        end
        SINR_int = SINR_int + 0.1; 
    end
    H_SINR_array
    H_SINR_array(:,1)
    H_SINR_array(:,2)
    H_SINR_array(:,3)
    
    SINR_save_file = fopen(strcat(SINR_file(1:end-4), '_average.txt'), 'at');
    p = size(H_SINR_array);
    for i = 1:p(1)
        fprintf(SINR_save_file, '%2f ', H_SINR_array(i,1));
        fprintf(SINR_save_file, '%2f ', H_SINR_array(i,2));
        fprintf(SINR_save_file, '%2f \n', H_SINR_array(i,3));
    end
    fclose(SINR_save_file);
    
    %RSRP histogramai:
    fid2 = fopen(RSRP_file);
	tline = fgets(fid2);
    j = 1;
    tline
	while ischar(tline)
    		A = sscanf(tline,'%f');
            if ~(numel(A) ==0)
                RSRP_array(j, 1) = A(1);
                RSRP_array(j, 2) = A(2);
                RSRP_array(j, 3) = A(3);
            j = j + 1;
            end
    		tline = fgets(fid2);
	end
	fclose(fid2);
    
    RSRP_int = -140;
    id = 1;
    while (RSRP_int < -20)
            cnt = 0;
            sum_delay = 0;
            sum_thput = 0;
        for i = 1:(j-1)
           if (RSRP_array(i, 1) < (RSRP_int + 10)) && (RSRP_array(i, 1) >= (RSRP_int-10))
            sum_delay = sum_delay + RSRP_array(i, 2);
            sum_thput = sum_thput + RSRP_array(i, 3);           
            cnt = cnt + 1;
           end           
        end
        if ~(cnt == 0) 
            H_RSRP_array(id,  1) = RSRP_int;          
            H_RSRP_array(id,  2) = sum_delay/cnt;                 
            H_RSRP_array(id,  3) = sum_thput/cnt;
            id = id + 1;
        end
        RSRP_int = RSRP_int + 1; 
    end
    H_RSRP_array
    H_RSRP_array(:,1)
    H_RSRP_array(:,2)
    H_RSRP_array(:,3)
    
    RSRP_save_file = fopen(strcat(RSRP_file(1:end-4), '_average.txt'), 'at');
    p = size(H_RSRP_array);
    for i = 1:p(1)
        fprintf(RSRP_save_file, '%2f ', H_RSRP_array(i,1));
        fprintf(RSRP_save_file, '%2f ', H_RSRP_array(i,2));
        fprintf(RSRP_save_file, '%2f \n', H_RSRP_array(i,3));
    end
    fclose(RSRP_save_file);
end

