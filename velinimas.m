function velinimas( file_name, SINR_file, RSRP_file, MCL, f, BW)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    %Situ turbut nereikia:
	sum_delay = [];
    sum_number = [];
    SINR = [];
    RSRP = [];
    pos_x = [];
    pos_y = [];
    %Ikeleme workspace:
    simulation_traces = evalin('base', 'simulation_traces');
    eNodeBs_sectors = evalin('base', 'eNodeBs_sectors');
    %Priskiriame pradines vertes:
    p = size(simulation_traces.UE_traces);
    for j= 1:p(2)
            sum_delay(j) = 0;
            sum_number(j) = 0;
            delay(j) = 0;
            thput(j) = simulation_traces.UE_traces(j).average_throughput_Mbps; 
            SINR(j) = simulation_traces.UE_traces(j).wideband_SINR(1);
            RSRP(j) = 0;          
            pos_x(j) = simulation_traces.UE_traces(j).position(1);
            pos_y(j) = simulation_traces.UE_traces(j).position(2);
    end
    
    %Atliekame skaičiavimus:
	fid = fopen(file_name);
	tline = fgets(fid);
	while ischar(tline)
            %Nuskaitome eilute:
    		A = sscanf(tline,'%f');
            %RSRP:
            d1 = ( simulation_traces.UE_traces(A(1)).position(1) - eNodeBs_sectors(simulation_traces.UE_traces(A(1)).attached_eNodeB(1)).parent_eNodeB.pos(1)).^2;   
            d2 = (simulation_traces.UE_traces(A(1)).position(2) - eNodeBs_sectors(simulation_traces.UE_traces(A(1)).attached_eNodeB(1)).parent_eNodeB.pos(2)).^2;
            d = sqrt(d1 + d2);
            Loss = 10*log10(4*3.14/300000000*d*f);
            %RBs:
            if (BW == 5)
                RBs = 25;
            elseif (BW == 10)
                RBs = 50;          
            elseif (BW == 20)
                RBs = 100;
            end
            %RSRP:
            RSRP(A(1)) = 40 - Loss - MCL - 10*log10(12*RBs);
            % Thr
            thput(A(1)) = simulation_traces.UE_traces(A(1)).average_throughput_Mbps;
            %SINR:
            SINR(A(1)) = simulation_traces.UE_traces(A(1)).wideband_SINR(1);
            %Delay:
            sum_delay(A(1)) = sum_delay(A(1)) + A(2);
            sum_number(A(1)) = sum_number(A(1)) + 1;
            delay(A(1)) = sum_delay(A(1))/sum_number(A(1));
    		tline = fgets(fid);
	end
	fclose(fid);
    
    %Sukialeme galutinius rezultatus į masiva:
    p = size(simulation_traces.UE_traces);
    for j = 1:p(2)
        SINR_array(j,1) = SINR(j); 
        SINR_array(j,2) = delay(j);
        SINR_array(j,3) = thput(j);
        SINR_array(j,4) = pos_x(j);
        SINR_array(j,5) = pos_y(j);
        
        RSRP_array(j,1) = RSRP(j); 
        RSRP_array(j,2) = delay(j);
        RSRP_array(j,3) = thput(j);     
        RSRP_array(j,4) = pos_x(j);
        RSRP_array(j,5) = pos_y(j);
    end
    
    %Irasome i masivus pries tai faile išsaugotus duomenis:
    %SINR failui:
    if exist(SINR_file, 'file')
        sinrSaveFile = fopen(SINR_file);
        line = fgets(sinrSaveFile);
        while ischar(line)
            j = p(2) + 1;
            A = sscanf(line,'%f');
            SINR_array(j, 1) = A(1);
            SINR_array(j, 2) = A(2);
            SINR_array(j, 3) = A(3);
            SINR_array(j, 4) = A(4);
            SINR_array(j, 5) = A(5);
            j = j + 1;
        end
    end 
    %RSRP failui:
    if exist(RSRP_file, 'file')       
        rsrpSaveFile = fopen(RSRP_file);
        line = fgets(rsrpSaveFile);
        while ischar(line)
            j = p(2) + 1;
            A = sscanf(line,'%f');
            RSRP_array(j, 1) = A(1);
            RSRP_array(j, 2) = A(2);
            RSRP_array(j, 3) = A(3);
            RSRP_array(j, 4) = A(4);
            RSRP_array(j, 5) = A(5);
            j = j + 1;
        end
    end
    %surikiuojame masiva
    SINR_array = sortrows(SINR_array,1);
    RSRP_array = sortrows(RSRP_array,1);
    
    %Irasome rezultatus. SINR:
    %SINR_save_file = fopen('SINR_MAP.txt', 'at');
    SINR_save_file = fopen(SINR_file, 'at');
    for j = 1:p(2)
        if ~(SINR_array(j,2) ==0)
            fprintf(SINR_save_file, '%f ', SINR_array(j,1)); 
            fprintf(SINR_save_file, '%f ', SINR_array(j,2)); 
            fprintf(SINR_save_file, '%f ', SINR_array(j,3));
            fprintf(SINR_save_file, '%f ', SINR_array(j,4));
            fprintf(SINR_save_file, '%f \n', SINR_array(j,5));
        end
    end               
    fclose(SINR_save_file);
    
    %Irasome rezultatus. RSRP:
    %RSRP_save_file = fopen('RSRP_MAP.txt', 'at');
    RSRP_save_file = fopen(RSRP_file, 'at');    
    for j = 1:p(2)
        if ~(RSRP_array(j,2) ==0)
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,1)); 
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,2)); 
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,3));           
            fprintf(RSRP_save_file, '%f ', RSRP_array(j,4));
            fprintf(RSRP_save_file, '%f \n', RSRP_array(j,5));
        end
    end               
    fclose(RSRP_save_file);    
end