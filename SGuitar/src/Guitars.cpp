//
//  Guitars.cpp
//  SGuitar
//
//  Created by John Sohn on 2/29/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include "SG/Guitars.hpp"
#include "SG/FileUtils.hpp"
#include "JsonBox.h"

namespace SG {
    Guitars::Guitars() {
        guitarsPath = "";
        valid = false;
    }

    Guitars::~Guitars() {
        
    }

    bool Guitars::isValid() const {
        return valid;
    }

    void Guitars::setGuitarsPath(std::string guitarsPath) {
        this->guitarsPath = guitarsPath;
        valid = true;
    }

    std::vector<std::string> Guitars::getGuitarNames(std::string type) const {
        std::string path = guitarsPath + "/" + type;
        std::vector<std::string> guitars = FileUtils::readFileListFromPath(path);
        return guitars;
    }

    GuitarType Guitars::getGuitarType(std::string guitarName, std::vector<GuitarType> types) const {
        GuitarType type;
        for (GuitarType curType : types) {
            std::string curTypeName = curType.getName();
            std::vector<std::string> guitarNames = getGuitarNames(curTypeName);

            for (std::string curGuitarName : guitarNames) {
                if (curGuitarName == guitarName) {
                    type = curType;
                    break;
                }
            }
        }
        return type;
    }
    
    std::string Guitars::guitarFileNameForGuitar(std::string name, std::string type) const {
        std::string path = guitarsPath + "/" + type;
        std::vector<std::string> guitars = FileUtils::readFileListFromPath(path);

        for (std::string curFile : guitars) {
            if (curFile == name) {
                return curFile;
            }
        }
        return "";
    }

    std::vector<std::string> Guitars::getCustomGuitarNames() const {
        std::string root = FileUtils::getRootPathForUserFiles();
        std::string path = root + "/Custom Guitars";
        std::vector<std::string> guitars = FileUtils::readFileListFromPath(path);
        return guitars;
    }

    bool Guitars::isExistingCustomGuitarName(std::string name) const {
        std::string fileName = guitarFileNameForCustomGuitar(name);
        return (fileName.length() > 0);
    }
    
    std::string Guitars::guitarFileNameForCustomGuitar(std::string name) const {
        std::string root = FileUtils::getRootPathForUserFiles();
        std::string path = root + "/Custom Guitars";
        std::vector<std::string> guitars = FileUtils::readFileListFromPath(path);
        
        for (std::string curFile : guitars) {
            if (curFile == name) {
                return curFile;
            }
        }
        return "";
    }
    
    bool Guitars::removeCustomGuitar(std::string name) {
        std::string root = FileUtils::getRootPathForUserFiles();
        std::string filename = root + "/Custom Guitars/" + name;
        return FileUtils::deleteFile(filename);
    }
    
    bool Guitars::addCustomGuitarFromPath(std::string path, std::string name) const {
        std::string root = FileUtils::getRootPathForUserFiles();
        std::string rootPath = root + "/Custom Guitars/" + name;
        
        if (!FileUtils::copyFile(path, rootPath)) {
            return false;
        }
        return true;
    }

    std::string Guitars::pathForGuitar(std::string name, std::string type) const {
        std::string root = guitarsPath;
        std::string typePath = type;
        if (type == "Custom") {
            typePath = "Custom Guitars";
            root = FileUtils::getRootPathForUserFiles();
        }
        std::string path = root + "/" + typePath;
        std::vector<std::string> guitars = FileUtils::readFileListFromPath(path);

        for (std::string curFile : guitars) {
            if (curFile == name) {
                return path + "/" + curFile;
            }
        }
        return "";
    }

    std::vector<GuitarType> Guitars::readGuitarTypes(std::string json) {
        std::vector<GuitarType> types;
        JsonBox::Value root;
        root.loadFromString(json);
        
        if (!root.isNull()) {
            JsonBox::Array rootTypes = root.getArray();
            
            if (!rootTypes.empty()) {
                for (JsonBox::Value curType : rootTypes) {
                    JsonBox::Value typeRoot = curType["type"];
                    std::string type = "";
                    if (typeRoot.isString()) {
                        type = typeRoot.getString();
                    }
                    
                    JsonBox::Value descriptionRoot = curType["type"];
                    std::string description = "";
                    if (descriptionRoot.isString()) {
                        description = typeRoot.getString();
                    }
                    
                    JsonBox::Value isCustomTypeRoot = curType["isCustomType"];
                    bool isCustomType = false;
                    if (isCustomTypeRoot.isBoolean()) {
                        isCustomType = isCustomTypeRoot.getBoolean();
                    }
                    
                    GuitarType newType(type, description, isCustomType);
                    types.push_back(newType);
                }
            }
        }
        
        return types;
    }
}
