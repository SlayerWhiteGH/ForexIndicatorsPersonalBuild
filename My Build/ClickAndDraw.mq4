//+------------------------------------------------------------------+
//|                                              mn ClickAndDraw.mq4 |
//+------------------------------------------------------------------+
#property copyright "WHITE"
#property strict
#property indicator_chart_window

enum KEYS_ON_KEYBOARD {
  _A/*A*/,  _B/*B*/,  _C/*C*/,  _D/*D*/,  _E/*E*/,
  _F/*F*/,  _G/*G*/,  _H/*H*/,  _I/*I*/,  _J/*J*/,
  _K/*K*/,  _L/*L*/,  _M/*M*/,  _N/*N*/,  _O/*O*/,
  _P/*P*/,  _Q/*Q*/,  _R/*R*/,  _S/*S*/,  _T/*T*/,
  _U/*U*/,  _V/*V*/,  _W/*W*/,  _X/*X*/,  _Y/*Y*/,  _Z/*Z*/
};

input KEYS_ON_KEYBOARD TrendlineKey = _Q;
input KEYS_ON_KEYBOARD RectangleKey = _W;
input KEYS_ON_KEYBOARD RayKey = _E;
input KEYS_ON_KEYBOARD FlatKey = _R;

extern int   mWid = 1;
extern color mCol = clrWhite;
extern color rCol = "70,70,70";
extern bool  mDeleteOnExit = false;
extern bool  rectangleAsBackground = false;
input color TextColor = clrRed;
input color TextFontSize = 8;

int mCnt = 0;
datetime mTime = 0, mTime2 = 0;
double mPrice = 0, mPrice2 = 0;

bool mDrawTrendline = false;
bool mDrawRectangle = false;
bool mRay = false;
bool mFlat = false;

int trendlineKey; 
int rectangleKey;
int rayKey;
int flatKey;

string objName;
double objLastPrice1;
double objLastPrice2;


//+------------------------------------------------------------------+
int init()
{
    trendlineKey = getNumericalValue(TrendlineKey);
    rectangleKey = getNumericalValue(RectangleKey);
    rayKey = getNumericalValue(RayKey);
    flatKey = getNumericalValue(FlatKey);

    return(0);
}

//+------------------------------------------------------------------+
int deinit()
 {
  string mObj;
  if(mDeleteOnExit)
    {
     for(int i = ObjectsTotal() - 1; i >= 0; i--)
      {
        mObj = ObjectName(i);
        if(StringSubstr(mObj, 0, 2) == "m.")
          ObjectDelete(mObj);
      }
    }
    
    return(0);
 }

