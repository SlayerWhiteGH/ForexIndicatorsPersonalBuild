//+------------------------------------------------------------------+
//|                                              mn ClickAndDraw.mq4 |
//+------------------------------------------------------------------+
#property copyright "WHITE"
#property strict
#property indicator_chart_window

#include "../../Awptic/model/Object.mqh"
// #include "../../Awptic/Hotkeys.mqh"

enum KEYS_ON_KEYBOARD {
  _A = 65/*A*/,  _B = 66/*B*/,  _C = 67/*C*/,  _D = 68/*D*/,  _E = 69/*E*/,
  _F = 70/*F*/,  _G = 71/*G*/,  _H = 72/*H*/,  _I = 73/*I*/,  _J = 74/*J*/,
  _K = 75/*K*/,  _L = 76/*L*/,  _M = 77/*M*/,  _N = 78/*N*/,  _O = 79/*O*/,
  _P = 80/*P*/,  _Q = 81/*Q*/,  _R = 82/*R*/,  _S = 83/*S*/,  _T = 84/*T*/,
  _U = 85/*U*/,  _V = 86/*V*/,  _W = 87/*W*/,  _X = 88/*X*/,  _Y = 89/*Y*/, 
  _Z = 90/*Z*/, _One = 49/*1*/, _Two = 50/*2*/, _Three = 51/*3*/, _Four = 52/*4*/
};

input KEYS_ON_KEYBOARD ExtendHighKey = _X;
input KEYS_ON_KEYBOARD ExtendLowKey = _Z;
input KEYS_ON_KEYBOARD TrendlineKey = _Q;
input KEYS_ON_KEYBOARD RectangleKey = _W;
input KEYS_ON_KEYBOARD RayKey = _R;
input KEYS_ON_KEYBOARD FlatKey = _F;
input KEYS_ON_KEYBOARD Color1Key = _One;
input KEYS_ON_KEYBOARD Color2Key = _Two;
input KEYS_ON_KEYBOARD Color3Key = _Three;
input KEYS_ON_KEYBOARD StyleKey = _Four;


extern int   mWid = 1;
extern color rCol = C'70,70,70'; 
extern bool  mExtendHigh = false;
extern bool  mExtendLow = false;      
extern bool  mDrawTrendline = false;
extern bool  mDrawRectangle = false;
extern bool  mRay = false;
extern bool  mFlat = false;
extern bool  mDeleteOnExit = false;                 // Delete All Objects On Exit?
extern bool  rectangleAsBackground = true;          // Rectangle As Background?
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
bool objSelected;
double objLastPrice1;
double objLastPrice2;
Object *objPointer;

Object *myObjects[];

#define TextFont "Arial"


