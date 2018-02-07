package com.steelsidekick.steelsidekick;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.sguitar.StdStringVector;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by john on 2/4/18.
 */

public class GuitarSelectActivity extends AppCompatActivity {
    private static final String TAG = GuitarSelectActivity.class.getName();
    private ListView mGuitarListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        class Guitar {
            private String guitarName;
            private String guitarType;

            public String getGuitarName() {
                return guitarName;
            }

            public void setGuitarName(String guitarName) {
                this.guitarName = guitarName;
            }


            public String getGuitarType() {
                return guitarType;
            }

            public void setGuitarType(String guitarType) {
                this.guitarType = guitarType;
            }

        }

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_guitar_select);

        mGuitarListView = findViewById(R.id.guitarListView);

        SGuitar sguitar = SGuitar.sharedInstance();

        ArrayList<Guitar> allGuitars = new ArrayList<>();

        ArrayList<String> types = Util.stdStringVectorToArrayList(sguitar.getGuitarTypeNames());
        for (String type : types) {
            ArrayList<String> guitars = Util.stdStringVectorToArrayList(sguitar.getGuitarNames(type));

            for (String guitar : guitars) {
                Guitar newGuitar = new Guitar();
                newGuitar.setGuitarName(guitar);
                newGuitar.setGuitarType(type);

                allGuitars.add(newGuitar);
            }
        }


        String[] listItems = new String[allGuitars.size()];
        for (int i = 0; i < allGuitars.size(); i++) {
            Guitar guitar = allGuitars.get(i);
            listItems[i] = guitar.getGuitarName();
        }

        ArrayAdapter adapter = new ArrayAdapter(this, android.R.layout.simple_list_item_1, listItems);
        mGuitarListView.setAdapter(adapter);
    }

}
