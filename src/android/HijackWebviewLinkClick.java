/**
 * src/android: HijackWebviewLinkClick.java
**/

package no.amphibian.hijackwebviewlinkclick;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class HijackWebviewLinkClick extends CordovaPlugin {
    private CallbackContext callbackContext = null;

    @Override public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("listen")) {
            this.listen(callbackContext);
            return true;
        }

        if (action.equals("deactivate")) {
            this.deactivate(callbackContext);
            return true;
        }

        return false;
    }

    @Override public boolean onOverrideUrlLoading(String url) {
        if (this.callbackContext != null) {
            if (url.startsWith("http:")
            || (url.startsWith("https:"))) {
                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, url);
                pluginResult.setKeepCallback(true);

                this.callbackContext.sendPluginResult(pluginResult);
                return true;
            }
        }

        return false;
    }

    private void listen(CallbackContext callbackContext) {
        try {
            this.callbackContext = callbackContext;
        }

        catch (android.content.ActivityNotFoundException error) {
            callbackContext.error(error.getMessage());
        }
    }

    private void deactivate(CallbackContext callbackContext) {
        try {
            this.callbackContext = null;
            callbackContext.success();
        }

        catch (android.content.ActivityNotFoundException error) {
            callbackContext.error(error.getMessage());
        }
    }
}
