//+------------------------------------------------------------------+
//|                                                       Object.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class Object
  {
private:
    bool flat;
    bool extend;
    bool engulfBuy;
    bool extendSwitch;

    long chartId;

    string name;

public:

    Object(string newName) {
        name = newName;
    }
    
    Object(bool create, string newName, int newType) {
        name = newName;

        if (create) 
            ObjectCreate(0, name, newType, 0, 0, 0);
    }

    Object(bool create, string newName, int newType, long newChartId, int newSubWindow) {
        name = newName;
        chartId = newChartId;

        if (create) 
            ObjectCreate(newChartId, name, newType, newSubWindow, 0, 0);
    }

    void create(int newType) {
        ObjectCreate(0, name, newType, 0, 0, 0);
    }

    void create(string newName, int newType) {
        name = newName;
        ObjectCreate(0, newName, newType, 0, 0, 0);
    }

    // Setter
    void setFlat(bool status) {
        flat = status;
        if (flat) {
            setPrice2(getPrice1());
        }
    }
    void setExtendSwitch(bool status) {
        extendSwitch = status;
    }

    void setExtend(bool status) {
        if (isExtendSwitch()) {
            extend = status;
            if (extend) {
                setTime2(TimeCurrent());
            }
            else {
                int x1 = iBarShift(Symbol(), Period(), getTime1(), true);
                for (int i = x1 - 1; i >= 0; i--) {
                    if (getPrice1() == High[x1]) {
                        if (High[i] > High[x1]) {
                            setTime2(Time[i]);
                            break;
                        }
                    }
                    if (getPrice1() == Low[x1]) {
                        if (Low[i] < Low[x1]) {
                            setTime2(Time[i]);
                            break;
                        }
                    }
                }
            }
        }
    }
    void setExtendByBuyOrSell(bool status, bool buy) {
        if (isExtendSwitch()) {
            extend = status;
            if (extend) {
                setTime2(TimeCurrent());
            }
            else {
                engulfBuy = buy;
                int x1 = iBarShift(Symbol(), Period(), getTime1(), true);
                for (int i = x1 - 1; i >= 0; i--) {
                    if (buy) {
                        if (High[i] > getPrice1()) {
                            setTime2(Time[i]);
                            break;
                        }
                    }
                    else {
                        if (Low[i] < getPrice2()) {
                            setTime2(Time[i]);
                            break;
                        }
                    }
                }
            }
        }
    }
    void setBackground(bool newBackground) {
        ObjectSet(name, OBJPROP_BACK, newBackground);
    }
    void setSelected(bool newSelected) {
        ObjectSet(name, OBJPROP_SELECTED, newSelected);
    }
    void setReadOnly(bool newReadOnly) {
        ObjectSet(name, OBJPROP_READONLY, newReadOnly);
    }
    void setSelectable(bool newSelectable) {
        ObjectSet(name, OBJPROP_SELECTABLE, newSelectable);
    }
    void setRay(bool isRay) {
        ObjectSet(name, OBJPROP_RAY, isRay);   
    }
    void setColor(color newColor) {
        ObjectSet(name, OBJPROP_COLOR, newColor);
    }
    void setTime1(datetime newTime) {
        ObjectSet(name, OBJPROP_TIME1, newTime);
    }
    void setTime2(datetime newTime) {
        ObjectSet(name, OBJPROP_TIME2, newTime);
    }
    void setPrice1(double newPrice) {
        ObjectSet(name, OBJPROP_PRICE1, newPrice);
    }
    void setPrice2(double newPrice) {
        ObjectSet(name, OBJPROP_PRICE2, newPrice);
    }
    void setStyle(int newStyle) {
        ObjectSet(name, OBJPROP_STYLE, newStyle);
    }
    void setType(int newType) {
        ObjectSet(name, OBJPROP_TYPE, newType);
    }
    void setThickness(int newThickness) {
        ObjectSet(name, OBJPROP_WIDTH, newThickness);
    }
    void setFontSize(int newFontSize) {
        ObjectSet(name, OBJPROP_FONTSIZE, newFontSize);
    }
    void setXDistance(int newX) {
        ObjectSet(name, OBJPROP_XDISTANCE, newX);
    }
    void setYDistance(int newY) {
        ObjectSet(name, OBJPROP_YDISTANCE, newY);
    }
    void setWidth(int newWidth) {
        ObjectSet(name, OBJPROP_XSIZE, newWidth);
    }
    void setHeight(int newHeight) {
        ObjectSet(name, OBJPROP_YSIZE, newHeight);
    }
    void setZOrder(long newZOrder) {
        ObjectSet(name, OBJPROP_ZORDER, newZOrder);
    }
    void setName(string newName) {
        ObjectSetString(chartId, name, OBJPROP_NAME, newName);
        name = newName;
    }
    void setFont(string newFont) {
        ObjectSetString(chartId, name, OBJPROP_FONT, newFont);
    }

    // Getter
    bool isFlat() {
        return flat;
    }
    bool isExtendSwitch() {
        return extendSwitch;
    }
    bool isExtend() {
        return extend;
    }
    bool isEngulfBuy() {
        return engulfBuy;
    }
    bool isBackground() {
        return ObjectGet(name, OBJPROP_BACK) == true;
    }
    bool isSelected() {
        return ObjectGet(name, OBJPROP_SELECTED) == true;
    }
    bool isReadOnly() {
        return ObjectGet(name, OBJPROP_READONLY) == true;
    }
    bool isSelectable() {
        return ObjectGet(name, OBJPROP_SELECTABLE) == true;
    }
    bool isRay() {
        return ObjectGet(name, OBJPROP_RAY) == true;
    }
    long getColor() {
        return ObjectGetInteger(chartId, name, OBJPROP_COLOR);
    }
    long getTime1() {
        return ObjectGetInteger(chartId, name, OBJPROP_TIME1);
    }
    long getTime2() {
        return ObjectGetInteger(chartId, name, OBJPROP_TIME2);
    }
    double getPrice1() {
        return ObjectGetDouble(chartId, name, OBJPROP_PRICE1);
    }
    double getPrice2() {
        return ObjectGetDouble(chartId, name, OBJPROP_PRICE2);
    }
    long getStyle() {
        return ObjectGetInteger(chartId, name, OBJPROP_STYLE);
    }
    long getType() {
        return ObjectGetInteger(chartId, name, OBJPROP_TYPE);
    }
    long getThickness() {
        return ObjectGetInteger(chartId, name, OBJPROP_WIDTH);
    }
    long getFontSize() {
        return ObjectGetInteger(chartId, name, OBJPROP_FONTSIZE);
    }
    long getXDistance() {
        return ObjectGetInteger(chartId, name, OBJPROP_XDISTANCE);
    }
    long getYDistance() {
        return ObjectGetInteger(chartId, name, OBJPROP_YDISTANCE);
    }
    long getWidth() {
        return ObjectGetInteger(chartId, name, OBJPROP_XSIZE);
    }
    long getHeight() {
        return ObjectGetInteger(chartId, name, OBJPROP_YSIZE);
    }
    long getZOrder() {
        return ObjectGetInteger(chartId, name, OBJPROP_ZORDER);
    }
    string getName() {
        return name;
    }
    string getFont() {
        return ObjectGetString(chartId, name, OBJPROP_FONT);
    }
};
