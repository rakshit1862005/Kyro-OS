#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _qt_qml_LauncherUI_Main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_StartupOverlay_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_StartupAnim_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_BackgroundAnim_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_WifiTab_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_Customize_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_LauncherUI_sounds_Wifidetail_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/Main.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_Main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/StartupOverlay.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_StartupOverlay_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/StartupAnim.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_StartupAnim_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/BackgroundAnim.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_BackgroundAnim_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/WifiTab.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_WifiTab_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/Customize.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_Customize_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/LauncherUI/sounds/Wifidetail.qml"), &QmlCacheGeneratedCode::_qt_qml_LauncherUI_sounds_Wifidetail_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appLauncherUI)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appLauncherUI))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appLauncherUI)() {
    return 1;
}
