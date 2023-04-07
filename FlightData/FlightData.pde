import java.util.Scanner;
import java.io.File;
import java.util.ArrayList;
import de.bezier.data.sql.*;
import controlP5.*;

PostgreSQL pgsql;
ControlP5 cp5;
PFont myFont;
ArrayList<String> airportNames = new ArrayList<String>();
ArrayList<Airport> myAirports = new ArrayList<Airport>();
ArrayList<Screen> zoomScreens = new ArrayList<Screen>();
PImage mapImage, alaskaMapImage, hawaiiMapImage;
PImage[] US, Alaska, Hawaii, Departures, Arrivals, Airlines, CancelledAndDiverted;
Screen mapScreen, currentScreen, topLeft, topMid, topRight, midLeft, midMid, midRight, botLeft, botMid, botRight, startScreen, chartSelectionScreen, alaskaScreen, hawaiiScreen, regionScreen;
Screen pieChartScreenArrDep, pieChartScreenCanDiv, outgoingChartScreen, incomingChartScreen, searchScreen;
BarChart chart;
int event, lastAirportSelected, previousEvent, previousEventScreen;
Filter mapFilter;
Widget backToMapButton, AKButton, LSButton, TZButton, allButton, USMapButton, backToStartButton, outgoingBarChartButton, incomingBarChartButton, alaskaMapButton, hawaiiMapButton, backToSelectionButton;
Widget backToAlaskaMapButton, backToHawaiiMapButton, pieChartButtonArrDep, pieChartButtonCanDiv, searchScreenButton, nextFlightButton, previousFlightButton, searchByNumberButton, searchByOriginButton;
Widget searchByDateButton;
Search searchBar;
boolean drawingGraph;
BarChart outgoingFlightsChart, incomingFlightsChart;
PieChart airlinesChart, flightsChart;
String mostCommonAirline, highestOutgoingName, highestIncomingName, cityName, airportName;

void settings() 
{
  size(SCREENX, SCREENY);
}

void setup() 
{
  String user     = "postgres";
  String pass     = "group17";
  String database = "AirlineData";
  pgsql = new PostgreSQL( this, "localhost", database, user, pass );
  if ( pgsql.connect() )
  {
    pgsql.query( "SELECT COUNT(*) FROM airlinedata" );
    if ( pgsql.next() )
    {
      println( "number of rows in table airlineData: " + pgsql.getInt(1) );
    }
  }
  cp5 = new ControlP5(this);
  background(WHITE);
  textAlign(CENTER);
  cityName = "error";
  airportName = "error";
  setScreens();
  searchBar = new Search();
  mapFilter = new Filter();
  mapFilter.addAirports(myAirports);
  System.out.println(airportNames);
  System.out.println(airportNames.size());
  ellipseMode(RADIUS);
  addAirportsToMaps();
  addDataToAirports();
  addWidgets();
  drawingGraph = false;
  allButton.setColour();
  searchByNumberButton.setColour();
}


void draw()
{
  background(WHITE);
  currentScreen.draw(event, mapFilter);
}

