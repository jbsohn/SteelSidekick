package com.steelsidekick.steelsidekick;

import android.content.res.AssetManager;

import com.steelsidekick.sguitar.StdStringVector;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

public class Util {

    public static boolean copyAssetFolder(AssetManager assetManager,
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

    public static boolean copyAsset(AssetManager assetManager,
                                     String fromAssetPath, String toPath) {
        InputStream in;
        OutputStream out;
        try {
            in = assetManager.open(fromAssetPath);
            new File(toPath).createNewFile();
            out = new FileOutputStream(toPath);
            copyFile(in, out);
            in.close();
            out.flush();
            out.close();
            return true;
        } catch(Exception e) {
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

    private static void copyFile(InputStream in, OutputStream out) throws IOException {
        byte[] buffer = new byte[1024];
        int read;
        while((read = in.read(buffer)) != -1){
            out.write(buffer, 0, read);
        }
    }

    public static ArrayList<String> stdStringVectorToArrayList(StdStringVector vector) {
        ArrayList<String> values = new ArrayList<>();
        for (int i = 0; i < vector.size(); i++) {
            values.add(vector.get(i));
        }
        return values;
    }

    public static int getIndexInItems(ArrayList<String> items, String itemName) {
        for (int i = 0; i < items.size(); i++) {
            String item = items.get(i);
            if (item.equals(itemName)) {
                return i;
            }
        }
        return -1;
    }
}
