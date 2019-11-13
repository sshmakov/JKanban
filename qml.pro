TEMPLATE = app
TARGET = OpenJiraKanban

QT += qml quick widgets

SOURCES += main.cpp

RESOURCES += qml.qrc

# Default rules for deployment.
include(deployment.pri)
