main(){
    local QT_HOME=/home/rubbiekelvin/Qt
    local PROJECT_FOLDER=/home/rubbiekelvin/Projects/CloudNote/mobile
    local BUILD_FOLDER=$PROJECT_FOLDER/build/desktop-linux

    # create build folder if it doesnt exist
    if [[ -e $BUILD_FOLDER ]]; then
        echo "build folder exists"
    else
        echo "creating build folder"
        mkdir $BUILD_FOLDER
    fi

    cd $BUILD_FOLDER

    # see if Makefile exists
    if [[ -e $BUILD_FOLDER/Makefile ]]; then
        echo "Make file exists"
    else
        # create .qmake.stash and Makefile
        "$QT_HOME/5.15.2/gcc_64/bin/qmake" \
            "$PROJECT_FOLDER/cloudnote.pro" \
            -spec linux-g++ CONFIG+=debug CONFIG+=qml_debug \
            && /usr/bin/make qmake_all
    fi

    # make
    "/usr/bin/make" -j4

    # compile resource
    "$QT_HOME/5.15.2/gcc_64/bin/rcc" -name qml $PROJECT_FOLDER/qml.qrc -o qrc_qml.cpp

    # create binary
    g++ \
        -c \
        -pipe \
        -g \
        -std=gnu++11 \
        -Wall \
        -Wextra \
        -D_REENTRANT \
        -fPIC \
        -DQT_QML_DEBUG \
        -DQT_QUICKCONTROLS2_LIB \
        -DQT_QUICK_LIB \
        -DQT_SVG_LIB \
        -DQT_WIDGETS_LIB \
        -DQT_GUI_LIB \
        -DQT_QMLMODELS_LIB \
        -DQT_QML_LIB \
        -DQT_NETWORK_LIB \
        -DQT_CORE_LIB -I../../../mobile -I. -I../../lib/qtstatusbar/src -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtQuickControls2 -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtQuick -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtSvg -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtWidgets -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtGui -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtQmlModels -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtQml -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtNetwork -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/include/QtCore -I. -I/usr/include/libdrm -I/home/rubbiekelvin/Qt/5.15.2/gcc_64/mkspecs/linux-g++ -o qrc_qml.o qrc_qml.cpp

    # ...
    g++ -Wl,-rpath,/home/rubbiekelvin/Qt/5.15.2/gcc_64/lib -Wl,-rpath-link,/home/rubbiekelvin/Qt/5.15.2/gcc_64/lib -o cloudnote statusbar.o statusbar_dummy.o main.o qrc_qml.o moc_statusbar.o   /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5QuickControls2.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Quick.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Svg.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Widgets.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Gui.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5QmlModels.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Qml.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Network.so /home/rubbiekelvin/Qt/5.15.2/gcc_64/lib/libQt5Core.so -lGL -lpthread

    # ...
    ./cloudnote

    cd $PROJECT_FOLDER
}

main