//+------------------------------------------------------------------+
int start()
 {

   return(0);
 }
 
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event ID 
                  const long& lparam,   // Parameter of type long event 
                  const double& dparam, // Parameter of type double event 
                  const string& sparam)  // Parameter of type string events 
{
    if (id == CHARTEVENT_KEYDOWN) {
      
        if (lparam == trendlineKey) {
            if (mDrawRectangle) {
                mDrawRectangle = false;
                deleteLabel(RectangleKey);
            }
            mDrawTrendline = !mDrawTrendline;
            if (mDrawTrendline) {
                createLabel(TrendlineKey);
            }
            else {
                deleteLabel(TrendlineKey);
            }
        }

        if (lparam == rectangleKey) {
            if (mDrawTrendline) {
                mDrawTrendline = false;
                deleteLabel(TrendlineKey);
            }
            mDrawRectangle = !mDrawRectangle;
            if (mDrawRectangle) {
                createLabel(RectangleKey);
            }
            else {
                deleteLabel(RectangleKey);
            }
        }

        if (lparam == rayKey) {
            mRay = !mRay;
            if (mRay) {
                createLabel(RayKey);
            }
            else {
                deleteLabel(RayKey);
            }
        }

        if (lparam == flatKey) {
            mFlat = !mFlat;
            if (mFlat) {
                createLabel(FlatKey);
            }
            else {
                deleteLabel(FlatKey);
            }
        }
    }

    if (id == CHARTEVENT_CLICK) {
        if (mDrawTrendline || mDrawRectangle) {
            long mX = lparam;
            double mP = dparam;
            int win = 0;
            if(mCnt == 0) {
                ChartXYToTimePrice(0, mX, mP, win, mTime, mPrice);
                mCnt++;       
            }
            else {
                ChartXYToTimePrice(0, mX, mP, win, mTime2, mPrice2);
                mCnt = 0;
            }

            if (mPrice > 0 && mPrice2 > 0) {
                if (mDrawTrendline) {
                    ObjectCreate("m.Data"+IntegerToString(TimeLocal()), OBJ_TREND, 0, mTime, mPrice, mTime2, mFlat ? mPrice : mPrice2);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_COLOR, mCol);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_WIDTH, mWid);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_RAY, mRay);
                }
                if (mDrawRectangle) {
                    ObjectCreate("m.DataR"+IntegerToString(TimeLocal()), OBJ_RECTANGLE, 0, mTime, mPrice, mTime2, mPrice2);
                    ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_COLOR, rCol);
                    ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_BACK, rectangleAsBackground);
                }    
                mPrice = 0;
                mPrice2 = 0;
            }
        }
        else {
            mPrice = 0;
            mPrice2 = 0;    
        }
    } 

    if (id == CHARTEVENT_OBJECT_CLICK) {
        setObjName(sparam);
        double currPrice1 = ObjectGet(sparam, OBJPROP_PRICE1);
        double currPrice2 = ObjectGet(sparam, OBJPROP_PRICE2);
        setObjPrice(currPrice1, currPrice2);
    }

    if (id == CHARTEVENT_OBJECT_DRAG) {
        if (mFlat) {
            if (sparam == objName) {
                double newPrice1 = ObjectGet(sparam, OBJPROP_PRICE1);
                ObjectSet(sparam, OBJPROP_PRICE2, newPrice1);
            }
        }
    }
    return;
} 
  
int getNumericalValue(KEYS_ON_KEYBOARD key) {
  return key == _A ? 65
        : key == _B ? 66
        : key == _C ? 67
        : key == _D ? 68
        : key == _E ? 69
        : key == _F ? 70
        : key == _G ? 71
        : key == _H ? 72
        : key == _I ? 73
        : key == _J ? 74
        : key == _K ? 75
        : key == _L ? 76
        : key == _M ? 77
        : key == _N ? 78
        : key == _O ? 79
        : key == _P ? 80
        : key == _Q ? 81
        : key == _R ? 82
        : key == _S ? 83
        : key == _T ? 84
        : key == _U ? 85
        : key == _V ? 86
        : key == _W ? 87
        : key == _X ? 88
        : key == _Y ? 89
        : 90;
}

void setObjName(string name) {
    objName = name;
}

void setObjPrice(double price1, double price2) {
    objLastPrice1 = price1;
    objLastPrice2 = price2;
}

void createLabel(KEYS_ON_KEYBOARD key) {
    string name = key == TrendlineKey ? "Trendline"
                    : key == RectangleKey ? "Rectangle"
                    : key == RayKey ? "Ray"
                    : "Flat";
    int yDistance = key == TrendlineKey ? 0
                    : key == RectangleKey ? 0
                    : key == RayKey ? 20
                    : 40;
    
    ObjectCreate(name + " Label", OBJ_LABEL, 0, 0, 0);
    ObjectSetText(name + " Label", name + " : ON", TextFontSize, "Arial", TextColor);
    ObjectSet(name + " Label", OBJPROP_CORNER, 3);
    ObjectSet(name + " Label", OBJPROP_XDISTANCE, 15);
    ObjectSet(name + " Label", OBJPROP_YDISTANCE, yDistance);
}

void deleteLabel(KEYS_ON_KEYBOARD key) {
    string name = key == TrendlineKey ? "Trendline"
                    : key == RectangleKey ? "Rectangle"
                    : key == RayKey ? "Ray"
                    : "Flat";

    ObjectDelete(name + " Label");
}