//+------------------------------------------------------------------+
int init()
{

    setTrendlineColor(trendlineColor1);
    setStyle(0, false);
    setFlat(mFlat);
    setExtendHigh(mExtendHigh);
    setExtendLow(mExtendLow);
    setRay(mRay);
    
    for (int i = 0; i < ObjectsTotal(); i++) {
        int type = ObjectType(ObjectName(i));
        if (type == OBJ_TREND || type == OBJ_RECTANGLE) {
            string name = ObjectName(i);
            increaseMyObjectsSize();
            for (int j = 0; j < ArraySize(myObjects); j++) {
                printf("Iteration i : " + string(i));
                printf("Iteration j : " + string(j));

                if (myObjects[j] == NULL) {
                    myObjects[j] = new Object(false, name, type);
                    printf("Name : " + myObjects[j].getName());
                    break;
                }
            }
        }
    }

    initObjectPointer();

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

    for (int i = 0; i < ArraySize(myObjects); i++) {
        delete myObjects[i];
    }

    ArrayFree(myObjects);

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
                setDrawRectangle(false);
            }
            setDrawTrendline(!mDrawTrendline);
        }

        if (lparam == RectangleKey) {
            if (mDrawTrendline) {
                setDrawTrendline(false);
            }
            setDrawRectangle(!mDrawRectangle);
        }

        if (lparam == RayKey) {
            if (!mDrawRectangle) {
                setRay(!mRay);
            }
        }

        if (lparam == FlatKey) {
            if (!mDrawRectangle) {
                setFlat(!mFlat);
                if (objPointer != NULL) {
                    objPointer.setFlat(mFlat);
                }
            }
        }

        if (lparam == Color1Key || lparam == Color2Key || lparam == Color3Key) {
            setTrendlineColor(
                lparam == Color1Key ? trendlineColor1
                    : lparam == Color2Key ? trendlineColor2
                    : trendlineColor3
            );
            if (mDrawTrendline) {
                resetTrendlineColorLabel();
            }
            if (objPointer != NULL) {
                if (objPointer.isSelected()) {
                    objPointer.setColor(mTrendlineColor);
                }
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

        if (lparam == ExtendHighKey) {
            if (mExtendLow) {
                setExtendLow(false);
            }
            setExtendHigh(!mExtendHigh);

            if (objPointer != NULL) {
                if (objPointer.isSelected()) {
                    objPointer.setExtend(mExtendHigh, true);
                    if (mExtendHigh) {
                        setFlat(true);
                        objPointer.setFlat(true);
                    }
                    
                }
            }
        }

        if (lparam == ExtendLowKey) {
            if (mExtendHigh) {
                setExtendHigh(false);
            }
            setExtendLow(!mExtendLow);

            if (objPointer != NULL) {
                if (objPointer.isSelected()) {
                    objPointer.setExtend(mExtendLow, false);
                    if (mExtendLow) {
                        setFlat(true);
                        objPointer.setFlat(true);
                    }
                    
                }
            }
        }

    }

    if (id == CHARTEVENT_CLICK) {
        if (mDrawTrendline || mDrawRectangle) {
            int mX = (int)lparam;
            int mP = (int)dparam;
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

        if (objPointer != NULL) {
            if (!objPointer.isSelected()) {
                setFlat(true);
                objPointer.setFlat(true);
                objPointer = NULL;
            }
        }
    } 

    if (id == CHARTEVENT_OBJECT_CLICK) {
        setObjectPointer(sparam);

        // setObjName(sparam);
        // double currPrice1 = ObjectGet(sparam, OBJPROP_PRICE1);
        // double currPrice2 = ObjectGet(sparam, OBJPROP_PRICE2);
        // setObjPrice(currPrice1, currPrice2);
        // setObjSelected(true);
        
        if (ObjectType(sparam) == OBJ_RECTANGLE) {
            if (mFlat) {
                setFlat(false);
            }
        }
    }

    if (id == CHARTEVENT_OBJECT_DRAG) {
        setObjectPointer(sparam);
        if (objPointer != NULL) {
            if (mExtendHigh) {
                objPointer.setExtend(mExtendHigh, true);
            }
            else if (mExtendLow) {
                objPointer.setExtend(mExtendLow, false);
            }
            if (mExtendHigh) {
                objPointer.setFlat(mFlat);
            }
        }
    }
    return;
}

datetime getHighEngulf(long waktu) {
    datetime firstEngulf = 0;
    int indexX1 = iBarShift(Symbol(), Period(), waktu, true);
    for (int i = indexX1 - 1 ; i >= 0 ; i--) {
        if (High[i] > High[indexX1]) {
            firstEngulf = Time[i];
        }
    }
    return firstEngulf;
}

void setExtendHigh(string name) {
    ObjectSet(name, OBJPROP_TIME2, TimeCurrent());
}

void setObjName(string name) {
    objName = name;
}

void setObjPrice(double price1, double price2) {
    objLastPrice1 = price1;
    objLastPrice2 = price2;
}

void setObjSelected(bool isSelected) {
    objSelected = isSelected;
}

void createLabel(KEYS_ON_KEYBOARD key) {
    string name = key == TrendlineKey ? "Trendline"
                    : key == RectangleKey ? "Rectangle"
                    : key == RayKey ? "Ray"
                    : key == FlatKey ? "Flat"
                    : key == ExtendHighKey ? "Extend High"
                    : key == ExtendLowKey ? "Extend Low"
                    : mStyle == 2 ? "Background"    // StyleKey
                    : "Style";                      // StyleKey
    int yDistance = key == StyleKey ? 0
                    : key == TrendlineKey ? 20
                    : key == RectangleKey ? 20
                    : key == RayKey ? 60
                    : key == ExtendHighKey ? 80
                    : key == ExtendLowKey ? 80
                    : 40;
    
    ObjectCreate(name + " Label", OBJ_LABEL, 0, 0, 0);
    ObjectSetText(
        name + " Label", 
        name + (
            key == StyleKey ? (
                mStyle == 0 ? " : Solid" 
                : mStyle == 1 ? " : Dash" 
                : rectangleAsBackground ? " : ON" 
                : " : OFF"
            ) 
            : key == FlatKey ? " : OFF"
            : " : ON"
        ), TextFontSize, TextFont, TextColor);
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
                    : key == ExtendHighKey ? "Extend High"
                    : key == ExtendLowKey ? "Extend Low"
                    : mStyle == 2 ? "Background"
                    : "Style";

    ObjectDelete(name + " Label");
}

void increaseMyObjectsSize() {
    ArrayResize(myObjects, ArraySize(myObjects) + 1);
}

void setFlat(bool isFlat) {
    mFlat = isFlat;
    if (isFlat) {
        deleteLabel(FlatKey);
    }
    else {
        createLabel(FlatKey);
    }
}

void setRay(bool isRay) {
    mRay = isRay;
    if (isRay) {
        createLabel(RayKey);
    }
    else {
        deleteLabel(RayKey);
    }
}

void setExtendHigh(bool isExtend) {
    mExtendHigh = isExtend;
    if (isExtend) {
        createLabel(ExtendHighKey);
    }
    else {
        deleteLabel(ExtendHighKey);
    }
}

void setExtendLow(bool isExtend) {
    mExtendLow = isExtend;
    if (isExtend) {
        createLabel(ExtendLowKey);
    }
    else {
        deleteLabel(ExtendLowKey);
    }
}

void setTrendlineColor(color newColor) {
    mTrendlineColor = newColor;
}

void resetTrendlineColorLabel() {
    deleteLabel(TrendlineKey);
    createLabel(TrendlineKey);
}

void setStyle(int newStyle, bool status) {
    mStyle = newStyle;
    if (status) {
        createLabel(StyleKey);
    }
    else {
        deleteLabel(StyleKey);
    }
}

void setDrawTrendline(bool isDrawTrendline) {
    mDrawTrendline = isDrawTrendline;
    if (isDrawTrendline) {
        createLabel(TrendlineKey);
        setStyle((mStyle == 2 ? 0 : mStyle), true);
        setFlat(true);
    }
    else {    
        deleteLabel(TrendlineKey);
        setStyle(mStyle, false);
        if (mRay) {
            setRay(false);
        }
    }
}

void setDrawRectangle(bool isDrawRectangle) {
    mDrawRectangle = isDrawRectangle;
    if (isDrawRectangle) {
        createLabel(RectangleKey);
        setStyle(2, true);
        setFlat(false);
        setRay(false);
    }
    else {
        deleteLabel(RectangleKey);
        setStyle(mStyle, false);
        setFlat(true);
    }
}

void setObjectPointer(string name) {
    for (int i = 0; i < ArraySize(myObjects); i++) {
        if (name == myObjects[i].getName()) {
            objPointer = myObjects[i];
            break;
        }
    }
}

void initObjectPointer() {
    for (int i = 0; i < ArraySize(myObjects); i++) {
        if (myObjects[i].isSelected()) {
            objPointer = myObjects[i];
            break;
        }
    }
}

void createTrendline() {
    
}