//+------------------------------------------------------------------+
//|                                                      Hotkeys.mqh |
//|                                           Copyright 2023, Awptic |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Awptic"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "Object.mqh"
#include "../static/var/Hotkeys.mqh"

class Hotkeys {
private:
    int key;
    int ability;

    bool activated;
    
    Object *object;
    
public:

    Hotkeys() {
        Hotkeys::activated = false;
    }

    Hotkeys(int keyValue, int abilityValue) {
        Hotkeys::key = keyValue;
        Hotkeys::ability = abilityValue;
        Hotkeys::activated = false;
    }

    void setKey(int keyValue) {
        Hotkeys::key = keyValue;
    }

    int getKey() {
        return Hotkeys::key;
    }

    void setObject(Object *newObject) {
        Hotkeys::object = newObject;
    }

    void activate(bool status) {
        activated = status;
        if (ability == DRAW_TRENDLINE) {
        
        }
    }

    void setFlat(bool status) {
        object.setFlat(status);
    }

    void setRay(bool status) {
        object.setRay(status);
    }

    void setExtend(bool status) {
        object.setExtend(status);
    }

    void setTrendline(int x1, int x2) {
        
    }
};