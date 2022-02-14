package com.steelsidekick.steelsidekick;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.steelsidekick.sguitar.SGuitar;

import com.steelsidekick.steelsidekick.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'sguitar' library on application startup.
    static {
        System.loadLibrary("sguitar");
    }

    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String filesDir = getFilesDir().getAbsolutePath();
        SGuitar.setSystemAndUserPaths(filesDir, filesDir);
        Util.copyAssetFolder(getAssets(), "Guitars", filesDir + "/" + "Guitars");
        Util.copyAssetFolder(getAssets(), "Settings", filesDir + "/Settings");
        Util.copyAssetFolder(getAssets(), "Images", filesDir + "/Images");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        if (id == R.id.action_scale) {
            Intent intent = new Intent(MainActivity.this, ScaleActivity.class);
            startActivity(intent);
            return true;
        } else if (id == R.id.action_chord) {
            Intent intent = new Intent(MainActivity.this, ChordActivity.class);
            startActivity(intent);
            return true;
        } else if (id == R.id.action_guitar) {
            Intent intent = new Intent(MainActivity.this, GuitarActivity.class);
            startActivity(intent);
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

}