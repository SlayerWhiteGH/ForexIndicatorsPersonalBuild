//+------------------------------------------------------------------+
//|                                                Drawing Tools.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

extern color RectLabelColor1 = C'0, 0, 0';
extern color RectLabelColor2 = C'255, 0, 0';
extern color RectLabelColor3 = C'0, 255, 0';
extern color RectLabelColor4 = C'0, 0, 255';
extern color RectLabelColor5 = C'100, 100, 100';
extern color RectLabelColor6 = C'30, 140, 210';
extern color RectLabelColor7 = C'50, 240, 220';
extern color RectLabelColor8 = C'100, 230, 120';
extern color RectLabelColor9 = C'20, 30, 200';
extern color RectLabelColor10 = C'210, 10, 0';
extern color RectLabelColor11 = C'240, 240, 0';
extern color RectLabelColor12 = C'255, 255, 255';

extern bool RectLabelIsVisible1 = true;
extern bool RectLabelIsVisible2 = true;
extern bool RectLabelIsVisible3 = true;
extern bool RectLabelIsVisible4 = true;
extern bool RectLabelIsVisible5 = true;
extern bool RectLabelIsVisible6 = true;
extern bool RectLabelIsVisible7 = true;
extern bool RectLabelIsVisible8 = true;
extern bool RectLabelIsVisible9 = true;
extern bool RectLabelIsVisible10 = true;
extern bool RectLabelIsVisible11 = true;
extern bool RectLabelIsVisible12 = true;

string buttonShowAll = "Button For Show All";

string rectLabelNames[] = {"Rectangle Label 1", "Rectangle Label 2", "Rectangle Label 3", "Rectangle Label 4", "Rectangle Label 5", "Rectangle Label 6", "Rectangle Label 7", "Rectangle Label 8", "Rectangle Label 9", "Rectangle Label 10", "Rectangle Label 11", "Rectangle Label 12"};
color rectLabelColors[12];
bool rectLabelShow[12];

string buttonsForRectLabelsNames[] = {
    "Rectangle Label 1-Visible/Invisible",
    "Rectangle Label 2-Visible/Invisible",
    "Rectangle Label 3-Visible/Invisible",
    "Rectangle Label 4-Visible/Invisible",
    "Rectangle Label 5-Visible/Invisible",
    "Rectangle Label 6-Visible/Invisible",
    "Rectangle Label 7-Visible/Invisible",
    "Rectangle Label 8-Visible/Invisible",
    "Rectangle Label 9-Visible/Invisible",
    "Rectangle Label 10-Visible/Invisible",
    "Rectangle Label 11-Visible/Invisible",
    "Rectangle Label 12-Visible/Invisible"
};

int rect_label_x_coor;
int rect_label_y_coor = 30;
int rect_label_margin = 10;
int rect_label_width = 20;
int rect_label_height = 20;
int button_width = 50;
int button_height = 20;
int button_font_size = 10;
string button_font = "Arial";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
    rectLabelColors[0] = RectLabelColor1;
    rectLabelColors[1] = RectLabelColor2;
    rectLabelColors[2] = RectLabelColor3;
    rectLabelColors[3] = RectLabelColor4;
    rectLabelColors[4] = RectLabelColor5;
    rectLabelColors[5] = RectLabelColor6;
    rectLabelColors[6] = RectLabelColor7;
    rectLabelColors[7] = RectLabelColor8;
    rectLabelColors[8] = RectLabelColor9;
    rectLabelColors[9] = RectLabelColor10;
    rectLabelColors[10] = RectLabelColor11;
    rectLabelColors[11] = RectLabelColor12;

    ButtonCreate(0, buttonShowAll, 0, 0, 20, button_width + 10, button_height, CORNER_LEFT_UPPER, "Show All", clrBlack, clrPowderBlue);

    createRectLabels();
