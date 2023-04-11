//+------------------------------------------------------------------+
//|                                              mn ClickAndDraw.mq4 |
//+------------------------------------------------------------------+
#property copyright "WHITE"
#property strict
#property indicator_chart_window

#include "../../Awptic/model/Object.mqh"

enum KEYS_ON_KEYBOARD {
    _Zero   = 48    /*0*/,
    _One    = 49    /*1*/,
    _Two    = 50    /*2*/,
    _Three  = 51    /*3*/,
    _Four   = 52    /*4*/,
    _Five   = 53    /*5*/,
    _Six    = 54    /*6*/,
    _Seven  = 55    /*7*/,
    _Eight  = 56    /*8*/,
    _Nine   = 57    /*9*/,
    
    _A      = 65    /*A*/,
    _B      = 66    /*B*/,
    _C      = 67    /*C*/,
    _D      = 68    /*D*/,
    _E      = 69    /*E*/,
    _F      = 70    /*F*/,
    _G      = 71    /*G*/,
    _H      = 72    /*H*/,
    _I      = 73    /*I*/,
    _J      = 74    /*J*/,
    _K      = 75    /*K*/,
    _L      = 76    /*L*/,
    _M      = 77    /*M*/,
    _N      = 78    /*N*/,
    _O      = 79    /*O*/,
    _P      = 80    /*P*/,
    _Q      = 81    /*Q*/,
    _R      = 82    /*R*/,
    _S      = 83    /*S*/,
    _T      = 84    /*T*/,
    _U      = 85    /*U*/,
    _V      = 86    /*V*/,
    _W      = 87    /*W*/,
    _X      = 88    /*X*/,
    _Y      = 89    /*Y*/, 
    _Z      = 90    /*Z*/
};

