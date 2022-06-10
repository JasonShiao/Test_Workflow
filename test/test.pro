QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = TestQt
CONFIG += c++17

win32 {
    MINGW64_PATH=/mingw64
    message($$(MINGW64_PATH))
    # libxml2, potrace, boost, opencv
    LIBS += -L$$(MINGW64_PATH)/lib
    # resolve __imp_WSAStartup & __imp_WSACleanup undefined issue
    LIBS += -lws2_32
    # resolve WinSock.h already included issue
    DEFINES+=WIN32_LEAN_AND_MEAN
}
macx{
    _BOOST_PATH = "/usr/local/Cellar/boost/1.78.0_1"
    LIBS += -L"/usr/lib"
    LIBS += -L"/usr/local/lib"
    LIBS += -L"/usr/local/opt/libxml2/lib"
    LIBS += -L"/usr/local/opt/opencv/lib"
}
LIBS += -lopencv_core
LIBS += -lopencv_imgproc
# OpenCV from Macport 
LIBS += -lboost_thread-mt
LIBS += -lboost_chrono-mt
message("LIBS:" $$LIBS)

win32 {
    # boost, libxml2, potrace
    INCLUDEPATH += $$(MINGW64_PATH)/include
    INCLUDEPATH += $$(MINGW64_PATH)/include/libxml2
    INCLUDEPATH += $$(MINGW64_PATH)/include/opencv4
}
macx{
    INCLUDEPATH += /usr/local/include
    INCLUDEPATH += /usr/local/opt/libxml2/include/libxml2/
    INCLUDEPATH += /usr/local/opt/opencv/include/opencv4
    INCLUDEPATH += "$${_BOOST_PATH}/include/"
}
message("INCLUDEPATH:" $$INCLUDEPATH)

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp

HEADERS += \
    mainwindow.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
