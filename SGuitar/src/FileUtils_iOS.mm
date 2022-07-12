//
//  FileUtils_iOS.mm
//  SGuitar
//
//  Created by John Sohn on 5/16/16.
//  Copyright © 2016 John Sohn. All rights reserved.
//

#ifdef __APPLE__
#import <Foundation/Foundation.h>
#import "SG/FileUtils.hpp"

namespace SG {
    std::string FileUtils::getRootPathForFiles() {
        NSString *path = [[NSBundle mainBundle] resourcePath];
        return [path UTF8String];
    }

    std::string FileUtils::getRootPathForUserFiles() {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                             inDomains:NSUserDomainMask] lastObject];
        NSString *path = [url path];
        return [path UTF8String];
    }

    std::vector<std::string> FileUtils::readFileListFromPath(std::string pathname) {
        NSError *error;
        NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@(pathname.c_str()) error:&error];
        std::vector<std::string> files;
        
        for (NSString *cur in directoryContents) {
            std::string pathname = [cur UTF8String];
            files.push_back(pathname);
        }
        
        return files;
    }

    bool FileUtils::deleteFile(std::string filename) {
        NSError *error;
        BOOL status = [[NSFileManager defaultManager] removeItemAtPath:@(filename.c_str()) error:&error];
        return status;
    }

    bool FileUtils::copyFile(std::string fromPath, std::string toPath) {
        NSError *error;
        BOOL status = [[NSFileManager defaultManager] copyItemAtPath:@(fromPath.c_str()) toPath:@(toPath.c_str()) error:&error];
        return status;
    }

    bool FileUtils::moveFile(std::string fromPath, std::string toPath) {
        NSError *error;
        BOOL status = [[NSFileManager defaultManager] moveItemAtPath:@(fromPath.c_str()) toPath:@(toPath.c_str()) error:&error];
        return status;
    }

}

#endif
