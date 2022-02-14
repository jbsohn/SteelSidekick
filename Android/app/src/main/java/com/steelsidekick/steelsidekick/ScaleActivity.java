package com.steelsidekick.steelsidekick;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.switchmaterial.SwitchMaterial;
import com.steelsidekick.sguitar.SGScaleOptions;
import com.steelsidekick.sguitar.SGuitar;

import java.util.ArrayList;

import com.steelsidekick.steelsidekick.databinding.ActivityScaleBinding;

public class ScaleActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        com.steelsidekick.steelsidekick.databinding.ActivityScaleBinding binding = ActivityScaleBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SGuitar sguitar = SGuitar.sharedInstance();
        SGScaleOptions options = sguitar.getScaleOptions();

        // handle the scale on/off switch
        SwitchMaterial scaleSwitch = binding.scaleSwitch;
        scaleSwitch.setChecked(options.getShowScale());
        scaleSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            options.setShowScale(isChecked);
            sguitar.setScaleOptions(options);
        });

        // handle the scale selection
        ArrayList<String> scaleNames = Util.stdStringVectorToArrayList(sguitar.getScaleNames());
        Spinner scaleSpinner = binding.scaleSpinner;
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, scaleNames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        scaleSpinner.setAdapter(adapter);

        String selectedScaleName = options.getScaleName();
        int scaleIndex = Util.getIndexInItems(scaleNames, selectedScaleName);
        if (scaleIndex > 0) {
            scaleSpinner.setSelection(scaleIndex);
        }

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

        Spinner rootNoteSpinner = binding.rootNoteSpinner;
        rootNoteSpinner.setSelection(options.getScaleRootNoteValue());
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
