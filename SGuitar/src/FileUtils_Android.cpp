//
// Created by John Sohn on 7/29/16.
//

#ifdef __ANDROID__

#include <dirent.h>
#include "SG/FileUtils.h"

namespace SG {
    std::string FileUtils::rootPathForFiles = "";
    std::string FileUtils::rootPathForUserFiles = "";

    std::string FileUtils::getRootPathForFiles() {
        return FileUtils::rootPathForFiles;
    }

    std::string FileUtils::getRootPathForUserFiles() {
        return FileUtils::rootPathForUserFiles;
    }

    std::vector <std::string> FileUtils::readFileListFromPath(std::string path) {
        std::vector <std::string> result;
        dirent* de;
        DIR* dp;
        int errno = 0;
        dp = opendir( path.empty() ? "." : path.c_str() );
        if (dp)
        {
            while (true)
            {
                errno = 0;
                de = readdir( dp );
                if (de == NULL) break;
                result.push_back( std::string( de->d_name ) );
            }
            closedir( dp );
            std::sort( result.begin(), result.end() );
        }
        return result;
    }

    bool FileUtils::deleteFile(std::string filename) {
        return false;
    }

    void FileUtils::setRootPathForFiles(std::string pathname) {
        FileUtils::rootPathForFiles = pathname;
    }

    void FileUtils::setRootPathForUserFiles(std::string pathname) {
        FileUtils::rootPathForUserFiles = pathname;
    }
}

#endif
