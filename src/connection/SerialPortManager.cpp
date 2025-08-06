#include "connection/serialportmanager.h"

SerialPortManager::SerialPortManager(QObject* parent)
    : QObject(parent)
{
    serial.setPortName("COM2");
    serial.setBaudRate(QSerialPort::Baud115200);
    if (serial.open(QIODevice::ReadWrite)) {
        qDebug() << "Opened virtual port!";
    } else {
        qDebug() << "Failed:" << serial.errorString();
    }
}

QStringList SerialPortManager::availablePorts() const {
    QStringList list;
    for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts()) {
        list << info.portName();
        qInfo() << info.portName();
    }

    return list;
}

void SerialPortManager::refreshPorts() {
    emit portsChanged();
}

bool SerialPortManager::openPort(const QString& portName, int baudRate) {
    serial.setPortName(portName);
    serial.setBaudRate(baudRate);
    bool opened = serial.open(QIODevice::ReadWrite);
    emit portOpened(opened, opened ? "" : serial.errorString());
    return opened;
}

void SerialPortManager::closePort() {
    serial.close();
}
