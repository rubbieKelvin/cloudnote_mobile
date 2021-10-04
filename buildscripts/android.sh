export ANDROID_NDK_ROOT=/home/rubbiekelvin/Android/Sdk/ndk/21.3.6528147/

main(){
    local BUILD_FOLDER=/home/rubbiekelvin/Projects/CloudNote/mobile/build/android-armeabi-v7a
    mkdir $BUILD_FOLDER
    cd $BUILD_FOLDER

    # create stash
    "/home/rubbiekelvin/Qt/5.15.2/android/bin/qmake" /home/rubbiekelvin/Projects/CloudNote/mobile/cloudnote.pro -spec android-clang CONFIG+=debug CONFIG+=qml_debug ANDROID_ABIS=armeabi-v7a
    "/home/rubbiekelvin/Android/Sdk/ndk/21.3.6528147/prebuilt/linux-x86_64/bin/make" -f $BUILD_FOLDER/Makefile qmake_all
    "/home/rubbiekelvin/Android/Sdk/ndk/21.3.6528147/prebuilt/linux-x86_64/bin/make" -j4
    "/home/rubbiekelvin/Android/Sdk/ndk/21.3.6528147/prebuilt/linux-x86_64/bin/make" INSTALL_ROOT=$BUILD_FOLDER/android-build install
    "/home/rubbiekelvin/Qt/5.15.2/android/bin/qmake" -install qinstall -exe libcloudnote_armeabi-v7a.so $PROJECT_FOLDER/android-build/libs/armeabi-v7a/libcloudnote_armeabi-v7a.so
}

main