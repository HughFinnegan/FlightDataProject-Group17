final int NUMBER_OF_DATAPOINTS = 18;
final int LENGTH_OF_DATA = 16;
final int SCREENX = 1600;
final int SCREENY = 1000;
final int START_MAP_WIDTH = 500;
final int ON_TOP = 1;
final int ON_SIDE = 2;
final int ON_BOTTOM = 3;
final int AIRPORT_RADIUS = 5;
final int NO_EVENT = -1;
final int BAR_CHART_Y_AXIS_LENGTH = 800;
final int BAR_CHART_X_AXIS_LENGTH = 1400;
final int CHART_BUFFER = 100;
final int MAX_Y_VALUES = 20;
final int TOP_TEXT_BUFFER = 50;
final int US_X_START = 150;
final int ALASKA_X_START = 900;
final int HAWAII_X_START = 550;
final int TOP_ROW_Y_START = 250;
final int HAWAII_Y_START = 520;
final int CURRENT = 0;
final int START = 1;
final int CHANGED= 2; 
final int CHART_BUTTON_SIZE = 200;
final int DEP_X = 1200;
final int DEP_Y = 100;
final int ARR_X = DEP_X;
final int ARR_Y = DEP_Y + CHART_BUTTON_SIZE + 50;
final int PIE_X = DEP_X;
final int PIE_Y = ARR_Y + CHART_BUTTON_SIZE + 60;
final int TOP_LEFT = 0;
final int TOP_MID = 1;
final int TOP_RIGHT = 2;
final int MID_LEFT = 3;
final int MID_MID = 4;
final int MID_RIGHT = 5;
final int BOT_LEFT = 6;
final int BOT_MID = 7;
final int BOT_RIGHT = 8;
final int WHITE = 255;
final int BLACK = 0;
final int INCOMING = 0;
final int OUTGOING = 1;
final color WIDGET_COLOUR = #2FBEE8;
final color AIRPORT_COLOUR = #127A98;
final int FILTER_WIDGET_WIDTH = 100;
final int FILTER_WIDGET_HEIGHT = 40;
final int FILTER_WIDGET_X = 1450;
//datapoints
final int FLIGHT_DATE_NO = 0;
final int MKT_CARRIER_NO = 1;
final int MKT_CARRIER_FL_NUM_NO = 2;
final int ORIGIN_NO = 3;
final int ORIGIN_CITY_NAME_NO = 4;
final int ORIGIN_STATE_ABR_NO = 6;
final int ORIGIN_WAC_NO = 7;
final int DEST_NO = 8;
final int DEST_CITY_NAME_NO = 9;
final int DEST_STATE_ABR_NO = 10;
final int DEST_WAC_NO = 12;
final int CRS_DEP_TIME_NO = 13;
final int DEP_TIME_NO = 14;
final int CRS_ARR_TIME_NO = 15;
final int ARR_TIME_NO = 16;
final int CANCELLED_NO = 17;
final int DIVERTED_NO = 18;
final int DISTANCE_NO = 19;
//screens
final int MAP_SCREEN = 0;
final int TOP_LEFT_SCREEN = 1;
final int TOP_MID_SCREEN = 2;
final int TOP_RIGHT_SCREEN = 3;
final int MID_LEFT_SCREEN = 4;
final int MID_MID_SCREEN = 5;
final int MID_RIGHT_SCREEN = 6;
final int BOT_LEFT_SCREEN = 7;
final int BOT_MID_SCREEN = 8;
final int BOT_RIGHT_SCREEN = 9;
final int BAR_CHART_SCREEN = 10;
final int START_SCREEN = 11;
final int CHART_SELECT_SCREEN = 12;
final int ALASKA_SCREEN = 13;
final int HAWAII_SCREEN = 14;
final int PIE_CHART_SCREEN = 15;
//filters
final int AK_FILTER = 1;
final int LS_FILTER = 2;
final int TZ_FILTER = 3;
final int NO_FILTER = 4;
//carrier
final String AA = "American Airlines";
final String AS = "Alaska Airlines";
final String B6 = "JetBlue";
final String DL = "Delta Airlines";
final String F9 = "Frontier Airlines";
final String G4 = "Allegiant Air";
final String HA = "Hawaiian Airlines";
final String NK = "Spirit Airlines";
final String UA = "United Airlines";
final String WN = "Southwest Airlines";
//events
final int BACK_BUTTON_EVENT = 0;
final int AK_EVENT = 1;
final int LS_EVENT = 2;
final int TZ_EVENT = 3;
final int NO_FILTER_EVENT = 4;
final int TOP_LEFT_EVENT = 5;
final int TOP_MID_EVENT = 6;
final int TOP_RIGHT_EVENT = 7;
final int MID_LEFT_EVENT = 8;
final int MID_MID_EVENT = 9;
final int MID_RIGHT_EVENT = 10;
final int BOT_LEFT_EVENT = 11;
final int BOT_MID_EVENT = 12;
final int BOT_RIGHT_EVENT = 13;
final int SELECT_US_EVENT = 14;
final int BACK_TO_START_EVENT = 15;
final int OUTGOING_BAR_CHART_EVENT = 16;
final int INCOMING_BAR_CHART_EVENT = 17;
final int SELECT_ALASKA_EVENT = 18;
final int SELECT_HAWAII_EVENT = 19;
final int BACK_SELECTION_EVENT = 20;
final int PIE_CHART_EVENT = 21;
final int CHART_SELECTION_EVENT = 22; //has to be last
//regions
final int US_REGION = 0;
final int ALASKA_REGION = 1;
final int HAWAII_REGION = 2;
