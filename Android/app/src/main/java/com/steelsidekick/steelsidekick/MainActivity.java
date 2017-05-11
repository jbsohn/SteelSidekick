package com.steelsidekick.steelsidekick;

import android.content.res.AssetManager;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
//import android.widget.TextView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.sguitar.StdStringVector;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("sguitar");
    }

    protected SGuitarCanvasView guitarCanvasView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        String filesDir = getFilesDir().getAbsolutePath();
        SGuitar.setSystemAndUserPaths(filesDir, filesDir);

        setContentView(R.layout.activity_main);

        copyAssetFolder(getAssets(), "Guitars", filesDir + "/" + "Guitars");
        copyAssetFolder(getAssets(), "Settings", filesDir + "/Settings");
        copyAssetFolder(getAssets(), "Images", filesDir + "/Images");

        setContentView(R.layout.activity_main);
        guitarCanvasView = (SGuitarCanvasView) findViewById(R.id.surfaceView);
    }


    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    public native String stringFromJNI();

    public native void setSGuitarPaths(String test);

    @Override
    protected void onPause() {
        super.onPause();
        guitarCanvasView.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        guitarCanvasView.onResume();
    }

    private static boolean copyAssetFolder(AssetManager assetManager,
                                           String fromAssetPath, String toPath) {
        try {
            String[] files = assetManager.list(fromAssetPath);
            new File(toPath).mkdirs();
            boolean res = true;
            for (String file : files)
                if (hasChildren(assetManager, fromAssetPath + "/" + file)) {
                    res &= copyAssetFolder(assetManager,
                            fromAssetPath + "/" + file,
                            toPath + "/" + file);
                } else {
                    res &= copyAsset(assetManager,
                            fromAssetPath + "/" + file,
                            toPath + "/" + file);
                }
            return res;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static boolean hasChildren(AssetManager assetManager, String path) {
        try {
            if (assetManager.list(path).length > 0){
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }

    private static boolean copyAsset(AssetManager assetManager,
                                     String fromAssetPath, String toPath) {
        InputStream in = null;
        OutputStream out = null;
        try {
            in = assetManager.open(fromAssetPath);
            new File(toPath).createNewFile();
            out = new FileOutputStream(toPath);
            copyFile(in, out);
            in.close();
            in = null;
            out.flush();
            out.close();
            out = null;
            return true;
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static void copyFile(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[1024];
        int read;
        while((read = in.read(buffer)) != -1){
            out.write(buffer, 0, read);
        }
    }
}
