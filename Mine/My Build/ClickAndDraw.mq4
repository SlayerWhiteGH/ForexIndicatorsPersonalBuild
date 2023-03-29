//+------------------------------------------------------------------+
//|                                              mn ClickAndDraw.mq4 |
//+------------------------------------------------------------------+
#property copyright "WHITE"
#property strict
#property indicator_chart_window

enum KEYS_ON_KEYBOARD {
  _A = 65/*A*/,  _B = 66/*B*/,  _C = 67/*C*/,  _D = 68/*D*/,  _E = 69/*E*/,
  _F = 70/*F*/,  _G = 71/*G*/,  _H = 72/*H*/,  _I = 73/*I*/,  _J = 74/*J*/,
  _K = 75/*K*/,  _L = 76/*L*/,  _M = 77/*M*/,  _N = 78/*N*/,  _O = 79/*O*/,
  _P = 80/*P*/,  _Q = 81/*Q*/,  _R = 82/*R*/,  _S = 83/*S*/,  _T = 84/*T*/,
  _U = 85/*U*/,  _V = 86/*V*/,  _W = 87/*W*/,  _X = 88/*X*/,  _Y = 89/*Y*/, 
  _Z = 90/*Z*/, _One = 49/*1*/, _Two = 50/*2*/, _Three = 51/*3*/, _Four = 52/*4*/
};

input KEYS_ON_KEYBOARD TrendlineKey = _Q;
input KEYS_ON_KEYBOARD RectangleKey = _W;
input KEYS_ON_KEYBOARD RayKey = _R;
input KEYS_ON_KEYBOARD FlatKey = _F;
input KEYS_ON_KEYBOARD Color1Key = _One;
input KEYS_ON_KEYBOARD Color2Key = _Two;
input KEYS_ON_KEYBOARD Color3Key = _Three;
input KEYS_ON_KEYBOARD StyleKey = _Four;

extern int   mWid = 1;
extern color rCol = "70,70,70";       
extern bool  mDrawTrendline = false;
extern bool  mDrawRectangle = false;
extern bool  mRay = false;
extern bool  mFlat = false;
extern bool  mDeleteOnExit = false;                 // Delete All Objects On Exit?
extern bool  rectangleAsBackground = true;         // Rectangle As Background?
extern color trendlineColor1 = clrRed;              // Trendline Color 1
extern color trendlineColor2 = clrGreen;            // Trendline Color 2
extern color trendlineColor3 = clrBlue;             // Trendline Color 3
extern int   TextFontSize = 10;
extern color TextColor = clrBlack;

color mTrendlineColor;
extern int mStyle;

int mCnt = 0;
datetime mTime = 0, mTime2 = 0;
double mPrice = 0, mPrice2 = 0;

string objName;
double objLastPrice1;
double objLastPrice2;

#define TextFont "Arial"


