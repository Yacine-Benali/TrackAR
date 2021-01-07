#include <opencv2/opencv.hpp>

#ifdef __ANDROID__
#include <android/log.h>
#endif

// fonction to do print to the console using the printf notation
void print(const char *fmt, ...)
{
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}