Simuliatorių galima rasti cia:
http://www.nt.tuwien.ac.at/research/mobile-communications/lte-downlink-system-level-simulator/
Tyrime naudota 1.6 versija.

Visi pakeitimai, skirti skaičiuoti vėlinimams, yra 'Pakeitimai.txt'.

Pavyzdiniai simuliatoriaus paleidimo parametrai yra 'Paleidimo_parametrai.txt'.
Plačiau apie juos galite rasti dokumentacijoje.

Pasibaigus simuliacijai rezultatai išsaugomi, 'Pakeitimai.txt' nurodytame faile.
Gauti velinimus, SINR, RSRP ir vartotojų koardinates naudojame 'velinimas.m'.
Pavyzdis skaičiuoti siuos rezultatus kelioms simuliacijoms:

clear Workspace;
MCLs = [70,85,100,115,130,140,150,160,170];
ilgis = size(MCLs);
for j = 1:ilgis(2)
	MCLs(j)
	load( strcat('/home/jonas/Viena LTE simuliator/LTE_System_Level_1.6_r885/results/r_300tti_5MHz_LdB',int2str(MCLs(j)),'.mat') )	
	velinimas(strcat('rez_300tti_5Mhz_LdB', int2str(MCLs(j)),'.txt'),strcat('S_MAP5Mhz_dB',int2str(MCLs(j)),'.txt'),strcat('R_MAP5Mhz_dB',int2str(MCLs(j)),'.txt'),MCLs(j),2140000000,5);
	clear Workspace;
end

Norint rasti suvidurkintas priklausomybes naudojame 'vidurkis.m'.