void mousePressed()
{
  event = currentScreen.buttonClicked();
  int eventNo = event;
  if (event >= CHART_SELECTION_EVENT && event < myAirports.size() + CHART_SELECTION_EVENT)
  {
    eventNo = CHART_SELECTION_EVENT;
  }
  switch(eventNo)
  {
  case BACK_BUTTON_EVENT:
    currentScreen = regionScreen;
    break;

  case AK_EVENT:
    mapFilter.currentFilter = AK_FILTER;
    AKButton.setColour();
    LSButton.unsetColour();
    TZButton.unsetColour();
    allButton.unsetColour();
    break;

  case LS_EVENT:
    mapFilter.currentFilter = LS_FILTER;
    AKButton.unsetColour();
    LSButton.setColour();
    TZButton.unsetColour();
    allButton.unsetColour();
    break;

  case TZ_EVENT:
    mapFilter.currentFilter = TZ_FILTER;
    AKButton.unsetColour();
    LSButton.unsetColour();
    TZButton.setColour();
    allButton.unsetColour();
    break;

  case NO_FILTER_EVENT:
    mapFilter.currentFilter = NO_FILTER;
    AKButton.unsetColour();
    LSButton.unsetColour();
    TZButton.unsetColour();
    allButton.setColour();
    break;

  case TOP_LEFT_EVENT:
  case TOP_MID_EVENT:
  case TOP_RIGHT_EVENT:
  case MID_LEFT_EVENT:
  case MID_MID_EVENT:
  case MID_RIGHT_EVENT:
  case BOT_LEFT_EVENT:
  case BOT_MID_EVENT:
  case BOT_RIGHT_EVENT:
    currentScreen = zoomScreens.get(event - TOP_LEFT_EVENT);
    break;

  case SELECT_US_EVENT:
    currentScreen = mapScreen;
    regionScreen = currentScreen;
    break;

  case BACK_TO_START_EVENT:
    currentScreen = startScreen;
    break;

  case OUTGOING_BAR_CHART_EVENT:
    event = lastAirportSelected;
    currentScreen = outgoingChartScreen;
    break;

  case INCOMING_BAR_CHART_EVENT:
    event = lastAirportSelected;
    currentScreen = incomingChartScreen;
    break;

  case SELECT_ALASKA_EVENT:
    currentScreen = alaskaScreen;
    regionScreen = currentScreen;
    break;

  case SELECT_HAWAII_EVENT:
    currentScreen = hawaiiScreen;
    regionScreen = currentScreen;
    break;

  case BACK_SELECTION_EVENT:
    currentScreen = chartSelectionScreen;
    break;

 case PIE_CHART_EVENT_ARR_DEP:
    currentScreen = pieChartScreenArrDep;
    break;

  case PIE_CHART_EVENT_CANC_DIV:
    currentScreen = pieChartScreenCanDiv;
    break;

  case SELECT_SEARCH_EVENT:
    currentScreen = searchScreen;
    break;

  case NEXT_FLIGHT_EVENT:
    searchBar.nextAirport();
    break;

  case PREVIOUS_FLIGHT_EVENT:
    searchBar.previousAirport();
    break;

  case SEARCH_BY_FL_NO_EVENT:
    searchBar.setQuery(FL_NO_SEARCH);
    searchByNumberButton.setColour();
    searchByOriginButton.unsetColour();
    searchByDateButton.unsetColour();
    break;

  case SEARCH_BY_ORIGIN_EVENT:
    searchBar.setQuery(ORIGIN_SEARCH);
    searchByNumberButton.unsetColour();
    searchByOriginButton.setColour();
    searchByDateButton.unsetColour();
    break;
    
  case SEARCH_BY_DATE_EVENT:
    searchBar.setQuery(DATE_SEARCH);
    searchByNumberButton.unsetColour();
    searchByOriginButton.unsetColour();
    searchByDateButton.setColour();
    break;

  case CHART_SELECTION_EVENT:
    currentScreen = chartSelectionScreen;
    Airport currentAirport = myAirports.get(event - CHART_SELECTION_EVENT);
    String airportName = currentAirport.getAirportName();
    chartSelectionScreen.setOutgoingFlights(calculateFlights(airportName, OUTGOING));
    chartSelectionScreen.setIncomingFlights(calculateFlights(airportName, INCOMING));
    lastAirportSelected = event;
    break;
  }
}

void keyPressed()
{
  searchBar.searchTyping();
}

int calculateFlights(String airportName, int direction)
{
  String queryStr;
  if (direction == INCOMING) queryStr = "DEST";
  else queryStr = "ORIGIN";
  int total = 0;
  pgsql.query( "SELECT COUNT(*) FROM airlinedata WHERE " + queryStr + " = '" + airportName + "'");
  if ( pgsql.next() )
  {
    total = pgsql.getInt(1);
  }
  return total;
}

void mouseMoved()
{
  if (currentScreen != mapScreen)
  {
    for (Airport currentAirport : myAirports)
    {
      currentAirport.strokeAirport();
    }
  }
  backToMapButton.hover();
  AKButton.hover();
  LSButton.hover();
  TZButton.hover();
  allButton.hover();
  backToStartButton.hover();
  backToSelectionButton.hover();
  outgoingBarChartButton.hover();
  incomingBarChartButton.hover();
  searchScreenButton.hover();
  pieChartButtonArrDep.hover();
  pieChartButtonCanDiv.hover();
  currentScreen.hover();
  nextFlightButton.hover();
  previousFlightButton.hover();
  searchByNumberButton.hover();
  searchByOriginButton.hover();
  searchByDateButton.hover();
}

