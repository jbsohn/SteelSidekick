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

import sguitar.FileUtils;
import sguitar.Guitar;
import sguitar.Note;
import sguitar.SG;
import sguitar.SGuitar;
import sguitar.StdStringVector;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("sguitar");
    }

    protected SGuitarCanvasView guitarCanvasView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

//        // Example of a call to a native method
//        TextView tv = (TextView) findViewById(R.id.sample_text);
//        tv.setText(stringFromJNI());
        setContentView(R.layout.activity_main);
        guitarCanvasView = (SGuitarCanvasView) findViewById(R.id.surfaceView);


        setSGuitarPaths(getFilesDir().getAbsolutePath());

        String filesDir = getFilesDir().getAbsolutePath();
        copyAssetFolder(getAssets(), "Guitars", filesDir + "/" + "Guitars");
        copyAssetFolder(getAssets(), "Settings", filesDir + "/Settings");
        copyAssetFolder(getAssets(), "Images", filesDir + "/Images");

        sguitarTests();
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

    protected void sguitarTests() {
        Note note = new Note(SG.NOTE_VALUE_C, 4);
        int value = note.getNoteValue();
        Log.v("TEST", "note=" + value);
        Log.v("TEST", "pitch=" + note.getPitchValue());

        String filesDir = getFilesDir().getAbsolutePath();
        FileUtils.setRootPathForFiles(filesDir);
        FileUtils.setRootPathForUserFiles(filesDir);

        String userFiles = FileUtils.getRootPathForUserFiles();
        Log.v("TEST", "userFiles: " + userFiles);

        String rootPathFiles = FileUtils.getRootPathForFiles();
        Log.v("TEST", "files: " + rootPathFiles);

        StdStringVector files = FileUtils.readFileListFromPath(rootPathFiles + "/" + "Guitars/Pedal Steel");
        for (int i = 0; i < files.size(); i++) {
            Log.v("TEST", "file: " + files.get(i));
        }
        String contents = FileUtils.readFile(rootPathFiles + "/" + "Guitars/Pedal Steel/C6 (10-String)");
        Log.v("TEST", "contents: " + contents);

        SGuitar guitar = SGuitar.sharedInstance();
        StdStringVector chords = guitar.getChordNames();
        for (int i = 0; i < chords.size(); i++) {
            Log.v("TEST", "test: " + chords.get(i));
        }

        StdStringVector scales = guitar.getScaleNames();
        for (int i = 0; i < scales.size(); i++) {
            Log.v("TEST", "scale: " + scales.get(i));
        }

        StdStringVector guitarTypes = guitar.getGuitarTypeNames();
        for (int i = 0; i < guitarTypes.size(); i++) {
            Log.v("TEST", "guitarTypes: " + guitarTypes.get(i));
        }

        StdStringVector pedalTypes = guitar.getGuitarNames("Pedal Steel");
        for (int i = 0; i < pedalTypes.size(); i++) {
            Log.v("TEST", "pedalTypes: " + pedalTypes.get(i));
        }

        StdStringVector lapTypes = guitar.getGuitarNames("Lap Steel");
        for (int i = 0; i < lapTypes.size(); i++) {
            Log.v("TEST", "lapTypes: " + lapTypes.get(i));
        }

        StdStringVector customTypes = guitar.getCustomGuitarNames();
        for (int i = 0; i < customTypes.size(); i++) {
            Log.v("TEST", "customTypes: " + customTypes.get(i));
        }
    }
}
