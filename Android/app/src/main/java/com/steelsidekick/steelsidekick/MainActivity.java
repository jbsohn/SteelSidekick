package com.steelsidekick.steelsidekick;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.steelsidekick.databinding.ActivityMainBinding;

import java.util.Objects;

public class MainActivity extends AppCompatActivity {

    // Used to load the 'sguitar' library on application startup.
    static {
        System.loadLibrary("sguitar");
    }

    private ActivityMainBinding binding;

//    private String leverNames[] = new String[] {
//            "LKL",
//            "LKLR",
//            "LKV",
//            "LKR",
//            "LKRR",
//            "RKL",
//            "RKLR",
//            "RKV",
//            "RKR",
//            "RKRR"
//    };
//
//    private String pedalNames[] = new String[] {
//            "P1",
//            "P2",
//            "P3",
//            "P4",
//            "P5",
//            "P6",
//            "P7",
//            "P8",
//            "P9",
//            "P10"
//    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        binding.main.pedal1.setOnClickListener(this::onClickPedal);
        binding.main.pedal2.setOnClickListener(this::onClickPedal);
        binding.main.pedal3.setOnClickListener(this::onClickPedal);
        binding.main.pedal4.setOnClickListener(this::onClickPedal);
        binding.main.pedal5.setOnClickListener(this::onClickPedal);
        binding.main.pedal6.setOnClickListener(this::onClickPedal);
        binding.main.pedal7.setOnClickListener(this::onClickPedal);
        binding.main.pedal8.setOnClickListener(this::onClickPedal);
        binding.main.pedal9.setOnClickListener(this::onClickPedal);
        binding.main.pedal10.setOnClickListener(this::onClickPedal);

        binding.main.leverLKL.setOnClickListener(this::onClickLever);
        binding.main.leverLKLR.setOnClickListener(this::onClickLever);
        binding.main.leverLKV.setOnClickListener(this::onClickLever);
        binding.main.leverLKRR.setOnClickListener(this::onClickLever);
        binding.main.leverLKR.setOnClickListener(this::onClickLever);
        binding.main.leverRKL.setOnClickListener(this::onClickLever);
        binding.main.leverRKLR.setOnClickListener(this::onClickLever);
        binding.main.leverRKV.setOnClickListener(this::onClickLever);
        binding.main.leverRKRR.setOnClickListener(this::onClickLever);
        binding.main.leverRKR.setOnClickListener(this::onClickLever);

        String filesDir = getFilesDir().getAbsolutePath();
        SGuitar.setSystemAndUserPaths(filesDir, filesDir);
        Util.copyAssetFolder(getAssets(), "Guitars", filesDir + "/" + "Guitars");
        Util.copyAssetFolder(getAssets(), "Settings", filesDir + "/Settings");
        Util.copyAssetFolder(getAssets(), "Images", filesDir + "/Images");

        updateAdjustments();
    }

    @Override
    public void onPostCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onPostCreate(savedInstanceState, persistentState);
        Log.i("", "updateAdjustments");
        updateAdjustments();
    }

    private void onClickPedal(View view) {
        String tag = (String) view.getTag();
        SGuitar guitar = SGuitar.sharedInstance();

        boolean activated = !view.isActivated();
        view.setActivated(activated);
        if (activated) {
            view.setBackgroundResource(R.drawable.pedalactive);
        } else {
            view.setBackgroundResource(R.drawable.pedal);
        }
        guitar.activateAdjustment(tag, activated);
    }

    private void onClickLever(View view) {
        String tag = (String) view.getTag();
        SGuitar guitar = SGuitar.sharedInstance();

        boolean activated = !view.isActivated();
        view.setActivated(activated);
        guitar.activateAdjustment(tag, activated);

        if (activated) {
            switch (tag) {
                case "LKL":
                case "RKL":
                    view.setBackgroundResource(R.drawable.leftleveractive);
                    break;
                case "LKV":
                case "RKV":
                    view.setBackgroundResource(R.drawable.verticalleveractive);
                    break;
                case "LKR":
                case "RKR":
                    view.setBackgroundResource(R.drawable.rightleveractive);
                    break;
            }
        } else {
            switch (tag) {
                case "LKL":
                case "LKR":
                case "RKL":
                case "RKR":
                    view.setBackgroundResource(R.drawable.lever);
                    break;
                case "LKV":
                case "RKV":
                    view.setBackgroundResource(R.drawable.verticallever);
                    break;
            }
        }
    }

    private void updateAdjustments() {
        SGuitar guitar = SGuitar.sharedInstance();

        for (int pedalID = 0; pedalID <= 9; pedalID++) {
            String pedalName = SGuitar.getPedalTypeName(pedalID);
            boolean enabled = guitar.isAdjustmentEnabled(pedalName);
            View view = viewForPedalID(pedalID);
            if (view != null) {
                if (enabled) {
                    view.setVisibility(View.VISIBLE);
                } else {
                    view.setVisibility(View.INVISIBLE);
                }
            }
        }

        for (int leverID = 0; leverID <= 9; leverID++) {
            String leverName = SGuitar.getLeverTypeName(leverID);
            boolean enabled = guitar.isAdjustmentEnabled(leverName);
            View view = viewForLeverID(leverID);
            if (view != null) {
                if (enabled) {
                    view.setVisibility(View.VISIBLE);
                } else {
                    view.setVisibility(View.INVISIBLE);
                }
            }
        }
    }

    private View viewForPedalID(int pedalID) {
        switch (pedalID) {
            case 0:
                return binding.main.pedal1;
            case 1:
                return binding.main.pedal2;
            case 2:
                return binding.main.pedal3;
            case 3:
                return binding.main.pedal4;
            case 4:
                return binding.main.pedal5;
            case 5:
                return binding.main.pedal6;
            case 6:
                return binding.main.pedal7;
            case 7:
                return binding.main.pedal8;
            case 8:
                return binding.main.pedal9;
            case 9:
                return binding.main.pedal10;
        }
        return null;
    }

    private View viewForLeverID(int leverID) {
        switch (leverID) {
            case 0:
                return binding.main.leverLKL;
            case 1:
                return binding.main.leverLKLR;
            case 2:
                return binding.main.leverLKV;
            case 3:
                return binding.main.leverLKR;
            case 4:
                return binding.main.leverLKRR;
            case 5:
                return binding.main.leverRKL;
            case 6:
                return binding.main.leverRKLR;
            case 7:
                return binding.main.leverRKV;
            case 8:
                return binding.main.leverRKR;
            case 9:
                return binding.main.leverRKRR;
        }
        return null;
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