input KEYS_ON_KEYBOARD ExtendSwitcherKey = _C;
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
extern bool  mExtendSwitch = false;
extern bool  mExtendHigh = false;
extern bool  mExtendLow = false;      
extern bool  mDrawTrendline = false;
extern bool  mDrawRectangle = false;
extern bool  mRay = false;
extern bool  mFlat = true;
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

    setDefaultStates();
    
    addObjectsToMyObjects();
    if (ArraySize(myObjects) > 0) {
        initObjectPointer();
    }
    

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

    resetMyObjects();

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
            if (objPointer != NULL && objPointer.getType() != OBJ_RECTANGLE && objPointer.isSelected()) {
                setRay(false);
            }
        }

        if (lparam == FlatKey) {
            if (!mDrawRectangle) {
                setFlat(!mFlat);
                if (objPointer != NULL && ObjectType(objPointer.getName()) != OBJ_RECTANGLE && objPointer.isSelected()) {
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
            if (mDrawTrendline) {
                setStyle(
                    mStyle == 0 ? 1
                    : mStyle == 1 ? 0
                    : 0,
                    true
                );
            }
            if (mDrawRectangle) {
                rectangleAsBackground = !rectangleAsBackground;
                setStyle(2, true);
            }
            if (objPointer != NULL && objPointer.getType() == OBJ_TREND && objPointer.isSelected()) {
                setStyle(
                    mStyle == 0 ? 1
                    : mStyle == 1 ? 0
                    : 0,
                    false
                );
                objPointer.setStyle(mStyle);
            }
        }

        if (lparam == ExtendHighKey) {
            if (mExtendSwitch) {
                if (mExtendLow) {
                    setExtendLow(false);
                }
                setExtendHigh(!mExtendHigh);

                if (objPointer != NULL) {
                    if (objPointer.isSelected()) {
                        if (ObjectType(objPointer.getName()) == OBJ_TREND) {
                            objPointer.setExtend(mExtendHigh);
                        }
                        else {
                            objPointer.setExtendByBuyOrSell(mExtendHigh, true);
                        }
                        if (ObjectType(objPointer.getName()) != OBJ_RECTANGLE && mExtendHigh) {
                            setFlat(true);
                            objPointer.setFlat(true);
                        }
                        
                    }
                }
            }
        }

        if (lparam == ExtendLowKey) {
            if (mExtendSwitch) {
                if (objPointer != NULL && ObjectType(objPointer.getName()) == OBJ_RECTANGLE) {
                    if (mExtendHigh) {
                        setExtendHigh(false);
                    }
                    setExtendLow(!mExtendLow);
                    if (objPointer.isSelected()) {
                        objPointer.setExtendByBuyOrSell(mExtendLow, false);
                    }
                }
            }
        }

        if (lparam == ExtendSwitcherKey) {
            setExtendSwitch(!mExtendSwitch);
            if (objPointer != NULL) {
                if (objPointer.isSelected()) {
                    objPointer.setExtendSwitch(mExtendSwitch);
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
                if (mDrawRectangle) {
                    ChartXYToTimePrice(0, mX, mP, win, mTime, mPrice);
                    if (mPrice > 0) {
                        int index = iBarShift(Symbol(),Period(),mTime,true);
                        mPrice = High[index];
                        mPrice2 = Low[index];
                        mTime2 = TimeCurrent();
                    }
                }
                else if (mDrawTrendline) {
                    ChartXYToTimePrice(0, mX, mP, win, mTime, mPrice);
                    if (mPrice > 0) {
                        int index = iBarShift(Symbol(),Period(),mTime,true);
                        mPrice = (mPrice > Open[index]) ? High[index] : Low[index];
                    }
                }   
                mCnt++;
            }
            else if (mCnt != 0 && mPrice2 == 0) {
                ChartXYToTimePrice(0, mX, mP, win, mTime2, mPrice2);
                mCnt = 0;
            }

            if (mPrice > 0 && mPrice2 > 0) {
                string timeStr = TimeToStr(TimeLocal(), TIME_DATE|TIME_SECONDS);
                if (mDrawTrendline) {
                    createTrendline("Trendline " + timeStr);
                }
                if (mDrawRectangle) {
                    createRectangle("Rectangle " + timeStr);
                }    
                mPrice = 0;
                mPrice2 = 0;
                mCnt = 0;
            }
        }
        else {
            mPrice = 0;
            mPrice2 = 0;    
            mCnt = 0;
        }
    } 

    if (id == CHARTEVENT_OBJECT_CLICK) {
        setObjectPointer(sparam);

        if (objPointer != NULL) {
            if (objPointer.isSelected()) {
                setFlat(objPointer.isFlat());
                setRay(objPointer.isRay());
                if (objPointer.getType() == OBJ_TREND) {
                    setExtendHigh(objPointer.isExtend());
                    setTrendlineColor((color)objPointer.getColor());
                }
                if (objPointer.getType() == OBJ_RECTANGLE) {
                    if (objPointer.isExtend()) {
                        if (objPointer.isEngulfBuy()) {
                            setExtendHigh(objPointer.isExtend());
                        }
                        else {
                            setExtendLow(objPointer.isExtend());
                        }
                    }
                }
            }
            else {
                setDefaultStates();
                objPointer = NULL;
            }
        }
    }

    if (id == CHARTEVENT_OBJECT_DRAG) {
        setObjectPointer(sparam);
        if (objPointer != NULL) {
            if (objPointer.getType() == OBJ_TREND) {
                objPointer.setExtend(objPointer.isExtend());
                objPointer.setFlat(objPointer.isFlat());
            }
            else {
                if (mExtendHigh) {
                    objPointer.setExtendByBuyOrSell(mExtendHigh, true);
                }
                else if (mExtendLow) {
                    objPointer.setExtendByBuyOrSell(mExtendLow, false);
                }
            }
        }
    }

    if (id == CHARTEVENT_OBJECT_CREATE) {
        if (!findObjectInObjPointer(sparam) && (ObjectType(sparam) == OBJ_RECTANGLE || ObjectType(sparam) == OBJ_TREND)) {
            increaseMyObjectsSize();
            int index = ArraySize(myObjects) - 1;
            myObjects[index] = new Object(sparam);
        }
    }

    if (id == CHARTEVENT_OBJECT_DELETE) {
        resetMyObjects();
        setDefaultStates();
        addObjectsToMyObjects();
    }

    return;
}

void createLabel(KEYS_ON_KEYBOARD key) {
    string name = key == TrendlineKey ? "Trendline"
                    : key == RectangleKey ? "Rectangle"
                    : key == RayKey ? "Ray"
                    : key == FlatKey ? "Flat"
                    : key == ExtendHighKey ? "Engulf Supply"
                    : key == ExtendLowKey ? "Engulf Demand"

                    : key == StyleKey ? (
                        mStyle == 0 ? "Style" 
                        : mStyle == 1 ? "Style" 
                        : rectangleAsBackground ? "Background" 
                        : "Unidentified"
                    )                 
                    : key == ExtendSwitcherKey ? "Extend Switch"
                    : "Unidentified";

    string status = key == TrendlineKey ? "ON"
                    : key == RectangleKey ? "ON"
                    : key == RayKey ? "ON"
                    : key == FlatKey ? "OFF"
                    : key == ExtendSwitcherKey? "ON"
                    : key == StyleKey ? (
                        mStyle == 0 ? "Solid" 
                        : mStyle == 1 ? "Dash" 
                        : rectangleAsBackground ? "ON" 
                        : " : OFF"
                    )
                    : key == ExtendHighKey ? "ON"
                    : key == ExtendLowKey ? "ON"
                    : "Unidentified";

    int yDistance = key == StyleKey ? 0
                    : key == TrendlineKey ? 20
                    : key == RectangleKey ? 20
                    : key == RayKey ? 60
                    : key == ExtendSwitcherKey ? 80
                    : key == ExtendHighKey ? 100
                    : key == ExtendLowKey ? 100
                    : 40;
    
    ObjectCreate(name + " Label", OBJ_LABEL, 0, 0, 0);
    ObjectSetText(
        name + " Label", 
        name + " : " + status, TextFontSize, TextFont, TextColor);
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
                    : key == ExtendHighKey ? "Engulf Supply"
                    : key == ExtendLowKey ? "Engulf Demand"
                    : key == StyleKey ? (
                        mStyle == 0 ? "Style" 
                        : mStyle == 1 ? "Style"
                        : rectangleAsBackground ? "Background" 
                        : "Unidentified"
                    )                 
                    : key == ExtendSwitcherKey ? "Extend Switch"
                    : "Unidentified";

    ObjectDelete(name + " Label");
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

void setExtendSwitch(bool status) {
    mExtendSwitch = status;
    if (mExtendSwitch) {
        createLabel(ExtendSwitcherKey);
    }
    else {
        deleteLabel(ExtendSwitcherKey);
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
        setStyle(2, false);
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

bool findObjectInObjPointer(string name) {
    for (int i = 0; i < ArraySize(myObjects); i++) {
        if (name == myObjects[i].getName()) {
            return true;
        }
    }
    return false;
}

void initObjectPointer() {
    for (int i = 0; i < ArraySize(myObjects); i++) {
        if (myObjects[i].isSelected()) {
            objPointer = myObjects[i];
            break;
        }
    }
}

void addObjectsToMyObjects() {
    for (int i = 0; i < ObjectsTotal(); i++) {
        int type = ObjectType(ObjectName(i));
        if (type == OBJ_TREND || type == OBJ_RECTANGLE) {
            string name = ObjectName(i);
            increaseMyObjectsSize();
            int index = ArraySize(myObjects) - 1;
            myObjects[index] = new Object(false, name, type);
        }
    }
}

void resetMyObjects() {
    for (int i = 0; i < ArraySize(myObjects); i++) {
        delete myObjects[i];
    }
    ArrayFree(myObjects);
}

void increaseMyObjectsSize() {
    ArrayResize(myObjects, ArraySize(myObjects) + 1);
}

void createTrendline(string name) {
    ResetLastError();

    increaseMyObjectsSize();
    int index = ArraySize(myObjects) - 1;
    myObjects[index] = new Object(name);
    objPointer = myObjects[index];
    objPointer.create(OBJ_TREND);
    objPointer.setTime1(mTime);
    objPointer.setTime2(mTime2);
    objPointer.setPrice1(mPrice);
    objPointer.setPrice2(mFlat ? mPrice : mPrice2);
    objPointer.setColor(mTrendlineColor);
    objPointer.setStyle(mStyle);
    objPointer.setWidth(mWid);
    objPointer.setRay(mRay);

    objPointer = NULL;

    setDrawTrendline(false);
}

void createRectangle(string name) {
    
    increaseMyObjectsSize();
    int index = ArraySize(myObjects) - 1;
    myObjects[index] = new Object(name);
    objPointer = myObjects[index];
    objPointer.create(OBJ_RECTANGLE);
    objPointer.setTime1(mTime);
    objPointer.setTime2(mTime2);
    objPointer.setPrice1(mPrice);
    objPointer.setPrice2(mPrice2);
    objPointer.setColor(rCol);
    objPointer.setBackground(rectangleAsBackground);

    objPointer = NULL;

    setDrawRectangle(false);
}

void setDefaultStates() {
    setTrendlineColor(trendlineColor1);
    setStyle(0, false);
    setFlat(true);
    setExtendHigh(false);
    setExtendLow(false);
    setRay(false);
}