/*-------------------------------------------------------------------------
В городе Лос-Сантос мэрия города украла из городского бюджета средства предназначенные для украшений новогодней ёлки.
Об этом узнал председатель исполнительного комитета Виталий Наливкин и первым же рейсом из Уссурийска отправился спасать праздник города.
С собой он взял напарника и 192 ёлочных игрушек.
Заехать на старом грузовике на горку у него не получилось, поэтому он остановился возле мэрии и ему нужна помощь каждого жителя города, что бы донести игрушки до крана, который поднимет и закрепит игрушки на ёлку.
После того, как последняя игрушка будет закреплена на ёлке, председатель исполнительного комитета Виталий Наливкин объявит о десяти минутной готовности о снесении крана.
Вскоре, он и его напарник отправится к крану со скорой помощью, танком и экипажем LSPD.
Через десять минут кран начнёт взрываться, а после упадёт.
Хотите что нибудь исправить? Создать? Или нужно помочь?
Пишите в telegramm @vawylon
-----------------------------------------------------------------------*/


#include <a_samp>
#define L_WHITE 19281
#define L_RED 19282
#define L_GREEN 19283
#define L_BLUE 19284
#define L_PINK 19293
#define L_YELLOW 19294
#define L_B_RED 19296
#define L_B_WHITE 19296
#define L_B_GREEN 19297
#define L_B_BLUE 19298


new e_pickup;               // id пикаапа взятия коробки с прилавка
new Text3D:el_info_text;    // текст над пикапом
new el_info;                // id пикапа инфрмации о мероприятии
new prod_actor;             // id актёра продовца
new nalivkin;               // id актёра наливкина
new Text3D:nalivkin_name;   // id текста над головой наливкина
new ispickitem[MAX_PLAYERS] = {-1, ...};    // id объекта коробки со склада
new iseventstart;           // можно ли брать коробки?
new el_item_o[200][2];         // id объектов игрушек
new el_coret;               // id коретки на кране
new el_cruck;               // id объекта крюка
new el_cruck_item;          // id объекта поднимаемая игрушка на крюке, когда кран работает
new el_cruck_item_light;    // id объекта света поднимаемой игруки когда кран работает
new el_cran_vert;               // кран (стойка)
new el_cran_gor;                // id бъекта крана стрела
new el_line[19];            // id объектов верёвки
new el_trash[10];           // объекты обломков крана
new el_lar_obj;
new el_vehicle[20];
new el_static[30];
new el_attacher[MAX_PLAYER_NAME];
new playerid_move;
new timer_ElDestroyVehicleAndActor;
new timer_ExplCran;
new timer_ElCreateVehicle;
new timer_OnElFlyCam;
new timer_DestroyObject;
new timer_EL_AddObject;
new el_objmodelid[][2] =
{
	{3071, L_WHITE},
	{330, L_WHITE},
	{337, L_WHITE},
	{344, L_WHITE},
	{351, L_WHITE},
	{353, L_WHITE},
	{357, L_WHITE},
	{359, L_WHITE},
	{361, L_WHITE},
	{363, L_WHITE},
	{366, L_RED},
	{371, L_YELLOW},
	{373,  L_WHITE},
	{3071, L_WHITE},
	{353, L_WHITE},
	{1210, L_WHITE},
	{1212, L_GREEN},
	{19623, L_RED},
	{19590, L_PINK},
	{19317, L_RED},
	{19318, L_BLUE},
	{19319, L_YELLOW},
	{1240, L_RED},
	{1239, L_YELLOW},
	{1247, L_B_WHITE},
	{1252, L_B_WHITE},
	{1272, L_BLUE},
	{1273, L_B_GREEN},
	{1275, L_BLUE},
	{1276, L_GREEN},
	{1213, L_WHITE},
	{1214, L_RED},
	{1486, L_B_RED},
	{3809, L_WHITE},
	{1582, L_YELLOW},
	{2114, L_YELLOW},
	{1600, L_BLUE},
	{1603, L_WHITE},
	{1644, L_YELLOW},
	{1650, L_RED},
	{1654, L_RED},
	{1736, L_WHITE},
	{1854, L_RED},
	{2044, L_WHITE},
	{2061, L_WHITE},
	{2226, L_WHITE,},
	{2453, L_YELLOW},
	{2469, L_YELLOW},
	{2470, L_YELLOW},
	{2497, L_RED},
	{2498, L_BLUE},
	{2663, L_WHITE},
	{2680, L_WHITE},
	{2689, L_WHITE},
	{2690, L_RED},
	{2704, L_YELLOW},
	{2726, L_RED},
	{3017, L_BLUE},
	{3056, L_RED},
	{3082, L_GREEN},
	{11704, L_RED},
	{14705, L_WHITE},
	{18865, L_YELLOW},
	{18866, L_BLUE},
	{18869, L_PINK},
	{18870, L_RED},
	{18927, L_BLUE},
	{18928, L_PINK},
	{18932, L_YELLOW},
	{18963, L_WHITE},
	{19025, L_WHITE},
	{19029, L_WHITE},
	{19033, L_WHITE},
	{19036, L_WHITE},
	{19037, L_RED},
	{19038, L_GREEN},
	{19065, L_RED},
	{19066, L_WHITE},
	{19094, L_YELLOW},
	{19137, L_YELLOW},
	{19308, L_YELLOW},
	{19422, L_B_RED},
	{19522, L_B_WHITE},
	{19524, L_B_WHITE},
	{19528, L_WHITE},
	{19591, L_WHITE},
	{19592, L_B_WHITE},
	{19904, L_YELLOW}
};


stock MoveLineLR(Float: y)
{
		new Float: ox, Float: oy, Float: oz;
		for(new i; i<sizeof(el_line); i++)
		{

		    if(IsValidObject(el_line[i]))
		    {
		        GetObjectPos(el_line[i], ox, oy, oz);
		        MoveObject(el_line[i], ox, oy + y, oz, 1.0, 0.0, 0.0, 0.0);

		    }
		}
		GetObjectPos(el_coret, ox, oy, oz);
		MoveObject(el_coret, ox, oy + y, oz, 1.0, 0.0, 0.0, 0.0);
		GetObjectPos(el_cruck, ox, oy, oz);
		
		MoveObject(el_cruck_item, ox, oy + y, oz-1.2, 1.0, 0.0, 0.0, 0.0);
		MoveObject(el_cruck_item_light, ox, oy + y, oz-1.2, 1.0, 0.0, 0.0, 0.0);
		MoveObject(el_cruck, ox, oy + y, oz, 1.0, 0.0, 0.0, 0.0);
		return 1;
}
stock MoveLineTB(Float: z)
{
	if(z >= 0.0 && z <= 2.4)
	{
		new Float: ox, Float: oy, Float: oz;
		for(new i=1; i<sizeof(el_line); i++)
		{

		    if(IsValidObject(el_line[i]))
		    {
		        GetObjectPos(el_line[i], ox, oy, oz);
		        MoveObject(el_line[i], ox, oy, 113.495-i*z, 6.0, 0.0, 0.0, 0.0);
		    }
		}
		GetObjectPos(el_cruck, ox, oy, oz);
		MoveObject(el_cruck_item, ox, oy, 113.495-(sizeof(el_line)-1)*z-2.0, 6.0, 0.0, 0.0, 0.0);
		MoveObject(el_cruck_item_light, ox, oy, 113.495-(sizeof(el_line)-1)*z-2.0, 6.0, 0.0, 0.0, 0.0);
		MoveObject(el_cruck, ox, oy, 113.495-(sizeof(el_line)-1)*z-2.0, 6.0, 0.0, 0.0, 0.0);
		
		return 1;
	}
	return 0;
}

