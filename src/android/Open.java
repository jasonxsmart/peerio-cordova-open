package com.disusered;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.chromium.base.ContentUriUtils;
import org.json.JSONArray;
import org.json.JSONException;

import android.net.Uri;
import android.content.Intent;
import android.support.v4.content.FileProvider;
import android.webkit.MimeTypeMap;
import android.content.ActivityNotFoundException;
import android.os.Build;

import java.io.File;

/**
 * This class starts an activity for an intent to view files
 */
public class Open extends CordovaPlugin {

  public static final String OPEN_ACTION = "open";

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals(OPEN_ACTION)) {
      String path = args.getString(0);
      this.chooseIntent(path, callbackContext);
      return true;
    }
    return false;
  }

  /**
   * Returns the MIME type of the file.
   *
   * @param path
   * @return
   */
  private static String getMimeType(String path) {
    String mimeType = null;

    String extension = MimeTypeMap.getFileExtensionFromUrl(path);
    if (extension != null) {
      MimeTypeMap mime = MimeTypeMap.getSingleton();
      mimeType = mime.getMimeTypeFromExtension(extension);
    }

    System.out.println("Mime type: " + mimeType);

    return mimeType;
  }

  /**
   * Creates an intent for the data of mime type
   *
   * @param path
   * @param callbackContext
   */
  private void chooseIntent(String path, CallbackContext callbackContext) {
    if (path != null && path.length() > 0) {
      try {
        Intent intent = null;
        if(path.startsWith("https://")) {
          intent = new Intent(Intent.ACTION_VIEW, Uri.parse(path));
        } else {
          path = path.replace("file://", "");
          Uri uri =
                  FileProvider.getUriForFile(this.cordova.getActivity().getApplicationContext(),
                          "com.peerio.fileprovider",
                          new File(path));

          String mime = getMimeType(path);
          intent = new Intent(Intent.ACTION_VIEW);

          intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
          if (Build.VERSION.SDK_INT > 15) {
            intent.setDataAndTypeAndNormalize(uri, mime); // API Level 16 -> Android 4.1
          } else {
            intent.setDataAndType(uri, mime);
          }
        }
        cordova.getActivity().startActivity(intent);

        callbackContext.success();
      } catch (ActivityNotFoundException e) {
        e.printStackTrace();
        callbackContext.error(1);
      }
    } else {
      callbackContext.error(2);
    }
  }
}

