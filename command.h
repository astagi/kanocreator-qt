#ifndef COMMAND_H
#define COMMAND_H

#include <QObject>
#include <QProcess>

class Command : public QObject
{
    Q_OBJECT

public:
    explicit Command(QObject *parent = 0);

    Q_PROPERTY( QString command READ command WRITE setCommand )

    QString command() const;
    void setCommand(const QString &command);

    Q_INVOKABLE QString execute();
    Q_INVOKABLE void executeAsync();

private:
    QProcess *m_process;
    QString m_command;
private slots:
    QString readStandardOutput();

signals:
    void outputReady(QString output);
};
#endif //COMMAND_H
