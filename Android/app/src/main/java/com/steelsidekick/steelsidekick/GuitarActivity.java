package com.steelsidekick.steelsidekick;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Spinner;
import androidx.cardview.widget.CardView;

import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.switchmaterial.SwitchMaterial;
import com.steelsidekick.sguitar.ACCIDENTAL_DISPLAY_TYPE;
import com.steelsidekick.sguitar.SGGuitarOptions;
import com.steelsidekick.sguitar.SGuitar;
import com.steelsidekick.steelsidekick.databinding.ActivityGuitarBinding;

public class GuitarActivity extends AppCompatActivity {

    private ActivityGuitarBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityGuitarBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        SGuitar sguitar = SGuitar.sharedInstance();
        SGGuitarOptions options = sguitar.getGuitarOptions();

        CardView guitarCardView = binding.guitarCardView;
        guitarCardView.setOnClickListener(view -> {
            Intent intent = new Intent(GuitarActivity.this, GuitarSelectActivity.class);
            startActivityForResult(intent, 1);
        });
        TextView guitarNameTextView = findViewById(R.id.guitarNameTextView);
        guitarNameTextView.setText(sguitar.getGuitarOptions().getGuitarName());

        // handle the show all notes on/off switch
        SwitchMaterial showAllNotesSwitch = binding.showAllNotesSwitch;
        showAllNotesSwitch.setChecked(options.getShowAllNotes());
        showAllNotesSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> {
            options.setShowAllNotes(isChecked);
            sguitar.setGuitarOptions(options);
        });

        Spinner showNotesAsSpinner = binding.showNotesAsSpinner;

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

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            String guitarName = data.getStringExtra("guitarName");
            if (guitarName != null) {
                TextView guitarNameTextView = binding.guitarNameTextView;
                guitarNameTextView.setText(guitarName);
            }
        }
    }
}
