/**
 * src/android: HijackWebviewLinkClick.java
**/

package no.amphibian.hijackwebviewlinkclick;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

public class HijackWebviewLinkClick extends CordovaPlugin {
    private CallbackContext callback;

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
        if (this.callback) {
            this.callback.success();
        }

        return false;
    }

    private void listen(String listener, CallbackContext callbackContext) {
        try {
            this.callback = callbackContext;
        }

        catch (android.content.ActivityNotFoundException error) {
            callbackContext.error(error.getMessage());
        }
    }

    private void deactivate(String listener) {
        try {
            this.callback = null;
        }

        catch (android.content.ActivityNotFoundException error) {
            callbackContext.error(error.getMessage());
        }
    }
}