//---
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
    Comment("");

    for (int i = 0; i < ArraySize(rectLabelNames); i++) {
        deleteObject(rectLabelNames[i]);
        deleteObject(buttonsForRectLabelsNames[i]);
    }

    deleteObject(buttonShowAll);

}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
//---
    if (id == CHARTEVENT_OBJECT_CLICK) {
        for (int i = 0; i < ArraySize(rectLabelNames); i++) {
            if (sparam == rectLabelNames[i]) {
                
            }

            if (sparam == buttonsForRectLabelsNames[i]) {
                if (i == 0) {
                    if (RectLabelIsVisible1) {
                        deleteRectLabel(i);
                        RectLabelIsVisible1 = false;  
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible1 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 1) {
                    if (RectLabelIsVisible2) {
                        deleteRectLabel(i);
                        RectLabelIsVisible2 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible2 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 2) {
                    if (RectLabelIsVisible3) {
                        deleteRectLabel(i);
                        RectLabelIsVisible3 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible3 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 3) {
                    if (RectLabelIsVisible4) {
                        deleteRectLabel(i);
                        RectLabelIsVisible4 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible4 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 4) {
                    if (RectLabelIsVisible5) {
                        deleteRectLabel(i);
                        RectLabelIsVisible5 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible5 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 5) {
                    if (RectLabelIsVisible6) {
                        deleteRectLabel(i);
                        RectLabelIsVisible6 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible6 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 6) {
                    if (RectLabelIsVisible7) {
                        deleteRectLabel(i);
                        RectLabelIsVisible7 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible7 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 7) {
                    if (RectLabelIsVisible8) {
                        deleteRectLabel(i);
                        RectLabelIsVisible8 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible8 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 8) {
                    if (RectLabelIsVisible9) {
                        deleteRectLabel(i);
                        RectLabelIsVisible9 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible9 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 9) {
                    if (RectLabelIsVisible10) {
                        deleteRectLabel(i);
                        RectLabelIsVisible10 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible10 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 10) {
                    if (RectLabelIsVisible11) {
                        deleteRectLabel(i);
                        RectLabelIsVisible11 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible11 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
                if (i == 11) {
                    if (RectLabelIsVisible12) {
                        deleteRectLabel(i);
                        RectLabelIsVisible12 = false;
                        changeText(buttonsForRectLabelsNames[i], "Show");
                        changeRectLabelPositions();
                    }
                    else {
                        createRectLabel(i);
                        RectLabelIsVisible12 = true;
                        changeText(buttonsForRectLabelsNames[i], "Hide");
                        changeRectLabelPositions();
                    }
                }
            }
        }

        if (sparam == buttonShowAll) {
            if (findObject(buttonsForRectLabelsNames[0])) {
                deleteButtonsForRectLabels();
            }
            else {
                createButtonsForRectLabels();
            }
        }


    }

    if (id == CHARTEVENT_CHART_CHANGE) {
        for (int i = 0; i < ArraySize(rectLabelNames); i++) {
            setRectLabelXCoor(i);
            changeRectLabelPosition(i);
        }
    }
}
//+------------------------------------------------------------------+

int getFirstRectLabelXCoor() {
    int visible = 0;
    if (RectLabelIsVisible1) visible++;
    if (RectLabelIsVisible2) visible++;
    if (RectLabelIsVisible3) visible++;
    if (RectLabelIsVisible4) visible++;
    if (RectLabelIsVisible5) visible++;
    if (RectLabelIsVisible6) visible++;
    if (RectLabelIsVisible7) visible++;
    if (RectLabelIsVisible8) visible++;
    if (RectLabelIsVisible9) visible++;
    if (RectLabelIsVisible10) visible++;
    if (RectLabelIsVisible11) visible++;
    if (RectLabelIsVisible12) visible++;

    int chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
    int middleChart = chartWidth / 2;
    int rectLabelsWidth = (visible * (rect_label_width + rect_label_margin)) - rect_label_margin;

    return middleChart - (rectLabelsWidth / 2);
}

void createRectLabels() {
    ResetLastError();

    for (int i = 0; i < ArraySize(rectLabelNames); i++) {
        if (ObjectFind(0, rectLabelNames[i]) == -1) {
            setRectLabelXCoor(i);
            createRectLabel(i);
        }
    }
}

void createRectLabel(int i) {
    ResetLastError();

    RectLabelCreate(rectLabelNames[i], rect_label_x_coor, rect_label_y_coor, rect_label_width, rect_label_height, CORNER_LEFT_LOWER, STYLE_SOLID, rectLabelColors[i]);
}

void changeRectLabelPositions() {
    int counter = 0;
    for (int j = 0; j < ArraySize(rectLabelNames); j++) {
        if (findObject(rectLabelNames[j])) {
            setRectLabelXCoor(counter);
            changeRectLabelPosition(j);
            counter++;
        }
    }
}

void changeRectLabelPosition(int i) {
    ObjectSetInteger(0, rectLabelNames[i], OBJPROP_XDISTANCE, rect_label_x_coor);
}

void setRectLabelXCoor(int i) {
    rect_label_x_coor = (i == 0) ? getFirstRectLabelXCoor() : getFirstRectLabelXCoor() + (i * (rect_label_width + rect_label_margin));
}

void deleteRectLabel(int i) {
    ResetLastError();

    deleteObject(rectLabelNames[i]);
}

void createButtonsForRectLabels() {
    ResetLastError();

    string text;
    for (int i = 0; i < ArraySize(buttonsForRectLabelsNames); i++) {
        if (i == 0) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 1) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 2) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 3) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 4) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 5) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 6) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 7) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 8) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 9) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 10) text = RectLabelIsVisible1 ? "Hide" : "Show";
        if (i == 11) text = RectLabelIsVisible1 ? "Hide" : "Show";

        ButtonCreate(0, buttonsForRectLabelsNames[i], 0, ObjectGet(buttonShowAll, OBJPROP_XDISTANCE) + ObjectGet(buttonShowAll, OBJPROP_XSIZE) + 10, ObjectGet(buttonShowAll, OBJPROP_YDISTANCE)*(i+1), button_width, button_height, CORNER_LEFT_UPPER, text);
    }
}

void deleteButtonsForRectLabels() {
    ResetLastError();

    for (int i = 0; i < ArraySize(buttonsForRectLabelsNames); i++) {
        deleteObject(buttonsForRectLabelsNames[i]);
    }
}

void changeText(string name, string text) {
    ResetLastError();

    if (findObject(name)) {
        ObjectSetString(0, name, OBJPROP_TEXT, text);
    }
}

bool RectLabelCreate(const string           name="RectLabel",        
                     const int              x=0,                      
                     const int              y=0,                      
                     const int              width=50,                 
                     const int              height=18,                
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_LOWER, 
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,    
                     const color            back_clr=C'236,233,216',   
                     const color            clr=clrRed)               
{
   //--- 
   ResetLastError();
   //--- 
   if (ObjectFind(name) == -1)
      ObjectCreate(0, name, OBJ_RECTANGLE_LABEL,0,0,0);

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);                 // param
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);                 // param
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);                 // param
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);                // param
   ObjectSetInteger(0, name, OBJPROP_CORNER, corner);               // param
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);                 // param   
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, back_clr);            // param
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);                   // param
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_SUNKEN);      
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);         
   ObjectSetInteger(0, name, OBJPROP_BACK, false);                
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);            
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0);    
   
   return(true);
}
//+------------------------------------------------------------------+
//|                                       |
//+------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID=0,        // ID ãðàôèêà
                     const string          name="Rectangle",  // èìÿ ïðÿìîóãîëüíèêà
                     const int             sub_window=0,      // íîìåð ïîäîêíà 
                     datetime              time1=0,           // âðåìÿ ïåðâîé òî÷êè
                     double                price1=0,          // öåíà ïåðâîé òî÷êè
                     datetime              time2=0,           // âðåìÿ âòîðîé òî÷êè
                     double                price2=0,          // öåíà âòîðîé òî÷êè
                     const color           clr=clrRed,        // öâåò ïðÿìîóãîëüíèêà
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // ñòèëü ëèíèé ïðÿìîóãîëüíèêà
                     const int             width=1,           // òîëùèíà ëèíèé ïðÿìîóãîëüíèêà
                     const bool            fill=false,        // çàëèâêà ïðÿìîóãîëüíèêà öâåòîì
                     const bool            back=false,        // íà çàäíåì ïëàíå
                     const bool            selection=true,    // âûäåëèòü äëÿ ïåðåìåùåíèé
                     const bool            hidden=true,       // ñêðûò â ñïèñêå îáúåêòîâ
                     const long            z_order=0)         // ïðèîðèòåò íà íàæàòèå ìûøüþ
{
   //--- ñáðîñèì çíà÷åíèå îøèáêè
   ResetLastError();
   //--- ñîçäàäèì ïðÿìîóãîëüíèê ïî çàäàííûì êîîðäèíàòàì
   if (ObjectFind(name) == -1)
      ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2);
      ObjectSetText(name, "Rectangle",10);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);             //--- óñòàíîâèì öâåò ïðÿìîóãîëüíèêà
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);           //--- óñòàíîâèì ñòèëü ëèíèé ïðÿìîóãîëüíèêà
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);           //--- óñòàíîâèì òîëùèíó ëèíèé ïðÿìîóãîëüíèêà
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);             //--- âêëþ÷èì (true) èëè îòêëþ÷èì (false) ðåæèì çàëèâêè ïðÿìîóãîëüíèêà
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);             //--- îòîáðàçèì íà ïåðåäíåì (false) èëè çàäíåì (true) ïëàíå 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);  //--- âêëþ÷èì (true) èëè îòêëþ÷èì (false) ðåæèì âûäåëåíèÿ ïðÿìîóãîëüíèêà äëÿ ïåðåìåùåíèé
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);    //--- ïðè ñîçäàíèè ãðàôè÷åñêîãî îáúåêòà ôóíêöèåé ObjectCreate, ïî óìîë÷àíèþ îáúåêò
                                                                  //--- íåëüçÿ âûäåëèòü è ïåðåìåùàòü. Âíóòðè æå ýòîãî ìåòîäà ïàðàìåòð selection
                                                                  //--- ïî óìîë÷àíèþ ðàâåí true, ÷òî ïîçâîëÿåò âûäåëÿòü è ïåðåìåùàòü ýòîò îáúåêò
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);         //--- ñêðîåì (true) èëè îòîáðàçèì (false) èìÿ ãðàôè÷åñêîãî îáúåêòà â ñïèñêå îáúåêòîâ
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);        //--- óñòàíîâèì ïðèîðèòåò íà ïîëó÷åíèå ñîáûòèÿ íàæàòèÿ ìûøè íà ãðàôèêå

   return(true);
}


