package com.moengage.react;

import android.content.Context;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.moe.pushlibrary.MoEHelper;
import com.moe.pushlibrary.models.GeoLocation;
import com.moengage.core.Logger;
import org.json.JSONObject;

/**
 * @author Umang Chamaria
 */

public class MoEReactBridge extends ReactContextBaseJavaModule {
  Context mContext;

  public MoEReactBridge(ReactApplicationContext reactContext) {
    super(reactContext);
    mContext = reactContext.getApplicationContext();
  }

  @Override public String getName() {
    return "MoEReactBridge";
  }

  @ReactMethod public void isExistingUser(boolean existingUser) {
    MoEHelper.getInstance(mContext).setExistingUser(existingUser);
  }

  @ReactMethod public void trackEvent(String eventName, ReadableMap attributes) {
    JSONObject attributesJSON = new JSONObject();
    try {
      if (attributes != null) {
        ReadableMapKeySetIterator keySetIterator = attributes.keySetIterator();
        do {
          String key = keySetIterator.nextKey();
          switch (attributes.getType(key)) {
            case String:
              attributesJSON.put(key, attributes.getString(key));
              break;
            case Number:
              attributesJSON.put(key, attributes.getDouble(key));
              break;
            case Boolean:
              attributesJSON.put(key, attributes.getBoolean(key));
              break;
          }
        } while (keySetIterator.hasNextKey());
        MoEHelper.getInstance(mContext).trackEvent(eventName, attributesJSON);
      } else {
        MoEHelper.getInstance(mContext).trackEvent(eventName);
      }
    } catch (Exception e) {
      Logger.e("MoEReactBridge:trackEvent ", e);
    }
  }

  @ReactMethod public void setUserAttribute(ReadableMap userAttributeMap) {
    try {
      if (userAttributeMap != null) {
        String userAttributeName = userAttributeMap.getString("AttributeName");
        switch (userAttributeMap.getType("AttributeValue")) {
          case String:
            MoEHelper.getInstance(mContext)
                .setUserAttribute(userAttributeName, userAttributeMap.getString("AttributeValue"));
            break;
          case Number:
            MoEHelper.getInstance(mContext)
                .setUserAttribute(userAttributeName, userAttributeMap.getDouble("AttributeValue"));
            break;
          case Boolean:
            MoEHelper.getInstance(mContext)
                .setUserAttribute(userAttributeName, userAttributeMap.getBoolean("AttributeValue"));
            break;
        }
      }
    } catch (Exception e) {
      Logger.e("MoEReactBridge:setUserAttribute Exception", e);
    }
  }

  @ReactMethod public void logout() {
    MoEHelper.getInstance(mContext).logoutUser();
  }

  @ReactMethod public void setLogLevel(int logLevel) {
    MoEHelper.getInstance(mContext).setLogLevel(logLevel);
  }

  @ReactMethod public void setUserAttributeLocation(ReadableMap userAttributeLocation) {
    String attributeName = "";
    try {
      if (userAttributeLocation != null) {
        if (userAttributeLocation.hasKey("AttributeName")) {
          attributeName = userAttributeLocation.getString("AttributeName");
        }
        double latValue = userAttributeLocation.getDouble("LatVal");
        double longValue = userAttributeLocation.getDouble("LngVal");
        MoEHelper.getInstance(mContext)
            .setUserAttribute(attributeName, new GeoLocation(latValue, longValue));
      }
    } catch (Exception e) {
      Logger.e("MoEReactBridge:setUserAttributeLocation Exception", e);
    }
  }
}
