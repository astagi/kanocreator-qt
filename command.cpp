#include "command.h"
#include  <QProcess>
#include <QDebug>

Command::Command(QObject *parent) :
    QObject(parent)
{
}
QString Command::command() const
{
    return m_command;
}
void Command::setCommand(const QString &command)
{
    m_command = command;
}

QString Command::execute()
{
    if(m_process)
        delete(m_process);
    m_process = new QProcess(this);
    m_process->start(m_command);
    m_process->waitForReadyRead(-1);
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    return output;
}

void Command::executeAsync()
{
    if(m_process)
        delete(m_process);
    m_process = new QProcess(this);
    connect(m_process, SIGNAL(finished(int , QProcess::ExitStatus)), this, SLOT(readStandardOutput()));
    m_process->start(m_command);
}

QString Command::readStandardOutput()
{
    QByteArray bytes = m_process->readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    emit outputReady(output);
    return output;
}