void addAirportsToMaps()
{
  for (Airport currentAirport : myAirports)
  {
    switch(currentAirport.getRegion())
    {
    case US_REGION:
      mapScreen.addAirport(currentAirport);
      topLeft.addAirport(currentAirport);
      topMid.addAirport(currentAirport);
      topRight.addAirport(currentAirport);
      midLeft.addAirport(currentAirport);
      midMid.addAirport(currentAirport);
      midRight.addAirport(currentAirport);
      botLeft.addAirport(currentAirport);
      botMid.addAirport(currentAirport);
      botRight.addAirport(currentAirport);
      break;

    case ALASKA_REGION:
      alaskaScreen.addAirport(currentAirport);
      break;

    case HAWAII_REGION:
      hawaiiScreen.addAirport(currentAirport);
      break;
    }
  }
}

void addDataToAirports()
{
  int i = 0;
  for (Airport currentAirport : myAirports)
  {
    currentAirport.setID(i);
    i++;
  }
}

void setScreens()
{
  alaskaScreen = new Screen(ALASKA_SCREEN);
  hawaiiScreen = new Screen(HAWAII_SCREEN);
  mapScreen = new Screen(MAP_SCREEN);
  outgoingChartScreen = new Screen(OUTGOING_BAR_CHART_SCREEN);
  incomingChartScreen = new Screen(INCOMING_BAR_CHART_SCREEN);
  topLeft = new Screen(TOP_LEFT_SCREEN);
  topMid = new Screen(TOP_MID_SCREEN);
  topRight = new Screen(TOP_RIGHT_SCREEN);
  midLeft = new Screen(MID_LEFT_SCREEN);
  midMid = new Screen(MID_MID_SCREEN);
  midRight = new Screen(MID_RIGHT_SCREEN);
  botLeft = new Screen(BOT_LEFT_SCREEN);
  botMid = new Screen(BOT_MID_SCREEN);
  botRight = new Screen(BOT_RIGHT_SCREEN);
  startScreen = new Screen(START_SCREEN);
  chartSelectionScreen = new Screen(CHART_SELECT_SCREEN);
  pieChartScreenArrDep = new Screen(PIE_CHART_SCREEN_ARR_DEP);
  pieChartScreenCanDiv = new Screen(PIE_CHART_SCREEN_CANC_DIV);
  searchScreen = new Screen(SEARCH_SCREEN);
  currentScreen = startScreen;
  zoomScreens.add(topLeft);
  zoomScreens.add(topMid);
  zoomScreens.add(topRight);
  zoomScreens.add(midLeft);
  zoomScreens.add(midMid);
  zoomScreens.add(midRight);
  zoomScreens.add(botLeft);
  zoomScreens.add(botMid);
  zoomScreens.add(botRight);
}


