package com.steelsidekick.steelsidekick

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.steelsidekick.sguitar.SGuitar
import android.os.PersistableBundle
import android.content.Intent
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.ImageButton
import com.steelsidekick.steelsidekick.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {
    companion object {
        // Used to load the 'sguitar' library on application startup.
        init {
            System.loadLibrary("sguitar")
        }
    }

    private var binding: ActivityMainBinding? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(
            layoutInflater
        )
        setContentView(binding?.root)

        binding?.main?.pedal1?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal2?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal3?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal4?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal5?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal6?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal7?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal8?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal9?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }
        binding?.main?.pedal10?.setOnClickListener { view: View -> onClickPedal(view as ImageButton) }

        binding?.main?.leverLKL?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverLKLR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverLKV?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverLKRR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverLKR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverRKL?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverRKLR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverRKV?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverRKRR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }
        binding?.main?.leverRKR?.setOnClickListener { view: View -> onClickLever(view as ImageButton) }

        val filesDir = filesDir.absolutePath
        SGuitar.setSystemAndUserPaths(filesDir, filesDir)
        Util.copyAssetFolder(assets, "Guitars", "$filesDir/Guitars")
        Util.copyAssetFolder(assets, "Settings", "$filesDir/Settings")
        Util.copyAssetFolder(assets, "Images", "$filesDir/Images")
        updateAdjustments()
    }

    override fun onPostCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onPostCreate(savedInstanceState, persistentState)
        updateAdjustments()
    }

    private fun onClickPedal(view: ImageButton) {
        val tag = view.tag as String
        val guitar = SGuitar.sharedInstance()
        val activated = !view.isActivated
        view.isActivated = activated

        if (activated) {
            view.setImageResource(R.drawable.pedalactive)
        } else {
            view.setImageResource(R.drawable.pedal)
        }
        guitar.activateAdjustment(tag, activated)
    }

    private fun onClickLever(button: ImageButton) {
        val tag = button.tag as String
        val guitar = SGuitar.sharedInstance()
        val activated = !button.isActivated
        button.isActivated = activated
        guitar.activateAdjustment(tag, activated)

        if (activated) {
            when (tag) {
                "LKL", "LKLR", "RKL", "RKLR" -> button.setImageResource(R.drawable.leftleveractive)
                "LKV", "RKV" -> button.setImageResource(R.drawable.verticalleveractive)
                "LKR", "LKRR", "RKR", "RKRR" -> button.setImageResource(R.drawable.rightleveractive)
            }
        } else {
            when (tag) {
                "LKL", "LKLR", "LKR", "LKRR", "RKL", "RKLR", "RKR", "RKRR" -> button.setImageResource(R.drawable.lever)
                "LKV", "RKV" -> button.setImageResource(R.drawable.verticallever)
            }
        }
    }

    private fun updateAdjustments() {
        val guitar = SGuitar.sharedInstance()

        for (pedalID in 0..9) {
            val pedalName = SGuitar.getPedalTypeName(pedalID)
            val enabled = guitar.isAdjustmentEnabled(pedalName)
            val view = viewForPedalID(pedalID)
            if (view != null) {
                if (enabled) {
                    view.visibility = View.VISIBLE
                } else {
                    view.visibility = View.INVISIBLE
                }
            }

            title = guitar.guitarOptions.guitarName
        }

        for (leverID in 0..9) {
            val leverName = SGuitar.getLeverTypeName(leverID)
            val enabled = guitar.isAdjustmentEnabled(leverName)
            val view = viewForLeverID(leverID)
            if (view != null) {
                if (enabled) {
                    view.visibility = View.VISIBLE
                } else {
                    view.visibility = View.INVISIBLE
                }
            }
        }
    }

    private fun viewForPedalID(pedalID: Int): View? {
        when (pedalID) {
            0 -> return binding?.main?.pedal1
            1 -> return binding?.main?.pedal2
            2 -> return binding?.main?.pedal3
            3 -> return binding?.main?.pedal4
            4 -> return binding?.main?.pedal5
            5 -> return binding?.main?.pedal6
            6 -> return binding?.main?.pedal7
            7 -> return binding?.main?.pedal8
            8 -> return binding?.main?.pedal9
            9 -> return binding?.main?.pedal10
        }
        return null
    }

    private fun viewForLeverID(leverID: Int): View? {
        when (leverID) {
            0 -> return binding?.main?.leverLKL
            1 -> return binding?.main?.leverLKLR
            2 -> return binding?.main?.leverLKV
            3 -> return binding?.main?.leverLKR
            4 -> return binding?.main?.leverLKRR
            5 -> return binding?.main?.leverRKL
            6 -> return binding?.main?.leverRKLR
            7 -> return binding?.main?.leverRKV
            8 -> return binding?.main?.leverRKR
            9 -> return binding?.main?.leverRKRR
        }
        return null
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        when (item.itemId) {
            R.id.action_scale -> {
                val intent = Intent(this@MainActivity, ScaleActivity::class.java)
                startActivity(intent)
                return true
            }
            R.id.action_chord -> {
                val intent = Intent(this@MainActivity, ChordActivity::class.java)
                startActivity(intent)
                return true
            }
            R.id.action_guitar -> {
                val intent = Intent(this@MainActivity, GuitarActivity::class.java)
                startActivity(intent)
                return true
            }
            else -> return super.onOptionsItemSelected(item)
        }
    }
}