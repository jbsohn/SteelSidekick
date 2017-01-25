#include <jni.h>
#include <string>
#include <android/log.h>

std::string filepath;

extern "C"
jstring
Java_com_steelsidekick_steelsidekick_MainActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

extern "C"
JNIEXPORT void JNICALL
Java_com_steelsidekick_steelsidekick_MainActivity_setSGuitarPaths(JNIEnv *env, jobject instance,
                                                                  jstring test_) {
    const char *test = env->GetStringUTFChars(test_, 0);
    filepath = test;

    __android_log_print(ANDROID_LOG_VERBOSE, "TEST", "filepath: %s", test);

    env->ReleaseStringUTFChars(test_, test);
}

