QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

LIBS += -L"/usr/local/lib/" -lopencv_core
LIBS += -L"/usr/local/lib/" -lopencv_imgproc
# OpenCV from Macport
#LIBS += -L"/opt/local/lib/opencv4/" -lopencv_core
#LIBS += -L"/opt/local/lib/opencv4/" -lopencv_imgproc
LIBS += -L"/usr/local/lib/" -lboost_thread-mt
LIBS += -L"/usr/local/lib/" -lboost_chrono-mt
INCLUDEPATH += /usr/local/include/
INCLUDEPATH += /usr/local/include/opencv4/

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