new el_line_state;

forward StartMoveLine(playerid);
public StartMoveLine(playerid)
{
	if (playerid == -1) playerid = playerid_move;
	switch(el_line_state)
	{
	    case 0: // поднимаем
	    {
	        PlayerPlaySound(playerid, 6800, 0.0, 0.0, 0.0);
	        new Float:x, Float:y, Float:z;
	        GetObjectPos(el_cruck, x, y, z);
	        new r =random(sizeof(el_objmodelid));
	        el_cruck_item = CreateObject(el_objmodelid[r][0], x, y, z-1.2, 0.0, 0.0, 0.0);
	        el_cruck_item_light = CreateObject(el_objmodelid[r][1], x, y, z-1.2, 0.0, 0.0, 0.0);
	        el_line_state = 6;
	        MoveLineTB(0.5);
	    }
	    case 6: // передвигаем к ёлке
	    {
	        if(IsPlayerConnected(playerid))
	        {
	            PlayerPlaySound(playerid, 17801, 0.0, 0.0, 0.0);
				SetPlayerCameraPos(playerid, 1182.84, -2066.47, 121.46);
				SetPlayerCameraLookAt(playerid, 1182.74, -2066.11, 121.13, CAMERA_MOVE);
			}
	        el_line_state--;
	        MoveLineLR(12.5);
	    }
	    case 5: // опускаем
	    {

	        if(IsPlayerConnected(playerid)) PlayerPlaySound(playerid, 6800, 0.0, 0.0, 0.0);
	        el_line_state--;
	        MoveLineTB(1.8);
	    }
	    case 4: // пауза
		{
	        AttachElItem();
	        if(IsPlayerConnected(playerid)) PlayerPlaySound(playerid, 11200, 0.0, 0.0, 0.0);
	        el_line_state--;
	        MoveLineTB(1.9);
	    }
	    case 3: // поднимаем
	    {
	        if(IsPlayerConnected(playerid))
	        {
	        	PlayerPlaySound(playerid, 6800, 0.0, 0.0, 0.0);
	        }
	        el_line_state--;
	        MoveLineTB(0.5);
	        DestroyObject(el_cruck_item);
	        DestroyObject(el_cruck_item_light);
	    }
		case 2: // передвигаем
		{
		    if(IsPlayerConnected(playerid))
	        {
		    	PlayerPlaySound(playerid, 17801, 0.0, 0.0, 0.0);
		    }
		    el_line_state--;
		    MoveLineLR(-12.5);
		}
		case 1: //опускаем
		{
		    if(IsPlayerConnected(playerid))
	        {
			    PlayerPlaySound(playerid, 6800, 0.0, 0.0, 0.0);
			    SetCameraBehindPlayer ( playerid ) ;
		    }
		    el_line_state = -1;
		    MoveLineTB((113.495 - 69.0078) / sizeof(el_line));
		}
		case -1:    //заканчиваем
		{
		    timer_EL_AddObject = SetTimer("EL_AddObject", 200, false);
		    if(IsPlayerConnected(playerid))
		    {
		    	PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
		    }
		    el_line_state = 0;
		}
	}
}


stock CreateLine()
{
	new Float:r = (113.495 - 69.0078) / sizeof(el_line);
	for(new i; i<sizeof(el_line); i++)
	{
	
	    el_line[i] = CreateObject(19087, 1174.81702, -2049.04395, 113.495-r*i, 0.0, 0.0, 0.0);
	    if(i == sizeof(el_line)-1)
	    {
     		el_cruck = CreateObject(1390, 1174.81702, -2049.04395, 113.495-r*i-2.0, 0.0, 0.0, 0.0);
	    }
	}
}

stock DestroyLine()
{
	for(new i; i<sizeof(el_line); i++)
	{
	    if(IsValidObject(el_line[i])) DestroyObject(el_line[i]);
	}
}


new el_flymap_pos[MAX_PLAYERS];
new Float:el_flymap[][] = {
{1449.55, -1733.72, 16.91, 1449.37, -1733.27, 16.77},
{1395.49, -1731.29, 20.33, 1395.31, -1731.75, 20.22},
{1382.14, -1870.82, 19.19, 1382.63, -1870.90, 19.12},
{1431.02, -1867.89, 21.48, 1430.86, -1868.35, 21.37},
{1431.56, -1921.23, 26.31, 1431.07, -1921.25, 26.23},
{1262.70, -1903.05, 39.37, 1262.52, -1903.48, 39.18},
{1245.58, -1923.25, 39.37, 1245.99, -1923.52, 39.31},
{1409.53, -1976.26, 58.91, 1409.89, -1976.59, 58.80},
{1418.76, -2045.38, 65.75, 1418.26, -2045.42, 65.70},
{1309.41, -2063.04, 71.34, 1308.93, -2062.92, 71.28},
{1249.83, -2037.08, 63.41, 1249.33, -2037.05, 63.39},
{1218.05, -2036.60, 75.38, 1217.57, -2036.55, 75.52},
{1196.90, -2036.75, 74.06, 1196.42, -2036.77, 73.94},
{1205.49, -1980.80, 104.96, 1205.21, -1981.16, 104.77}
};


