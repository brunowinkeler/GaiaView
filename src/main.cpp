#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "connection/SerialPortManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<SerialPortManager>("GaiaView", 1, 0, "SerialPortManager");

    QQmlApplicationEngine engine;
    engine.loadFromModule("GaiaViewApp", "Main");

    return app.exec();
}
