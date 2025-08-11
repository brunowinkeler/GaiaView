#pragma once

#include <QObject>
#include <QStringList>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>

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

    Q_INVOKABLE void sendMessage(const QString& message);
    Q_INVOKABLE void sendBytes(const QByteArray& bytes);

signals:
    void portsChanged();
    void portOpened(bool success, QString error);

    void messageReceived(QString message);
    void bytesReceived(QByteArray bytes);

private slots:
    void handleReadyRead();

private:
    QSerialPort serial;
};
