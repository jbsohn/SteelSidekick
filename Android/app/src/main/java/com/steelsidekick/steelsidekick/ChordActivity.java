package com.steelsidekick.steelsidekick;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.switchmaterial.SwitchMaterial;
import com.steelsidekick.sguitar.SGChordOptions;
import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.steelsidekick.databinding.ActivityChordBinding;

import java.util.ArrayList;

public class ChordActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ActivityChordBinding binding = ActivityChordBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SGuitar sguitar = SGuitar.sharedInstance();
        SGChordOptions options = sguitar.getChordOptions();

        // handle the chord on/off switch
        SwitchMaterial chordSwitch = binding.chordSwitch;
        chordSwitch.setChecked(options.getShowChord());
        chordSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            options.setShowChord(isChecked);
            sguitar.setChordOptions(options);
        });

        // handle the chord selection
        ArrayList<String> chordNames = Util.stdStringVectorToArrayList(sguitar.getChordNames());
        Spinner chordSpinner = binding.chordSpinner;
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, chordNames);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        chordSpinner.setAdapter(adapter);

        String selectedChordName = options.getChordName();
        int scaleIndex = Util.getIndexInItems(chordNames, selectedChordName);
        if (scaleIndex > 0) {
            chordSpinner.setSelection(scaleIndex);
        }
        chordSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String chord = (String) adapterView.getSelectedItem();
                SGuitar sguitar = SGuitar.sharedInstance();
                SGChordOptions options = sguitar.getChordOptions();
                options.setChordName(chord);
                sguitar.setChordOptions(options);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        Spinner rootNoteSpinner = binding.rootNoteSpinner;
        rootNoteSpinner.setSelection(options.getChordRootNoteValue());
        rootNoteSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGChordOptions options = sguitar.getChordOptions();
                options.setChordRootNoteValue(adapterView.getSelectedItemPosition());
                sguitar.setChordOptions(options);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }
}
