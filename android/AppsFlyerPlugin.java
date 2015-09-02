package com.tealeaf.plugin.plugins;

import com.tealeaf.logger;
import com.tealeaf.plugin.IPlugin;
import java.io.*;
import java.util.Map;
import java.util.HashMap;
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

		AppsFlyerLib.setAppsFlyerKey(devKey);
	}

	public void setUserId(String json) {
		try {
			JSONObject data = new JSONObject(json);
			String userId = data.getString("uid");
			AppsFlyerLib.setAppUserId(userId);
		} catch (JSONException ex) {
			ex.printStackTrace();
		}
		AppsFlyerLib.sendTracking(mContext);
	}

	public void trackPurchase(String json) {
		try {
			JSONObject data = new JSONObject(json);
			String receiptId = data.getString("receipt");
			String productId = data.getString("productId");
			double revenue = data.getDouble("revenue");
			String currency = data.getString("currency");
			Map<String,Object> event = new HashMap<String,Object>();
			event.put("revenue", revenue);
			event.put("productId", productId);
			event.put("receipt", receiptId);
			event.put("currency", currency);
			AppsFlyerLib.trackEvent(mContext, "af_purchase", event);
		} catch (JSONException ex) {
			ex.printStackTrace();
		}
	}

	public void trackEventWithValue(String json) {
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
