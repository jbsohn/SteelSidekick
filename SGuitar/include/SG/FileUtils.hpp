//
//  FileUtils.h
//  SGuitar
//
//  Created by John Sohn on 5/16/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifndef __FileUtils_h__
#define __FileUtils_h__

#ifdef __ANDROID__
#include <jni.h>
#include <android/native_activity.h>
#include <android/native_window.h>
#include <android/log.h>
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#endif

#ifdef __cplusplus
#include <string>
#include <vector>

namespace SG {
    //
    // abstracts the file system for the platform
    //
    class FileUtils {
    public:
        static std::string readFile(std::string filename);
        static std::vector<std::string> readFileListFromPath(std::string pathname);
        static std::string getRootPathForFiles();
        static std::string getRootPathForUserFiles();
        static bool deleteFile(std::string filename);
        static bool isExistingFile(std::string filename, std::string path);
#ifdef __ANDROID__
        static void setRootPathForFiles(std::string pathname);
        static void setRootPathForUserFiles(std::string pathname);
    protected:
        static std::string rootPathForFiles;
        static std::string rootPathForUserFiles;
#endif
    };
}
#endif

#endif
