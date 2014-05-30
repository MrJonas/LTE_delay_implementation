%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Pakeista +network_elements/UE.m
%Pridetas tti_curr kintamasis:

function link_performance_model(obj)

	tti_curr = obj.clock.current_TTI;
% Needed for non-full-buffer simulations
        if ~obj.traffic_model.is_fullbuffer
                obj.process_packet_parts(packet_parts,nCodewords,tti_curr,user_id);
        end

end

% Cia irgi:
function process_packet_parts(obj,packet_parts,nCodewords,tti_curr,user_id)
            for cw_ = 1:nCodewords
                if 1
                    %ACK(cw_)
                    if strcmp(obj.traffic_model.type,'voip') || strcmp(obj.traffic_model.type,'video') || strcmp(obj.traffic_model.type,'gaming')
                        %fprintf(' Type: %s',obj.traffic_model.type);
                        for pp = 1:length(packet_parts{cw_}) % acknowledge all packet parts and remove them from the buffer
                            if packet_parts{cw_}(pp).data_packet_id
                                packet_ind = obj.traffic_model.get_packet_ids == packet_parts{cw_}(pp).data_packet_id;
                                if sum(packet_ind)
%Pakeitimas:
                                    [packet_done,packet_id] = obj.traffic_model.packet_buffer(packet_ind).acknowledge_packet_part(packet_parts{cw_}(pp).id,true,tti_curr,user_id);
                                    if packet_done && packet_id
                                        obj.traffic_model.remove_packet(packet_id,true);
                                    end
                                end
                            end
                        end
                    end
                else



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pakeista: +traffic_models/data_packet.m
function [packet_done,packet_id] = acknowledge_packet_part(obj,part_id,state,destination,user_id)
%         delete(obj.packet_parts([obj.packet_parts.id] == part_id));
        %fprintf('ACKF');
        obj.packet_parts([obj.packet_parts.id] == part_id) = traffic_models.packet_part(obj.id,0,0);
        if ~state
            obj.stop_packet = true;
        end
        if sum(obj.packet_parts.get_size) == 0 && obj.size == 0
            packet_done = true;
            fprintf('User ID: %4.0f',user_id);
            fprintf('Current TTI: %4.0f',destination);
            fprintf('obj.id: %4.0f',obj.id);
            fprintf(' Get_origin: %4.0f \n',obj.get_origin);

%Failas, kuriame isaugomi USER ID ir velinimai:
            duom = fopen('rez_300tti_MAP2000_LdB70-dummy.txt', 'at');
            fprintf(duom, '%f ', user_id);
            fprintf(duom, '%2f ', destination - obj.get_origin);
            fprintf(duom, '%2f \n', obj.get_origin);
            fclose(duom);
            obj.destination_TTI = destination;
        else
            packet_done = false;
            obj.destination_TTI = 0;
        end
%         if (obj.size == 0 && isempty(obj.packet_parts)) || (isempty(obj.packet_parts) && ~state)
%             packet_done = true;
%         else
%             packet_done = false;
%         end
        packet_id = obj.id;
%         obj.part_id = obj.part_id - 1;
    end