enum ie_pos {
	Float:ei_x,
	Float:ei_y,
	Float:ei_z,
	Float:ei_rx,
	Float:ei_ry,
	Float:ei_rz,
	ei_id
};
new Float:item_el[][ie_pos] = {
{1176.474, -2039.76099, 77.811, 0.00, 0.00, 0.00, 1},
{1174.15503, -2036.50806, 91.936, 0.00, 0.00, 0.00, 2},
{1175.40295, -2036.04004, 91.936, 0.00, 0.00, 0.00, 3},
{1175.91504, -2037.03503, 91.936, 0.00, 0.00, 0.00, 4},
{1175.23999, -2037.64001, 91.936, 0.00, 0.00, 0.00, 5},
{1174.19897, -2037.22205, 91.936, 0.00, 0.00, 0.00, 6},
{1173.77295, -2037.40002, 90.711, 0.00, 0.00, 0.00, 7},
{1174.229, -2038.02002, 90.711, 0.00, 0.00, 0.00, 8},
{1175.80896, -2038.06494, 90.711, 0.00, 0.00, 0.00, 9},
{1175.86694, -2036.98999, 90.711, 0.00, 0.00, 0.00, 10},
{1175.53101, -2036.31604, 90.711, 0.00, 0.00, 0.00, 11},
{1174.82104, -2035.849, 90.711, 0.00, 0.00, 0.00, 12},
{1174.84497, -2035.85303, 89.886, 0.00, 0.00, 0.00, 13},
{1175.90796, -2036.32397, 89.886, 0.00, 0.00, 0.00, 14},
{1176.20105, -2037.65906, 89.886, 0.00, 0.00, 0.00, 15},
{1175.44104, -2038.56494, 89.886, 0.00, 0.00, 0.00, 16},
{1175.43994, -2038.56494, 88.936, 0.00, 0.00, 0.00, 17},
{1174.479, -2038.20898, 88.936, 0.00, 0.00, 0.00, 18},
{1173.70801, -2037.33801, 88.936, 0.00, 0.00, 0.00, 19},
{1173.70801, -2037.33789, 88.936, 0.00, 0.00, 0.00, 20},
{1174.19104, -2036.27795, 88.936, 0.00, 0.00, 0.00, 21},
{1174.30298, -2036.41199, 90.311, 0.00, 0.00, 0.00, 22},
{1174.30298, -2036.41101, 87.811, 0.00, 0.00, 0.00, 23},
{1175.22595, -2035.448, 87.811, 0.00, 0.00, 0.00, 24},
{1175.90198, -2036.26501, 87.811, 0.00, 0.00, 0.00, 25},
{1176.73706, -2037.08704, 87.811, 0.00, 0.00, 0.00, 26},
{1176.03296, -2038.24194, 87.811, 0.00, 0.00, 0.00, 27},
{1174.87402, -2038.43604, 87.811, 0.00, 0.00, 0.00, 28},
{1172.87598, -2037.70605, 87.811, 0.00, 0.00, 0.00, 29},
{1173.56006, -2036.50598, 87.811, 0.00, 0.00, 0.00, 30},
{1174.15002, -2036.00598, 87.811, 0.00, 0.00, 0.00, 31},
{1173.82605, -2035.62402, 86.286, 0.00, 0.00, 0.00, 32},
{1176.49304, -2036.34399, 86.286, 0.00, 0.00, 0.00, 33},
{1176.89795, -2037.09094, 85.536, 0.00, 0.00, 0.00, 34},
{1176.43201, -2036.29102, 85.536, 0.00, 0.00, 0.00, 35},
{1175.97095, -2037.51904, 85.536, 0.00, 0.00, 0.00, 36},
{1174.93396, -2038.51697, 85.536, 0.00, 0.00, 0.00, 37},
{1173.38794, -2038.76501, 85.536, 0.00, 0.00, 0.00, 38},
{1172.74194, -2037.69995, 85.536, 0.00, 0.00, 0.00, 39},
{1172.83398, -2036.26697, 85.536, 0.00, 0.00, 0.00, 40},
{1173.22803, -2034.82495, 85.536, 0.00, 0.00, 0.00, 41},
{1173.22803, -2034.82397, 84.436, 0.00, 0.00, 0.00, 42},
{1173.33105, -2036.20801, 84.436, 0.00, 0.00, 27.75, 43},
{1175.70996, -2034.45203, 84.436, 0.00, 0.00, 25.996, 44},
{1175.70996, -2034.45105, 85.686, 0.00, 0.00, 25.994, 45},
{1178.80505, -2035.14001, 84.661, 0.00, 0.00, 25.994, 46},
{1178.66602, -2034.81799, 84.661, 0.00, 0.00, 85.994, 47},
{1177.86694, -2036.91797, 83.936, 0.00, 0.00, 155.49, 48},
{1178.24597, -2036.60706, 83.361, 0.00, 0.00, 155.49, 49},
{1177.14001, -2036.58997, 83.361, 0.00, 0.00, 155.49, 50},
{1176.80005, -2037.047, 84.711, 0.00, 0.00, 155.49, 51},
{1175.37195, -2038.89197, 84.711, 0.00, 0.00, 155.49, 52},
{1174.97302, -2038.35901, 84.711, 0.00, 0.00, 155.49, 53},
{1174.97302, -2038.35803, 83.536, 0.00, 0.00, 155.49, 54},
{1175.46802, -2039.10498, 83.536, 0.00, 0.00, 155.49, 55},
{1175.54004, -2039.81201, 82.861, 0.00, 0.00, 143.99, 56},
{1174.04504, -2039.84094, 82.861, 0.00, 0.00, 219.987, 57},
{1174.74097, -2039.04797, 82.861, 0.00, 0.00, 219.985, 58},
{1174.73999, -2039.04797, 83.961, 0.00, 0.00, 219.985, 59},
{1173.85706, -2039.80505, 83.961, 0.00, 0.00, 219.985, 60},
{1174.29395, -2039.12, 84.936, 0.00, 0.00, 219.985, 61},
{1173.38098, -2038.099, 84.936, 0.00, 0.00, 223.735, 62},
{1173.13599, -2038.71497, 84.936, 0.00, 0.00, 243.731, 63},
{1172.71704, -2037.92505, 84.361, 0.00, 0.00, 243.726, 64},
{1173.276, -2038.76697, 84.111, 0.00, 0.00, 243.726, 65},
{1173.22205, -2039.46802, 84.311, 0.00, 0.00, 243.726, 66},
{1172.92395, -2039.427, 83.511, 0.00, 0.00, 243.726, 67},
{1173.25305, -2038.68896, 83.511, 0.00, 0.00, 243.726, 68},
{1173.77295, -2037.85095, 83.511, 0.00, 0.00, 243.726, 69},
{1173.44495, -2038.59094, 82.936, 0.00, 0.00, 243.726, 70},
{1172.95605, -2039.28503, 82.936, 0.00, 0.00, 243.726, 71},
{1173.08105, -2039.29602, 81.961, 0.00, 0.00, 243.726, 72},
{1173.06396, -2036.09705, 81.961, 0.00, 0.00, 303.726, 73},
{1172.73096, -2035.22302, 81.961, 0.00, 0.00, 303.723, 74},
{1173.09595, -2035.64099, 82.436, 0.00, 0.00, 303.723, 75},
{1173.34497, -2035.61401, 83.211, 0.00, 0.00, 303.723, 76},
{1173.42004, -2036.31104, 83.211, 0.00, 0.00, 303.723, 77},
{1173.69995, -2036.104, 80.686, 0.00, 0.00, 303.723, 78},
{1172.98999, -2034.66895, 80.686, 0.00, 0.00, 303.723, 79},
{1173.05396, -2035.21399, 80.686, 0.00, 0.00, 303.723, 80},
{1173.97998, -2036.46106, 80.686, 0.00, 0.00, 303.723, 81},
{1173.59399, -2035.75305, 81.136, 0.00, 0.00, 303.723, 82},
{1173.50903, -2035.03406, 81.136, 0.00, 0.00, 303.723, 83},
{1173.62195, -2035.77405, 80.036, 0.00, 0.00, 303.723, 84},
{1173.14795, -2035.17603, 80.036, 0.00, 0.00, 303.723, 85},
{1173.18994, -2034.79102, 79.211, 0.00, 0.00, 303.723, 86},
{1173.34094, -2035.93103, 79.211, 0.00, 0.00, 303.723, 87},
{1176.23401, -2036.15198, 84.211, 0.00, 0.00, 243.723, 88},
{1176.50195, -2035.55103, 85.136, 0.00, 0.00, 243.721, 89},
{1176.92297, -2034.98999, 84.811, 0.00, 0.00, 243.721, 90},
{1176.57104, -2035.53503, 84.261, 0.00, 0.00, 243.721, 91},
{1176.42102, -2035.76501, 83.261, 0.00, 0.00, 243.721, 92},
{1176.78699, -2035.198, 83.261, 0.00, 0.00, 243.721, 93},
{1176.91797, -2034.71704, 83.886, 0.00, 0.00, 243.721, 94},
{1176.66699, -2035.56604, 82.311, 0.00, 0.00, 243.721, 95},
{1176.85205, -2034.495, 82.311, 0.00, 0.00, 243.721, 96},
{1177.08301, -2034.64294, 81.761, 0.00, 0.00, 243.721, 97},
{1176.88794, -2036.00403, 81.761, 0.00, 0.00, 243.721, 98},
{1177.70105, -2039.24597, 81.761, 0.00, 0.00, 203.721, 99},
{1177.44299, -2038.88599, 82.336, 0.00, 0.00, 203.719, 100},
{1176.85205, -2039.01099, 82.336, 0.00, 0.00, 203.719, 101},
{1178.17102, -2038.55298, 81.761, 0.00, 0.00, 203.719, 102},
{1179.20801, -2038.19299, 81.761, 0.00, 0.00, 203.719, 103},
{1178.01196, -2038.66797, 78.511, 0.00, 0.00, 203.719, 104},
{1178.23804, -2038.29102, 83.261, 0.00, 0.00, 203.719, 105},
{1176.70105, -2037.74194, 83.261, 0.00, 0.00, 203.719, 106},
{1177.38306, -2037.50403, 83.261, 0.00, 0.00, 203.719, 107},
{1177.39099, -2037.52795, 84.136, 0.00, 0.00, 203.719, 108},
{1176.495, -2037.83801, 84.136, 0.00, 0.00, 203.719, 109},
{1176.41199, -2037.60205, 85.061, 0.00, 0.00, 203.719, 110},
{1177.54395, -2037.36694, 85.061, 0.00, 0.00, 203.719, 111},
{1176.13306, -2040.24695, 79.811, 0.00, 0.00, 203.719, 112},
{1175.61694, -2039.15906, 79.811, 0.00, 0.00, 203.719, 113},
{1175.68298, -2039.28406, 80.886, 0.00, 0.00, 203.719, 114},
{1176.37903, -2040.41895, 80.886, 0.00, 0.00, 203.719, 115},
{1174.11206, -2039.71204, 81.261, 0.00, 0.00, 203.719, 116},
{1174.57996, -2039.38599, 80.211, 0.00, 0.00, 203.719, 117},
{1173.51404, -2039.60498, 80.211, 0.00, 0.00, 203.719, 118},
{1174.07495, -2039.97498, 79.211, 0.00, 0.00, 203.719, 120},
{1174.56799, -2038.83606, 79.686, 0.00, 0.00, 203.719, 121},
{1174.96399, -2038.23901, 79.686, 0.00, 0.00, 203.719, 122},
{1173.46399, -2040.01697, 76.861, 0.00, 0.00, 203.719, 123},
{1174.73901, -2039.16504, 76.861, 0.00, 0.00, 203.719, 124},
{1175.52002, -2038.10706, 77.486, 0.00, 0.00, 203.719, 125},
{1177.573, -2039.53101, 77.486, 0.00, 0.00, 203.719, 126},
{1176.36804, -2039.81006, 77.911, 0.00, 0.00, 203.719, 127},
{1178.56299, -2037.08801, 76.261, 0.00, 0.00, 203.719, 128},
{1177.50195, -2037.17896, 76.811, 0.00, 0.00, 203.719, 129},
{1175.31494, -2034.43396, 77.936, 0.00, 0.00, 203.719, 130},
{1175.36096, -2033.80298, 77.936, 0.00, 0.00, 203.719, 131},
{1174.91394, -2032.979, 77.186, 0.00, 0.00, 203.719, 132},
{1175.15405, -2034.11304, 77.561, 0.00, 0.00, 203.719, 133},
{1175.44995, -2035.01697, 77.811, 0.00, 0.00, 203.719, 134},
{1175.81604, -2034.52698, 77.386, 0.00, 0.00, 203.719, 135},
{1175.41602, -2033.62903, 77.386, 0.00, 0.00, 203.719, 136},
{1175.12097, -2032.328, 77.111, 0.00, 0.00, 203.719, 137},
{1171.02197, -2036.31104, 77.536, 0.00, 0.00, 203.719, 138},
{1172.30603, -2036.68604, 77.861, 0.00, 0.00, 203.719, 139},
{1172.86804, -2036.29797, 77.861, 0.00, 0.00, 203.719, 140},
{1172.02295, -2036.67297, 77.861, 0.00, 0.00, 203.719, 141},
{1171.37305, -2036.44202, 77.861, 0.00, 0.00, 203.719, 142},
{1173.56494, -2038.91504, 76.736, 0.00, 0.00, 203.719, 143},
{1173.59302, -2039.69104, 76.736, 0.00, 0.00, 203.719, 144},
{1173.14001, -2039.26697, 76.736, 0.00, 0.00, 203.719, 145},
{1172.76697, -2039.86902, 76.736, 0.00, 0.00, 203.719, 146},
{1172.37, -2040.69604, 76.736, 0.00, 0.00, 203.719, 147},
{1171.83398, -2037.56396, 80.086, 0.00, 0.00, 203.719, 148},
{1172.98499, -2037.39502, 80.086, 0.00, 0.00, 203.719, 149},
{1173.59595, -2037.62305, 80.086, 0.00, 0.00, 203.719, 150},
{1173.64099, -2037.53406, 80.861, 0.00, 0.00, 203.719, 151},
{1172.83704, -2037.57104, 80.861, 0.00, 0.00, 203.719, 152},
{1171.96497, -2037.797, 80.861, 0.00, 0.00, 203.719, 153},
{1172.03296, -2037.66394, 81.786, 0.00, 0.00, 203.719, 154},
{1172.72302, -2037.79199, 81.786, 0.00, 0.00, 203.719, 155},
{1173.21106, -2038.04199, 81.786, 0.00, 0.00, 203.719, 156},
{1173.21106, -2038.04199, 82.836, 0.00, 0.00, 203.719, 157},
{1172.63403, -2037.63501, 82.836, 0.00, 0.00, 203.719, 158},
{1174.65906, -2035.198, 82.836, 0.00, 0.00, 177.719, 159},
{1173.98999, -2034.60596, 82.836, 0.00, 0.00, 177.715, 160},
{1173.98901, -2034.60596, 82.336, 0.00, 0.00, 177.715, 161},
{1174.63696, -2034.98303, 82.336, 0.00, 0.00, 177.715, 162},
{1174.41797, -2035.60706, 84.311, 0.00, 0.00, 177.715, 163},
{1174.37195, -2034.74097, 84.986, 0.00, 0.00, 177.715, 164},
{1174.74805, -2035.68298, 85.261, 0.00, 0.00, 177.715, 165},
{1174.42505, -2034.94495, 85.961, 0.00, 0.00, 177.715, 166},
{1174.54199, -2035.04102, 80.861, 0.00, 0.00, 177.715, 167},
{1173.98303, -2034.31104, 80.861, 0.00, 0.00, 177.715, 168},
{1177.0, -2035.70703, 80.861, 0.00, 0.00, 213.215, 169},
{1177.13794, -2034.99597, 80.861, 0.00, 0.00, 213.212, 170},
{1177.03601, -2034.33899, 80.861, 0.00, 0.00, 213.212, 171},
{1176.85205, -2034.88904, 80.211, 0.00, 0.00, 213.212, 172},
{1176.40002, -2035.64099, 80.211, 0.00, 0.00, 213.212, 173},
{1176.51001, -2035.33105, 79.586, 0.00, 0.00, 213.212, 174},
{1176.255, -2036.12195, 79.586, 0.00, 0.00, 213.212, 175},
{1177.11304, -2034.45398, 79.586, 0.00, 0.00, 213.212, 176},
{1175.86902, -2035.61206, 78.461, 0.00, 0.00, 213.212, 177},
{1175.95703, -2036.59595, 78.461, 0.00, 0.00, 213.212, 178},
{1176.50903, -2035.93396, 78.111, 0.00, 0.00, 213.212, 179},
{1175.26099, -2034.91199, 78.561, 0.00, 0.00, 213.212, 180},
{1177.58301, -2039.51599, 78.511, 0.00, 0.00, 203.719, 181},
{1177.14502, -2039.14905, 78.511, 0.00, 0.00, 203.719, 182},
{1176.823, -2037.87695, 78.911, 0.00, 0.00, 203.719, 183},
{1176.79602, -2039.36206, 79.586, 0.00, 0.00, 203.719, 184},
{1176.46997, -2038.65503, 80.611, 0.00, 0.00, 203.719, 185},
{1176.00806, -2037.70703, 80.611, 0.00, 0.00, 203.719, 186},
{1177.00903, -2039.75696, 80.736, 0.00, 0.00, 203.719, 187},
{1176.92798, -2039.15906, 80.736, 0.00, 0.00, 203.719, 188},
{1177.06299, -2038.36401, 80.736, 0.00, 0.00, 203.719, 189},
{1176.72803, -2038.26294, 81.211, 0.00, 0.00, 203.719, 190},
{1176.70801, -2039.19604, 81.211, 0.00, 0.00, 203.719, 191},
{1176.823, -2038.81299, 81.211, 0.00, 0.00, 203.719, 192},
{1177.17603, -2036.18701, 81.207, 0.00, 0.00, 203.719, 193}
};