//+------------------------------------------------------------------+
int init()
{
    mTrendlineColor = trendlineColor1;
    mStyle = 0;

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
        if (lparam == TrendlineKey) {
            if (mDrawRectangle) {
                mDrawRectangle = false;
                deleteLabel(RectangleKey);
                deleteLabel(StyleKey);
            }
            mDrawTrendline = !mDrawTrendline;
            if (mDrawTrendline) {
                createLabel(TrendlineKey);
                if (mStyle == 2) mStyle = 0;
                createLabel(StyleKey);

                mFlat = true;
                createLabel(FlatKey);
            }
            else {
                deleteLabel(TrendlineKey);
                deleteLabel(StyleKey);
                if (mRay) {
                    mRay = false;
                    deleteLabel(RayKey);
                }

                mFlat = false;
                deleteLabel(FlatKey);
            }
        }

        if (lparam == RectangleKey) {
            if (mDrawTrendline) {
                mDrawTrendline = false;
                deleteLabel(TrendlineKey);
                deleteLabel(StyleKey);
            }
            mDrawRectangle = !mDrawRectangle;
            if (mDrawRectangle) {
                createLabel(RectangleKey);
                
                mStyle = 2;
                createLabel(StyleKey);

                mFlat = false;
                mRay = false;
                deleteLabel(FlatKey);
                deleteLabel(RayKey);
            }
            else {
                deleteLabel(RectangleKey);
                deleteLabel(StyleKey);
            }
        }

        if (lparam == RayKey) {
            if (!mDrawRectangle) {
                mRay = !mRay;
                if (mRay) {
                    createLabel(RayKey);
                }
                else {
                    deleteLabel(RayKey);
                }
            }
        }

        if (lparam == FlatKey) {
            if (!mDrawRectangle) {
                mFlat = !mFlat;
                if (mFlat) {
                    createLabel(FlatKey);
                }
                else {
                    deleteLabel(FlatKey);
                }
            }
        }

        if (lparam == Color1Key) {
            if (mDrawTrendline) {
                deleteLabel(TrendlineKey);
                mTrendlineColor = trendlineColor1;
                createLabel(TrendlineKey);
            }
        }

        if (lparam == Color2Key) {
            if (mDrawTrendline) {
                deleteLabel(TrendlineKey);
                mTrendlineColor = trendlineColor2;
                createLabel(TrendlineKey);
            }
        }

        if (lparam == Color3Key) {
            if (mDrawTrendline) {
                deleteLabel(TrendlineKey);
                mTrendlineColor = trendlineColor3;
                createLabel(TrendlineKey);
            }
        }

        if (lparam == StyleKey) {
            if (mDrawTrendline || mDrawRectangle) {
                deleteLabel(StyleKey);
                if (mDrawTrendline) {
                    mStyle = mStyle == 0 ? 1
                                : mStyle == 1 ? 0
                                : 0;
                }
                if (mDrawRectangle) {
                    rectangleAsBackground = !rectangleAsBackground;
                    mStyle = 2;
                }
                createLabel(StyleKey);

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
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_COLOR, mTrendlineColor);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_WIDTH, mWid);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_RAY, mRay);
                    ObjectSet("m.Data"+IntegerToString(TimeLocal()), OBJPROP_STYLE, mStyle);

                    mDrawTrendline = false;
                    deleteLabel(TrendlineKey);
                    deleteLabel(StyleKey);
                    if (mRay) {
                        mRay = false;
                        deleteLabel(RayKey);
                    }

                    if (mFlat) {
                        mFlat = false;
                        deleteLabel(FlatKey);
                    }
                }
                if (mDrawRectangle) {
                    ObjectCreate("m.DataR"+IntegerToString(TimeLocal()), OBJ_RECTANGLE, 0, mTime, mPrice, mTime2, mPrice2);
                    ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_COLOR, rCol);
                    ObjectSet("m.DataR"+IntegerToString(TimeLocal()), OBJPROP_BACK, rectangleAsBackground);

                    mDrawRectangle = false;
                    deleteLabel(RectangleKey);
                    deleteLabel(StyleKey);
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
                    : key == FlatKey ? "Flat"
                    : mStyle == 2 ? "Background"    // StyleKey
                    : "Style";                      // StyleKey
    int yDistance = key == StyleKey ? 0
                    : key == TrendlineKey ? 20
                    : key == RectangleKey ? 20
                    : key == RayKey ? 60
                    : 40;
    
    ObjectCreate(name + " Label", OBJ_LABEL, 0, 0, 0);
    ObjectSetText(name + " Label", name + (key == StyleKey ? (mStyle == 0 ? " : Solid" : mStyle == 1 ? " : Dash" : rectangleAsBackground ? " : ON" : " : OFF") : " : ON"), TextFontSize, TextFont, TextColor);
    ObjectSet(name + " Label", OBJPROP_CORNER, 3);
    ObjectSet(name + " Label", OBJPROP_XDISTANCE, 15);
    ObjectSet(name + " Label", OBJPROP_YDISTANCE, yDistance);
    if (key == TrendlineKey) {
        ObjectSet(name + " Label", OBJPROP_COLOR, mTrendlineColor);
    }
}

void deleteLabel(KEYS_ON_KEYBOARD key) {
    string name = key == TrendlineKey ? "Trendline"
                    : key == RectangleKey ? "Rectangle"
                    : key == RayKey ? "Ray"
                    : key == FlatKey ? "Flat"
                    : mStyle == 2 ? "Background"
                    : "Style";

    ObjectDelete(name + " Label");
}

