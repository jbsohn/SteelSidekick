package com.steelsidekick.steelsidekick;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.Spinner;
import android.widget.Switch;

import com.steelsidekick.sguitar.SGChordOptions;
import com.steelsidekick.sguitar.SGuitar;

import java.util.ArrayList;

public class ChordActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chord);

        SGuitar sguitar = SGuitar.sharedInstance();
        SGChordOptions options = sguitar.getChordOptions();

        // handle the chord on/off switch
        Switch chordSwitch = (Switch) findViewById(R.id.chordSwitch);
        chordSwitch.setChecked(options.getShowChord());
        chordSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGChordOptions options = sguitar.getChordOptions();
                options.setShowChord(isChecked);
                sguitar.setChordOptions(options);
            }
        });

        // handle the chord selection
        ArrayList<String> chordNames = Util.stdStringVectorToArrayList(sguitar.getChordNames());
        Spinner chordSpinner = (Spinner) findViewById(R.id.chordSpinner);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, chordNames);
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

        Spinner rootNoteSpinner = (Spinner) findViewById(R.id.rootNoteSpinner);
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
