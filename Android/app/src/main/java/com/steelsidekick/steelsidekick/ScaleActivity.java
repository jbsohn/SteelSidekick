package com.steelsidekick.steelsidekick;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.Spinner;
import android.widget.Switch;

import com.steelsidekick.sguitar.SGScaleOptions;
import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.sguitar.StdStringVector;

import java.util.ArrayList;

public class ScaleActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_scale);

        SGuitar sguitar = SGuitar.sharedInstance();
        SGScaleOptions options = sguitar.getScaleOptions();

        // handle the scale on/off switch
        Switch scaleSwitch = (Switch) findViewById(R.id.scaleSwitch);
        scaleSwitch.setChecked(options.getShowScale());
        scaleSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGScaleOptions options = sguitar.getScaleOptions();
                options.setShowScale(isChecked);
                sguitar.setScaleOptions(options);
            }
        });

        // handle the scale selection
        ArrayList<String> scaleNames = Util.stdStringVectorToArrayList(sguitar.getScaleNames());
        Spinner scaleSpinner = (Spinner) findViewById(R.id.scaleSpinner);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, scaleNames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        scaleSpinner.setAdapter(adapter);
        scaleSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String scale = (String) adapterView.getSelectedItem();
                SGuitar sguitar = SGuitar.sharedInstance();
                SGScaleOptions options = sguitar.getScaleOptions();
                options.setScaleName(scale);
                sguitar.setScaleOptions(options);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        Spinner rootNoteSpinner = (Spinner) findViewById(R.id.rootNoteSpinner);
        rootNoteSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGScaleOptions options = sguitar.getScaleOptions();
                options.setScaleRootNoteValue(adapterView.getSelectedItemPosition());
                sguitar.setScaleOptions(options);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }
}