bool deleteObject(const string name="Rectangle") 
{
   //--- ñáðîñèì çíà÷åíèå îøèáêè
   ResetLastError();
   //--- óäàëèì ïðÿìîóãîëüíèê
   if (ObjectFind(0, name) >= 0) 
      ObjectDelete(0, name);

   return(true);
}

bool findObject(string name) {
    ResetLastError();

    return ObjectFind(name) >= 0;
}

//+------------------------------------------------------------------+ 
//| Create the button                                                | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // chart's ID 
                  const string            name="Button",            // button name 
                  const int               sub_window=0,             // subwindow index 
                  const int               x=0,                      // X coordinate 
                  const int               y=0,                      // Y coordinate 
                  const int               width=50,                 // button width 
                  const int               height=18,                // button height 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                  const string            text="Button",            // text 
                  const color             clr=clrBlack,             // text color 
                  const color             back_clr=C'236,233,216')  // background color 
{ 
//--- reset the error value 
   ResetLastError(); 
//--- create the button 
    if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0)) { 
        Print(__FUNCTION__, 
                ": failed to create the button! Error code = ",GetLastError()); 
        return(false); 
    } 
//--- set button coordinates 
    ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); // param
    ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); // param
//--- set button size 
    ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); // param
    ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); // param
//--- set the chart's corner, relative to which point coordinates are defined 
    ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); // param
//--- set the text 
    ObjectSetString(chart_ID,name,OBJPROP_TEXT, text); // param
//--- set text font 
    ObjectSetString(chart_ID,name,OBJPROP_FONT, button_font); 
//--- set font size 
    ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE, button_font_size); 
//--- set text color 
    ObjectSetInteger(chart_ID,name,OBJPROP_COLOR, clr); // param
//--- set background color 
    ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR, back_clr);  // param
//--- set border color 
    ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR, clrBlack); 
//--- display in the foreground (false) or background (true) 
    ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false); 
//--- set button state 
    ObjectSetInteger(chart_ID,name,OBJPROP_STATE,false); 
//--- enable (true) or disable (false) the mode of moving the button by mouse 
    ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false); 
    ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false); 
//--- hide (true) or display (false) graphical object name in the object list 
    ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true); 
//--- set the priority for receiving the event of a mouse click in the chart 
    ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0); 
//--- successful execution 
    return(true); 
} 