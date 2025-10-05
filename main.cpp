#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCursor>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    QGuiApplication::setOverrideCursor(QCursor(Qt::BlankCursor));
    engine.loadFromModule("LauncherUI", "Main");

    return app.exec();
}
