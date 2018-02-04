//
//  readFile.cpp
//  SGuitar
//
//  Created by John Sohn on 5/16/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#include <fstream>
#include <sstream>
#include <dirent.h>
#include "SG/FileUtils.hpp"


namespace SG {
    std::string FileUtils::readFile(std::string filename) {
        std::ifstream t(filename);
        std::stringstream buffer;
        buffer << t.rdbuf();
        return buffer.str();
    }
    
    bool FileUtils::isExistingFile(std::string filename, std::string path) {
        std::vector<std::string> files = readFileListFromPath(path);
        return (std::find(files.begin(), files.end(), filename) != files.end());
    }
}
