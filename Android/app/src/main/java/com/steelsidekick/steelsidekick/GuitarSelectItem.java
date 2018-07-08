package com.steelsidekick.steelsidekick;

public class GuitarSelectItem {
    private String name;
    private String type;
    private boolean isHeader;

    public GuitarSelectItem(String name, String type, boolean isHeader) {
        this.name = name;
        this.type = type;
        this.isHeader = isHeader;
    }

    public boolean isHeader() {
        return isHeader;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }
}
