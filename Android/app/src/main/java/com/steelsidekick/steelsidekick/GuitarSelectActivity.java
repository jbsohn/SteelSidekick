package com.steelsidekick.steelsidekick;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;

import androidx.appcompat.app.AppCompatActivity;

import com.steelsidekick.sguitar.SGGuitarOptions;
import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.steelsidekick.databinding.ActivityGuitarSelectBinding;

import java.util.ArrayList;

/**
 * Created by john on 2/4/18.
 */

public class GuitarSelectActivity extends AppCompatActivity {
    //private static final String TAG = GuitarSelectActivity.class.getName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        com.steelsidekick.steelsidekick.databinding.ActivityGuitarSelectBinding binding = ActivityGuitarSelectBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        ListView mGuitarListView = binding.guitarListView;

        SGuitar sguitar = SGuitar.sharedInstance();

        final ArrayList<GuitarSelectItem> allGuitars = new ArrayList<>();

        ArrayList<String> types = Util.stdStringVectorToArrayList(sguitar.getGuitarTypeNames());
        for (String type : types) {
            ArrayList<String> guitars = Util.stdStringVectorToArrayList(sguitar.getGuitarNames(type));

            GuitarSelectItem header = new GuitarSelectItem(type, type, true);
            allGuitars.add(header);

            for (String guitar : guitars) {
                GuitarSelectItem newGuitar = new GuitarSelectItem(guitar, type, false);
                allGuitars.add(newGuitar);
            }
        }

        GuitarSelectAdapter adapter = new GuitarSelectAdapter(this, allGuitars);
        mGuitarListView.setAdapter(adapter);

        mGuitarListView.setOnItemClickListener((adapterView, view, position, l) -> {
            GuitarSelectItem item = allGuitars.get(position);
            SGGuitarOptions options = sguitar.getGuitarOptions();
            options.setGuitarName(item.getName());
            options.setGuitarType(item.getType());
            sguitar.setGuitarOptions(options);
            sguitar.reloadGuitar();

            Intent resultIntent = new Intent();
            resultIntent.putExtra("guitarName", item.getName());
            setResult(Activity.RESULT_OK, resultIntent);

            finish();
        });
    }

}