void addWidgets()
{
  alaskaMapButton = new Widget(ALASKA_X_START, TOP_ROW_Y_START, START_MAP_WIDTH, 300, SELECT_ALASKA_EVENT);
  hawaiiMapButton = new Widget(HAWAII_X_START, HAWAII_Y_START, START_MAP_WIDTH, 300, SELECT_HAWAII_EVENT);
  backToSelectionButton = new Widget(20, 20, (int) textWidth("Back") + 100, 40, "Back", color(WIDGET_COLOUR), myFont, BACK_SELECTION_EVENT, WHITE);
  backToMapButton = new Widget(20, 20, (int) textWidth("Back") + 100, 40, "Back", color(WIDGET_COLOUR), myFont, BACK_BUTTON_EVENT, WHITE);
  backToStartButton = new Widget(20, 20, (int) textWidth("Back") + 100, 40, "Back", color(WIDGET_COLOUR), myFont, BACK_TO_START_EVENT, WHITE);
  outgoingBarChartButton = new Widget(DEP_X, DEP_Y, CHART_BUTTON_SIZE, CHART_BUTTON_SIZE, OUTGOING_BAR_CHART_EVENT);
  incomingBarChartButton = new Widget(ARR_X, ARR_Y, CHART_BUTTON_SIZE, CHART_BUTTON_SIZE, INCOMING_BAR_CHART_EVENT);
  pieChartButtonArrDep = new Widget(PIE_X, PIE_Y, CHART_BUTTON_SIZE, CHART_BUTTON_SIZE, PIE_CHART_EVENT_ARR_DEP);
  pieChartButtonCanDiv = new Widget(PIE_2_X, PIE_2_Y, CHART_BUTTON_SIZE, CHART_BUTTON_SIZE, PIE_CHART_EVENT_CANC_DIV);
  USMapButton = new Widget(150, 250, START_MAP_WIDTH, 300, SELECT_US_EVENT);
  AKButton = new Widget(FILTER_WIDGET_X, 745, FILTER_WIDGET_WIDTH, FILTER_WIDGET_HEIGHT, "A - K", color(WIDGET_COLOUR), myFont, AK_EVENT, WHITE);
  LSButton = new Widget(FILTER_WIDGET_X, 790, FILTER_WIDGET_WIDTH, FILTER_WIDGET_HEIGHT, "L - S ", color(WIDGET_COLOUR), myFont, LS_EVENT, WHITE);
  TZButton = new Widget(FILTER_WIDGET_X, 835, FILTER_WIDGET_WIDTH, FILTER_WIDGET_HEIGHT, "T - Z", color(WIDGET_COLOUR), myFont, TZ_EVENT, WHITE);
  allButton = new Widget(FILTER_WIDGET_X, 700, FILTER_WIDGET_WIDTH, FILTER_WIDGET_HEIGHT, "ALL", color(WIDGET_COLOUR), myFont, NO_FILTER_EVENT, WHITE);
  searchScreenButton = new Widget(1400, 98, FILTER_WIDGET_WIDTH+30, FILTER_WIDGET_HEIGHT, "Search", color(WHITE), myFont, SELECT_SEARCH_EVENT, BLACK);
  nextFlightButton = new Widget(1200, 745, FILTER_WIDGET_WIDTH + 50, FILTER_WIDGET_HEIGHT, "Next Flight", color(WIDGET_COLOUR), myFont, NEXT_FLIGHT_EVENT, WHITE);
  previousFlightButton = new Widget(1200, 790, FILTER_WIDGET_WIDTH + 50, FILTER_WIDGET_HEIGHT, "Previous Flight", color(WIDGET_COLOUR), myFont, PREVIOUS_FLIGHT_EVENT, WHITE);
  searchByNumberButton = new Widget(1200, 100, FILTER_WIDGET_WIDTH + 200, FILTER_WIDGET_HEIGHT, "Search by flight number", color(WIDGET_COLOUR), myFont, SEARCH_BY_FL_NO_EVENT, WHITE);
  searchByOriginButton = new Widget(1200, 200, FILTER_WIDGET_WIDTH + 200, FILTER_WIDGET_HEIGHT, "Search by origin", color(WIDGET_COLOUR), myFont, SEARCH_BY_ORIGIN_EVENT, WHITE);
  searchByDateButton = new Widget(1200, 300, FILTER_WIDGET_WIDTH + 200, FILTER_WIDGET_HEIGHT, "Search by date", color(WIDGET_COLOUR), myFont, SEARCH_BY_DATE_EVENT, WHITE);
  searchScreen.addWidget(nextFlightButton);
  searchScreen.addWidget(previousFlightButton);
  searchScreen.addWidget(searchByNumberButton);
  searchScreen.addWidget(searchByOriginButton);
  searchScreen.addWidget(searchByDateButton);
  outgoingChartScreen.addWidget(backToSelectionButton);
  incomingChartScreen.addWidget(backToSelectionButton);
  pieChartScreenArrDep.addWidget(backToSelectionButton);
  pieChartScreenCanDiv.addWidget(backToSelectionButton);
  chartSelectionScreen.addWidget(backToMapButton);
  chartSelectionScreen.addWidget(outgoingBarChartButton);
  chartSelectionScreen.addWidget(incomingBarChartButton);
  chartSelectionScreen.addWidget(pieChartButtonArrDep);
  chartSelectionScreen.addWidget(pieChartButtonCanDiv);
  startScreen.addWidget(USMapButton);
  startScreen.addWidget(alaskaMapButton);
  startScreen.addWidget(hawaiiMapButton);
  startScreen.addWidget(searchScreenButton);
  mapScreen.addWidget(backToStartButton);
  alaskaScreen.addWidget(backToStartButton);
  hawaiiScreen.addWidget(backToStartButton);
  for (Screen currentZoom : zoomScreens)
  {
    currentZoom.addWidget(backToMapButton);
    currentZoom.addWidget(AKButton);
    currentZoom.addWidget(LSButton);
    currentZoom.addWidget(TZButton);
    currentZoom.addWidget(allButton);
  }
  mapScreen.addWidget(AKButton);
  mapScreen.addWidget(LSButton);
  mapScreen.addWidget(TZButton);
  mapScreen.addWidget(allButton);
}
