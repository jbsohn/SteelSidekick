package com.steelsidekick.steelsidekick;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.ArrayList;

class GuitarSelectAdapter extends BaseAdapter {

    private ArrayList<GuitarSelectItem> guitarSelectItems = null;
    private LayoutInflater mInflater;

    public static final int TYPE_HEADER = 0;
    public static final int TYPE_ITEM = 1;

    public GuitarSelectAdapter(Context context, ArrayList<GuitarSelectItem> guitarSelectItems) {
        mInflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        this.guitarSelectItems = guitarSelectItems;
    }

    @Override
    public int getItemViewType(int position) {
        GuitarSelectItem item = guitarSelectItems.get(position);
        if (item.isHeader()) {
            return TYPE_HEADER;
        }
        return TYPE_ITEM;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getCount() {
        return guitarSelectItems.size();
    }

    @Override
    public String getItem(int position) {
        GuitarSelectItem item = guitarSelectItems.get(position);
        return item.getName();
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        GuitarSelectItem item = guitarSelectItems.get(position);

        convertView = mInflater.inflate(R.layout.layout_guitar, null);
        TextView textView = (TextView) convertView.findViewById(R.id.textView);
        textView.setText(item.getName());
        if (item.isHeader()) {
            textView.setTypeface(Typeface.DEFAULT_BOLD);
            textView.setTextIsSelectable(false);
            textView.setAllCaps(true);
        } else {
            textView.setTypeface(Typeface.DEFAULT);
            textView.setTextIsSelectable(false);
            textView.setAllCaps(false);
        }

        return convertView;
    }

}