#include <QtGui/QGuiApplication>
#include <qqml.h>
#include "qtquick2applicationviewer.h"
#include "command.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<Command>("Command", 1 , 0 , "Command");
    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/KanoCreator/main.qml"));
    viewer.setTitle("KanoCreator");
    viewer.showExpanded();
    return app.exec();
}
