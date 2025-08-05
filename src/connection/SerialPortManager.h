#pragma once

#include <QObject>
#include <QStringList>
#include <QSerialPort>
#include <QSerialPortInfo>

class SerialPortManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY portsChanged)
public:
    explicit SerialPortManager(QObject *parent = nullptr);

    QStringList availablePorts() const;
    Q_INVOKABLE void refreshPorts();
    Q_INVOKABLE bool openPort(const QString &portName, int baudRate);
    Q_INVOKABLE void closePort();

signals:
    void portsChanged();
    void portOpened(bool success, QString error);

private:
    QSerialPort serial;
};
