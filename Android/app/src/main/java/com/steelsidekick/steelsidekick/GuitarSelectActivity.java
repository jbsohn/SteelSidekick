package com.steelsidekick.steelsidekick;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.steelsidekick.sguitar.SGGuitarOptions;
import com.steelsidekick.sguitar.SGuitar;

import java.util.ArrayList;

/**
 * Created by john on 2/4/18.
 */

public class GuitarSelectActivity extends AppCompatActivity {
    private static final String TAG = GuitarSelectActivity.class.getName();
    private ListView mGuitarListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_guitar_select);

        mGuitarListView = findViewById(R.id.guitarListView);

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

        mGuitarListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView adapterView, View view, int position, long l) {
            GuitarSelectItem item = allGuitars.get(position);
            SGuitar sguitar = SGuitar.sharedInstance();
            SGGuitarOptions options = sguitar.getGuitarOptions();
            options.setGuitarName(item.getName());
            options.setGuitarType(item.getType());
            sguitar.setGuitarOptions(options);
            sguitar.reloadGuitar();

            Intent resultIntent = new Intent();
            resultIntent.putExtra("guitarName", item.getName());
            setResult(Activity.RESULT_OK, resultIntent);

            finish();
            }
        });
    }

}
