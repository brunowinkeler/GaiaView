#include "connection/serialportmanager.h"

SerialPortManager::SerialPortManager(QObject* parent)
    : QObject(parent)
{
    connect(&serial, &QSerialPort::readyRead, this, &SerialPortManager::handleReadyRead);
}

QStringList SerialPortManager::availablePorts() const {
    QStringList list;
    for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts()) {
        list << info.portName();
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

void SerialPortManager::sendMessage(const QString& message) {
    if (serial.isOpen()) {
        QByteArray bytes = message.toUtf8();
        serial.write(bytes);
    }
}

void SerialPortManager::sendBytes(const QByteArray& bytes) {
    if (serial.isOpen()) {
        serial.write(bytes);
    }
}

void SerialPortManager::handleReadyRead() {
    QByteArray data = serial.readAll();
    emit bytesReceived(data);
    emit messageReceived(QString::fromUtf8(data));
}
