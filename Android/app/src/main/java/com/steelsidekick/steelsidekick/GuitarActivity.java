package com.steelsidekick.steelsidekick;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.Spinner;
import android.widget.Switch;

import com.steelsidekick.sguitar.ACCIDENTAL_DISPLAY_TYPE;
import com.steelsidekick.sguitar.SGChordOptions;
import com.steelsidekick.sguitar.SGGuitarOptions;
import com.steelsidekick.sguitar.SGuitar;

public class GuitarActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_guitar);

        SGuitar sguitar = SGuitar.sharedInstance();
        SGGuitarOptions options = sguitar.getGuitarOptions();

        // handle the show all notes on/off switch
        Switch showAllNotesSwitch = findViewById(R.id.showAllNotesSwitch);
        showAllNotesSwitch.setChecked(options.getShowAllNotes());
        showAllNotesSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGGuitarOptions options = sguitar.getGuitarOptions();
                options.setShowAllNotes(isChecked);
                sguitar.setGuitarOptions(options);
            }
        });

        Spinner showNotesAsSpinner = findViewById(R.id.showNotesAsSpinner);

        ACCIDENTAL_DISPLAY_TYPE displayType = options.getShowNotesAs();
        showNotesAsSpinner.setSelection(displayType.swigValue());
        showNotesAsSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                SGuitar sguitar = SGuitar.sharedInstance();
                SGGuitarOptions options = sguitar.getGuitarOptions();
                options.setShowNotesAs(ACCIDENTAL_DISPLAY_TYPE.swigToEnum(i));
                sguitar.setGuitarOptions(options);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }
}
