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
#include "SG/FileUtils.h"


namespace SG {
    std::string FileUtils::readFile(std::string filename) {
        std::ifstream t(filename);
        std::stringstream buffer;
        buffer << t.rdbuf();
        return buffer.str();
    }
}