stock AttachElItem(in = 0)
{
	new modelid = GetObjectModel(el_cruck_item), count,light = GetObjectModel(el_cruck_item_light);
	for(new i; i<sizeof(item_el); i++)
	{
		if(!IsValidObject(el_item_o[i][0]))
		{
		    count ++;
		    new str[124];
		    if(in != 0)
		    {
		        modelid = el_objmodelid[random(sizeof(el_objmodelid))][0];
		        light = el_objmodelid[random(sizeof(el_objmodelid))][1];
		    }
		    el_item_o[i][0] = CreateObject(modelid, item_el[i][ei_x],item_el[i][ei_y],item_el[i][ei_z],item_el[i][ei_rx],item_el[i][ei_ry],item_el[i][ei_rz]);
			el_item_o[i][1] = CreateObject(light, item_el[i][ei_x],item_el[i][ei_y],item_el[i][ei_z],item_el[i][ei_rx],item_el[i][ei_ry],item_el[i][ei_rz]);
   			if(sizeof(item_el)-count == 0) // мест на ёлке для игрушек не осталось
			{
				SetWorldTime(0);
				format(str, sizeof(str), " Игрок {FFFFFF}%s{FFFFFF} установил последнию игрушку на ёлку!", el_attacher);
			    SendClientMessageToAll(0xFF0000FF, str);
			    SendClientMessageToAll(-1, "Благодаря Вам и пресидателю исполнительного комитета Виталию Наливкину,");
			    SendClientMessageToAll(-1, "удалось этот праздник наполнить атмосферой добра и счастья в каждом доме!");
				SendClientMessageToAll(-1, "Так-же, Витали Наливкин лично каждому жителю города перевёл на счёт 1.000$ из бюджета своего города");
                SendClientMessageToAll(0xFF0000FF, "С наступающим Новым годом!");
                SendClientMessageToAll(0xFF0000FF, "Через 10 минут будет снос крана, вы можете посмотреть на это зррелище!");

				timer_ExplCran = SetTimerEx("ExplCran", 1000*60*10, false, "d", 0);
				timer_ElCreateVehicle = SetTimerEx("ElCreateVehicleAndTPAct", 1000*60, false, "d", 0);
				for(new p; p<MAX_PLAYERS; p++)
				{
				    if(IsPlayerConnected(p)) GivePlayerMoney(p, 1000);
				}
			}
			else
			{
			    format(str, sizeof(str), " Игрок {FF0000}%s{FFFFFF} благополучно устновил игрушку на ёлку.", el_attacher);
			    SendClientMessageToAll(-1, str);
			    format(str, sizeof(str), " Помогите Виталию Наливкину поднять и установить {FF0000}%d{FFFFFF} игрушек на ёлку!", sizeof(item_el)-count);
			    SendClientMessageToAll(-1, str);
			    SendClientMessageToAll(0xFF0000FF, "Что бы город наполнился новогодей атмосферой праздника!");
		    }
			break;
		}
		else
		{
		    count ++;
		}
		
	}
    DestroyObject(el_cruck_item);
    DestroyObject(el_cruck_item_light);
}
public OnFilterScriptInit()
{
	el_static[0] = CreateObject(687, 1174.94202, -2036.54895, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (1)
	el_static[1] = CreateObject(687, 1174.78198, -2036.56396, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (2)
	el_static[2] = CreateObject(687, 1174.396, -2036.74695, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (3)
	el_static[3] = CreateObject(687, 1174.30103, -2036.94604, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (4)
	el_static[4] = CreateObject(687, 1174.51794, -2037.34705, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (5)
	el_static[5] = CreateObject(687, 1174.90698, -2037.52002, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (6)
	el_static[6] = CreateObject(687, 1175.19202, -2037.33606, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (7)
	el_static[7] = CreateObject(687, 1175.45996, -2037.02698, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (8)
	el_static[8] = CreateObject(687, 1175.45996, -2037.02637, 66.414, 0.00, 0.00, 0.00); //object (sm_fir_) (9)
	el_static[9] = CreateObject(19054, 1179.88904, -2039.15405, 68.66, 0.00, 0.00, 0.00); //object (XmasBox1) (1)
	el_static[10] = CreateObject(19055, 1178.06396, -2037.005, 68.664, 0.00, 0.00, 0.00); //object (XmasBox2) (1)
	el_static[11] = CreateObject(19055, 1171.15906, -2034.17505, 68.664, 0.00, 0.00, 0.00); //object (XmasBox2) (2)
	el_static[12] = CreateObject(19056, 1176.68103, -2033.98401, 68.664, 0.00, 0.00, 0.00); //object (XmasBox3) (1)
	el_static[13] = CreateObject(19056, 1173.00403, -2041.12903, 68.664, 0.00, 0.00, 0.00); //object (XmasBox3) (2)
	el_static[14] = CreateObject(19057, 1177.54602, -2042.61694, 68.664, 0.00, 0.00, 0.00); //object (XmasBox4) (1)
	el_static[15] = CreateObject(19058, 1180.95996, -2034.91296, 68.664, 0.00, 0.00, 0.00); //object (XmasBox5) (1)
	el_static[16] = CreateObject(19058, 1170.72803, -2038.83105, 68.664, 0.00, 0.00, 0.00); //object (XmasBox5) (2)
	
    el_cran_vert = CreateObject(1391, 1174.81799, -2016.13904, 98.288, 0.00, 0.00, 0.00); //object (TwrCrane_S_03) (1)
	el_cran_gor = CreateObject(1388, 1174.83887, -2015.98828, 110.45, 0.00, 0.00, 180); //object (TwrCrane_S_04) (1)
	el_coret = CreateObject(1392, 1174.58398, -2049.10205, 113.8, 0.00, 0.00, 0.00); //object (TwrCrane_L_04) (1)
	
	el_static[17] = CreateObject(9126, 1133.96802, -2022.54895, 66.693, 0.00, 0.00, 90); //object (cmtneon01) (1)
	el_static[18] = CreateObject(9126, 1133.48303, -2055.07788, 66.693, 0.00, 0.00, 90); //object (cmtneon01) (2)
	el_static[19] = CreateObject(9123, 1137.297, -2038.42395, 74.158, 0.00, 0.00, 0.00); //object (ballyneon01) (1)
	el_static[20] = CreateObject(13461, 1226.40601, -2023.047, 239.77699, 0.00, 0.00, 0.00); //object (CE_nitewindows1) (1)
	el_static[21] = CreateObject(19291, 1174.66101, -2037.10803, 93.758, 0.00, 0.00, 0.00); //object (PointLight11) (1)
	// звезда
	el_static[22] = CreateObject(7666, 1174.75305, -2037.02698, 93.739, 0.00, 0.00, 0.00); //object (vgswlcmsign2) (1)
	el_static[23] = CreateObject(7666, 1174.71399, -2036.90698, 93.739, 0.00, 0.00, 272); //object (vgswlcmsign2) (3)
	el_static[24] = CreateObject(19295, 1174.59705, -2036.10596, 94.145, 0.00, 0.00, 0.00); //object (PointLight15) (1)
	

    prod_actor = CreateActor(264, 1446.1902,-1723.8474,13.5469, 180.0, "");

	el_lar_obj = CreateObject(3861, 1446.23804, -1724.224, 13.878, 0.00, 0.00, 0.00); //object (CJ_NOODLE_1) (1)
	
	e_pickup = CreatePickup(19132, 1, 1446.41504, -1726.18701, 13.203);
	el_info = CreatePickup(1239, 2, 1441.6010,-1723.3846,13.5469);
	el_info_text = Create3DTextLabel("Информация", 0xffff00FF, 1441.6010,-1723.3846,14.5469, 10.0, false);
	nalivkin = CreateActor(113, 1443.6725,-1722.7814,13.5469,174.2251, "");
	nalivkin_name = Create3DTextLabel("Предсидатель исполнительного комитета\nВиталий Наливкин", 0xb1dcfcFF, 1443.6725,-1722.7814,14.8469, 15.0, false);
	CreateBoxes();
	EL_AddObject();
	CreateLine();
	return 1;
}

stock DestroyPost()
{
	DestroyObject(el_lar_obj);
	DestroyPickup(el_info);
	DestroyPickup(e_pickup);
	Delete3DTextLabel(el_info_text);
}

public OnFilterScriptExit()
{
	KillTimer(timer_OnElFlyCam);
	KillTimer(timer_ElDestroyVehicleAndActor);
	KillTimer(timer_ExplCran);
	KillTimer(timer_ElCreateVehicle);
	KillTimer(timer_DestroyObject);
	
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))

	    {
	    	El_DropItem(i);
	    }
	}
	for(new i; i<sizeof(el_static); i++)
	{
	    if(IsValidObject(el_static[i])) DestroyObject(el_static[i]);
	}
	for(new i; i<sizeof(item_el); i++)
	{
		    if(IsValidObject(el_item_o[i][0])) DestroyObject(el_item_o[i][0]);
		    if(IsValidObject(el_item_o[i][1])) DestroyObject(el_item_o[i][1]);
	}
	el_line_state = 0;
	DestroyObject(el_cruck);
	DestroyObject(el_coret);
	DestroyObject(el_cruck_item);
	DestroyObject(el_cruck_item_light);
	DestroyPickup(e_pickup);
	DestroyPickup(el_info);
	KillTimer(timer_EL_AddObject);
	DestroyCran();
	DestroyBoxes();
	DestroyActor(prod_actor);
	DestroyActor(nalivkin);
	for(new v; v<sizeof(el_vehicle); v++)
	{
	    if(IsValidVehicle(el_vehicle[v])) DestroyVehicle(el_vehicle[v]);
	}
	DestroyTrash();
	DestroyPost();
	Delete3DTextLabel(nalivkin_name);
	Delete3DTextLabel(el_info_text);
	iseventstart = false;
	return 1;
}




main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


public OnPlayerDisconnect(playerid, reason)
{
    if(playerid_move == playerid) playerid_move = 0;
	El_DropItem(playerid);
	return 1;
}


forward Float:GetDistance( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 );
public Float:GetDistance( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 )
{
	return floatsqroot( ( ( x1 - x2 ) * ( x1 - x2 ) ) + ( ( y1 - y2 ) * ( y1 - y2 ) ) + ( ( z1 - z2 ) * ( z1 - z2 ) ) );
}
forward OnElFlyCam(playerid);
public OnElFlyCam(playerid)
{
	timer_OnElFlyCam = 0;
	if(el_flymap_pos[playerid]+1 >= sizeof(el_flymap))
	{
	    el_flymap_pos[playerid] = 0;
	    ShowPlayerDialog(playerid, 20002, DIALOG_STYLE_MSGBOX, "{FFcc00}Информация", "Возле ёлки находится крюк, принесите, распакуйте и повешайте игрушку на крюк\n\
	                                                            Кран поднимет и повешает игрушку на ёлку\n\
	                                                            Как будут повешаные все игрушки, Виталий Наливкин демонтирует кран с помощью взрыва.", "Закрыть", "");
	 	return 1;
	}

	new Float:distance = GetDistance(el_flymap[el_flymap_pos[playerid]][0],
						el_flymap[el_flymap_pos[playerid]][1],
						el_flymap[el_flymap_pos[playerid]][2],
						el_flymap[el_flymap_pos[playerid]+1][0],
						el_flymap[el_flymap_pos[playerid]+1][1],
						el_flymap[el_flymap_pos[playerid]+1][2]);
	new time = floatround(distance*20.0, floatround_floor);
	if(el_flymap_pos[playerid] == 0)
	{
     	SetPlayerCameraPos(playerid,
						el_flymap[el_flymap_pos[playerid]][0],
						el_flymap[el_flymap_pos[playerid]][1],
						el_flymap[el_flymap_pos[playerid]][2]);
		SetPlayerCameraLookAt(playerid,
							el_flymap[el_flymap_pos[playerid]][0],
							el_flymap[el_flymap_pos[playerid]][1],
							el_flymap[el_flymap_pos[playerid]][2], CAMERA_MOVE);
	}
	else
	{
		TogglePlayerSpectating ( playerid, 1 ) ;
		InterpolateCameraPos(playerid,
							el_flymap[el_flymap_pos[playerid]][0],
							el_flymap[el_flymap_pos[playerid]][1],
							el_flymap[el_flymap_pos[playerid]][2],
							el_flymap[el_flymap_pos[playerid]+1][0],
							el_flymap[el_flymap_pos[playerid]+1][1],
							el_flymap[el_flymap_pos[playerid]+1][2],
							time, CAMERA_MOVE);
	    InterpolateCameraLookAt(playerid,
							el_flymap[el_flymap_pos[playerid]][3],
							el_flymap[el_flymap_pos[playerid]][4],
							el_flymap[el_flymap_pos[playerid]][5],
							el_flymap[el_flymap_pos[playerid]+1][3],
							el_flymap[el_flymap_pos[playerid]+1][4],
							el_flymap[el_flymap_pos[playerid]+1][5],
							time, CAMERA_MOVE);

	}

	timer_OnElFlyCam = SetTimerEx("OnElFlyCam", time-100, false, "d", playerid);
	el_flymap_pos[playerid] ++;
	return 1;
}
/*
DestroyObject(el_cran_vert);
	DestroyObject(el_cran_gor);
	DestroyObject(el_coret);
	DestroyLine();*/
forward ExplCran(val);
public ExplCran(val)
{
    timer_ExplCran = 0;
	switch(val)
	{
	    case 0:
	    {
	        SendClientMessageToAll(0xFFcc00FF, "Предсидатель исполнительного комитета Виталий Наливкин - взорвал кран!");
	        DestroyObject(el_coret);
	        CreateExplosion(1173.0688,-2016.5586,70.814, 0, 2.0);
			CreateExplosion(1173.0688,-2016.5586,85.814, 0, 2.0);
	  		CreateExplosion(1173.0688,-2016.5505, 113.8, 0, 2.0);
	  		timer_ExplCran = SetTimerEx("ExplCran", 1000, false, "d", 1);
	  		return 1;
	  		
	    }
	    case 1:
	    {
	        DestroyLine();
	        DestroyObject(el_cruck);
	        CreateExplosion(1173.0688,-2016.5586,70.814, 0, 2.0);
	        CreateExplosion(1173.0688,-2016.5505, 113.8, 0, 2.0);
	  		CreateExplosion(1173.0688,-2035.5505, 113.8, 0, 2.0);
	  		CreateExplosion(1173.0688,-2049.10205, 113.8, 0, 2.0);
	  		timer_ExplCran = SetTimerEx("ExplCran", 1000, false, "d", 2);
	  		return 1;
	    }
	    case 2:
	    {
	        new Float: x, Float: y, Float: z, Float:rx, Float:ry, Float:rz;
	        GetObjectPos(el_cran_gor, x, y, z);
	        GetObjectRot(el_cran_gor, rx, ry, rz);
	        MoveObject(el_cran_gor, x, y, z - 0.5, 0.05, rx, ry, 0.1);
	        CreateExplosion(1173.0688,-2016.5586,70.814, 0, 2.0);
	        CreateExplosion(1173.0688,-2016.5505, 113.8, 0, 2.0);
	        timer_ExplCran = SetTimerEx("ExplCran", 4000, false, "d", 3);
	        return 1;
	    }
	    case 3:
	    {
	        CreateExplosion(1173.0688,-2016.5586,70.814, 0, 2.0);
	        CreateExplosion(1173.0688,-2016.5505, 82.8, 0, 2.0);
	        timer_ExplCran = SetTimerEx("ExplCran", 1000, false, "d", val + 1);
	        return 1;
	    }
	    case 4:
	    {
	        CreateExplosion(1173.0688,-2016.5586,70.814, 0, 2.0);
	        CreateExplosion(1173.0688,-2016.5505, 82.8, 0, 2.0);
	        timer_ExplCran = SetTimerEx("ExplCran", 1000, false, "d", val + 1);
	        return 1;
	    }
	    case 5:
	    {
	        new Float: x, Float: y, Float: z, Float:rx, Float:ry, Float:rz;
	        el_trash[0] =CreateObject(10985, 1177.59705, -2008.21802, 69.629 - 10.0, 0.00, 0.00, 0.00); //object (rubbled02_SFS) (1)
			el_trash[1] =CreateObject(952, 1182.65198, -2009.62305, 71.118 - 10.0, 0.00, 0.00, 0.00); //object (GENERATOR_BIG_d) (1)
			el_trash[2] =CreateObject(849, 1179.93604, -2008.28894, 70.993 - 10.0, 0.00, 0.00, 0.00); //object (CJ_urb_rub_3) (1)
			el_trash[3] =CreateObject(849, 1180.67297, -2005.81995, 70.728 - 10.0, 0.00, 0.00, 0.00); //object (CJ_urb_rub_3) (2)
			el_trash[4] =CreateObject(849, 1177.28406, -2006.31494, 70.869 - 10.0, 0.00, 0.00, 0.00); //object (CJ_urb_rub_3) (3)
			el_trash[5] =CreateObject(849, 1180.89001, -2014.50598, 69.312 - 10.0, 0.00, 0.00, 0.00); //object (CJ_urb_rub_3) (4)
			el_trash[6] =CreateObject(849, 1183.25195, -2012.85999, 69.5 - 10.0, 0.00, 0.00, 0.00); //object (CJ_urb_rub_3) (5)
			el_trash[7] =CreateObject(2890, 1177.20203, -2013.28296, 69.121 - 10.0, 0.00, 0.00, 0.00); //object (kmb_skip) (1)
			el_trash[8] =CreateObject(18248, 1188.34802, -2014.60596, 63.075 - 10.0, 36, 0.00, 80); //object (cuntwjunk01) (1)
	        for(new o; o<sizeof(el_trash); o++)
			{
				if(IsValidObject(el_trash[o]))
		        {
		            GetObjectPos(el_trash[o], x, y, z);
		            MoveObject(el_trash[o], x, y, z+10.0, 2.0, 0.0, 0.0, 0.0);
		        }
	        }
	        GetObjectPos(el_cran_gor, x, y, z);
	        GetObjectRot(el_cran_gor, rx, ry, rz);
	        MoveObject(el_cran_gor, x, y, 30.0, 8.0, rx-120.0, ry + 82.0, rz + 5.0);
	        GetObjectPos(el_cran_vert, x, y, z);
	        GetObjectRot(el_cran_vert, rx, ry, rz);
	        MoveObject(el_cran_vert, x, y, z-70.0, 8.0, rx, ry, rz);
	        timer_ExplCran = SetTimerEx("ExplCran", 5000, false, "d", val + 1);
	        return 1;
	    }
	    case 6:
	    {
	        new Float: x, Float: y, Float: z;
     		for(new o; o<sizeof(el_trash); o++)
			{
				if(IsValidObject(el_trash[o]))
		        {
		            GetObjectPos(el_trash[o], x, y, z);
		            MoveObject(el_trash[o], x, y, z-10.0, 2.0, 0.0, 0.0, 0.0);
		        }
	        }
	        timer_ExplCran = SetTimerEx("ExplCran", 3000, false, "d", val + 1);
	        return 1;
	    }
	    case 7:
	    {
	        new Float: x, Float: y, Float: z;
     		for(new o; o<sizeof(el_trash); o++)
			{
		        if(IsValidObject(el_trash[o]))
	     		{
			            GetObjectPos(el_trash[o], x, y, z);
			            MoveObject(el_trash[0], x, y, z-10.0, 5.0, 0.0, 0.0, 0.0);
	       		}
       		}
       		timer_ExplCran = SetTimerEx("ExplCran", 3000, false, "d", val + 1);
	        return 1;
	    }
	    case 8:
	    {
	        DestroyTrash();
	        DestroyCran();
	    }
	}
	return 1;
}

forward ElCreateVehicleAndTPAct();
public ElCreateVehicleAndTPAct()
{
    DestroyPost(); // удаляем пост
	timer_ElCreateVehicle = 0;
    el_vehicle[0] = AddStaticVehicle(470,1207.2638,-2029.4127,68.9996,64.6168,43,0); // v1
	el_vehicle[1] = AddStaticVehicle(544,1197.4410,-2058.5757,69.2371,17.3911,3,1); // v1
	el_vehicle[2] = AddStaticVehicle(599,1201.6824,-2053.6426,69.1893,21.4063,0,1); // v1
	el_vehicle[3] = AddStaticVehicle(432,1291.8956,-2061.5078,58.6342,60.9686,43,0); // tank
	el_vehicle[4] = AddStaticVehicle(416,1276.6672,-2038.8932,59.1244,122.5611,1,3); //
	SetActorPos(nalivkin, 1203.3206,-2023.9576,69.0078);
	SetActorFacingAngle(nalivkin, 65.4973);
	Delete3DTextLabel(nalivkin_name);
	nalivkin_name = Create3DTextLabel("Предсидатель исполнительного комитета\nВиталий Наливкин", 0xb1dcfcFF, 1203.3206,-2023.9576,69.0078+2, 30.0, false);
	SetActorPos(prod_actor, 1200.6256,-2031.6165,69.0078);
	SetActorFacingAngle(prod_actor, 65.4973);
	timer_ElDestroyVehicleAndActor = SetTimer("ElDestroyVehicleAndActor", 1000*60*15, false);
}

forward ElDestroyVehicleAndActor();
public ElDestroyVehicleAndActor()
{
	for(new v; v<sizeof(el_vehicle); v++)
	{
	    if(IsValidVehicle(el_vehicle[v])) DestroyVehicle(el_vehicle[v]);
	}
	DestroyActor(nalivkin);
	DestroyActor(prod_actor);
    Delete3DTextLabel(nalivkin_name);
	return 1;
}

stock DestroyTrash()
{
			for(new o; o<sizeof(el_trash); o++)
			{
				if(IsValidObject(el_trash[o]))
		        {
		            DestroyObject(el_trash[o]);
		        }
			}
}


public OnPlayerEnterCheckpoint(playerid)
{
	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
	if(ispickitem[playerid] != -1)
	{
	    DisablePlayerCheckpoint ( playerid ) ;
	    GetPlayerName(playerid, el_attacher, MAX_PLAYER_NAME);
	    ElEndPick(playerid);
	    return 1;
	}
	return 1;
}


public OnObjectMoved(objectid)
{
	if(objectid == el_line[sizeof(el_line)-1])
	{
		StartMoveLine(-1);
	}
	return 1;
}


public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(e_pickup == pickupid)
	{
	    El_PickItem(playerid);
	    return 1;
	}
	if(pickupid == el_info)
	{
	    new str[512];
	    format(str, sizeof(str), "\
		{FFFFFF}Здравствуй дорогой друг!\n\
		До Нового года остаются считанные дни, а то и часы!\n\
		У горда Лос-Сантос в предверии Нового года случилась беда!\n\
		Мэрия в последний момент украла деньги из городского бюджета!\n\
		Городскую ёлку поставили, но денег на игрушки не хватило.\n\
		Что бы не оставлять город серым и мрачный председатель исполнительного\n\
		комитета города Уссурийска приехал исправить ситуацию!\n\
		Возле мэрии города он установил ларёк с игрушками привезёнными из самого города Уссурийск\n\
		%d игрушек необходимо перенести к ёлки, что бы мастера смогли их повесить.\n\
		{FF4444}Нажмите далее и вам покажут где находится ёлка.", sizeof(item_el) );
	    return ShowPlayerDialog(playerid, 20001, DIALOG_STYLE_MSGBOX, "{FFFF00}Информация", str, "Далее", "Закрыть");
	}
	return 1;
}

new el_boxes[200];
stock El_DropItem(playerid)
{
	if(ispickitem[playerid] != -1)
	{
        PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
	    if(ispickitem[playerid] != -1) el_boxes[ispickitem[playerid]] = CreateObject(1271, 1446.2910200,-1724.5820300,13.7150000, 0.0, 0.0, 0.0);
	    ispickitem[playerid] = -1;
	    DisablePlayerCheckpoint ( playerid ) ;
	    RemovePlayerAttachedObject(playerid,5);
	    SendClientMessage(playerid, 0xdeeb8aFF, " - Вы уронили коробку с игрушкой!");
		ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.0, 0,0,0,0,0);
		new Float: x, Float: y, Float: z;
		iseventstart = true;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerAttachedObject(playerid,1,18679,6,0.135011,0.463495,-4351,357.460632, 87.350753,88.068374,0.434164,0.491270,0.368);
		timer_DestroyObject = SetTimerEx("DestroyObject", 1000, false, "d", CreateObject(18679, x, y, z - 1.0, 0.0, 0.0, 0.0));
		return 1;
	}
	return 1;
}

stock ElEndPick(playerid)
{
    ispickitem[playerid] = -1;
    RemovePlayerAttachedObject( playerid,5);
    ApplyAnimation(playerid,"PED","IDLE_tired",4.1,0,1,1,0,1);
	StartMoveLine(playerid);
   	return 1;
}

stock El_PickItem(playerid)
{
	if(iseventstart)
	{
		for(new i = sizeof(el_boxes)-1; 0 <= i; i--)
		{
		    if(IsValidObject(el_boxes[i]))
			{
			    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			    DestroyObject(el_boxes[i]);
			    el_boxes[i] = 0;
			    ispickitem[playerid] = i;
			    iseventstart = false;
			    ApplyAnimation(playerid,"CARRY","crry_prtial",4.1,0,1,1,1,1);
			    SetPlayerAttachedObject(playerid,5,1271,1,0.135011,0.463495,-0.024351,357.460632, 87.350753,88.068374,0.834164,0.891270,0.868655);
		     	SetPlayerCheckpoint ( playerid, 1174.81702, -2049.04395 , 67.5 , 2.0 ) ;
				break;
			}
		}
	}
	return 1;
}

stock CreateBoxes()
{
	for(new i, x, y, z; i < sizeof(item_el); i++)
	{
	    if(y == 8)
	    {
	        y = 0;
	        x ++;
	    }
	    if(x == 5)
	    {
			z ++;
			x = 0;
	    }
	    el_boxes[i] = CreateObject(1271, 1452.2010500 - x * 0.65,-1712.69+y*0.65,13.3970000 +z * 0.65, 0.0, 0.0, 0.0);
	    y ++;
	}
	return 1;
}

forward EL_AddObject();
public EL_AddObject()
{
		for(new i = sizeof(el_boxes)-1; 0 <= i; i--)
		{
		    if(IsValidObject(el_boxes[i]))
			{
			    SendClientMessageToAll(0xff8800FF, " Новогодняя игрушка лежит на прилавке, скорее несите к новогодней ёлке!");
				SetObjectPos(el_boxes[i], 1446.2910200,-1724.5820300,13.7150000);
				iseventstart = true;
				break;
			}
		}
}

stock DestroyBoxes()
{
	for(new i; i<sizeof(item_el); i++)
	{
	    if(IsValidObject(el_boxes[i])) DestroyObject(el_boxes[i]);
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(ispickitem[playerid] != -1)
	{
		new anim = GetPlayerAnimationIndex(playerid);
		if(
		anim != 1189 &&
		anim != 1283 &&
		anim != 1279 &&
		anim != 1235 &&
		anim != 1195 &&
		anim != 1231 &&
		anim != 259 &&
		anim != 1266 &&
		anim != 1275 &&
		
		anim != 1226 &&
		anim != 1181 &&
		anim != 1261 &&
		
		anim != 1224 &&
		anim != 1257 &&
		
		anim != 1278 &&
		anim != 1282 &&
		
		anim != 1182 &&
		anim != 1230 &&
		anim != 1247 &&
		anim != 1265 &&
		
		anim != 1280 &&
		anim != 1285 &&
		
		anim != 1186 &&
		anim != 1228 &&
		anim != 1263 &&
		
		anim != 1456 &&
		anim != 1458 &&
		
		anim != 1284 &&
		anim != 1193 &&
		anim != 1264 &&
		anim != 1286 &&
		anim != 1276 &&
		anim != 1246 &&
		anim != 1269 &&
		anim != 1133)
		{
		    El_DropItem(playerid);
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("DIALOG: %d", dialogid);
	if(dialogid == 20002)
	{
	    TogglePlayerSpectating ( playerid, 0 ) ;
	    SetCameraBehindPlayer ( playerid ) ;
	    SetPlayerPos(playerid, 1441.6010,-1723.3846+3.0/random(10),13.5469);
	    return 1;
	}
	if(response)
	{
	  	if(dialogid == 20001)
		{
		    OnElFlyCam(playerid);
		    return 1;
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

stock DestroyCran()
{
	DestroyObject(el_cran_vert);
	DestroyObject(el_cran_gor);
	DestroyObject(el_coret);
	DestroyLine();
	print("Кран удалён!");
}
