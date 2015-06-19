package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
import java.io.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.appsflyer.AppsFlyerLib;

import android.app.Activity;
import android.content.Intent;
import android.content.Context;
import android.util.Log;
import android.os.Bundle;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

public class AppsFlyerPlugin implements IPlugin {

	private AppsFlyerLib appsFlyer;
	private Activity mActivity;
	private Context mContext;

	public AppsFlyerPlugin() {
	}

	public void onCreateApplication(Context applicationContext) {
		mContext = applicationContext;
	}

	public void onCreate(Activity activity, Bundle savedInstanceState) {
		this.mActivity = activity;

		PackageManager manager = activity.getPackageManager();
		String devKey = "";
		try {
			Bundle meta = manager.getApplicationInfo(activity.getPackageName(), PackageManager.GET_META_DATA).metaData;
			if (meta != null) {
				devKey = meta.get("APPSFLYER_DEV_KEY").toString();
			}
		} catch (Exception e) {
			android.util.Log.d("EXCEPTION", "" + e.getMessage());
		}

		logger.log("{appsFlyer} Initializing from manifest with DevKey=", devKey);

		AppsFlyerLib.setAppsFlyerKey(devKey);

		AppsFlyerLib.sendTracking(mContext);
	}

	public void setUserId(String json) {
           try {
             JSONObject data = new JSONObject(json);
             String userId = data.getString("hc_uid");
             AppsFlyerLib.setAppUserId(userId);
             String id = AppsFlyerLib.getAppUserId();
           } catch (JSONException ex) {
             ex.printStackTrace();
           }
	}
       
        public void trackPurchase(String json) {
           try {
             JSONObject data = new JSONObject(json);
             String revenue = data.getString("revenue");
             String currency = data.getString("currency");
             AppsFlyerLib.setCurrencyCode(currency);
             AppsFlyerLib.sendTrackingWithEvent(mContext, "purchase", revenue);
             logger.log("{{appsflyer}} Sent payment events", revenue, currency);
           } catch (JSONException ex) {
             ex.printStackTrace();
           }
        }
 
        public void trackEventWithValue(String json) {
           logger.log("{{appsflyer}}custom event");
           try {
             JSONObject data = new JSONObject(json);
             String event_name = data.getString("event_name");
             String value = data.getString("value");
             AppsFlyerLib.sendTrackingWithEvent(mContext, event_name, value);
           } catch (JSONException ex) {
             ex.printStackTrace();
           }
        }

	public void onResume() {
	}

	public void onStart() {
	}

	public void onPause() {
	}

	public void onStop() {
	}

	public void onDestroy() {
	}

	public void onNewIntent(Intent intent) {
	}

	public void setInstallReferrer(String referrer) {
	}

	public void onActivityResult(Integer request, Integer result, Intent data) {
	}

	public boolean consumeOnBackPressed() {
		return true;
	}

	public void onBackPressed() {
	}
}
