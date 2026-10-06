import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: serviceRoot
  property var shell
  property var barWidgetRegistry
  property var loaders: ({})
  property bool preloaded: false

  QtObject {
    id: fakeBar
    property color foreground: Color.foreground
    property color barForeground: Color.foreground
    property color background: Color.background
    property color urgent: Color.urgent
    property string fontFamily: Style.font.family
    property bool vertical: false
    property int barSize: Style.bar.sizeHorizontal
    property bool foregroundAnimationEnabled: false
    property var shell: serviceRoot.shell
    property string position: "top"
    property var activePopout: null
    property var clickTargets: []

    function showTooltip(item, text) {}
    function hideTooltip(item) {}
    function requestPopout(item, content) {}
    function closePopout() {}
    function releasePopout(item) {}
    function targetBelongsToWindow(target, window) { return false }
  }

  PanelWindow {
    id: anchorWindow
    visible: true
    anchors { top: true; left: true; right: true }
    color: "transparent"
    exclusiveZone: 0
    implicitHeight: 40

    Item {
      id: widgetContainer
      anchors.fill: parent
      opacity: 0.0
      enabled: false
    }
  }

  function getLoader(id) {
    if (loaders[id]) return loaders[id]
    var loader = Qt.createQmlObject('import QtQuick; Loader { active: true; asynchronous: true; anchors.fill: parent }', widgetContainer, "anchor-loader-" + id.replace(/[^a-zA-Z0-9]/g, "_"))

    if (id === "omarchy.menu") {
      loader.source = "file:///usr/share/omarchy/shell/plugins/menu/Menu.qml"
    } else {
      var entry = barWidgetRegistry.widgets[id]
      if (!entry || !entry.component) return null
      loader.sourceComponent = entry.component
    }

    loader.onLoaded.connect(function() {
      if (loader.item) {
        if ("shell" in loader.item) loader.item.shell = shell
        if ("omarchyPath" in loader.item) loader.item.omarchyPath = "/usr/share/omarchy"
        if ("cardTop" in loader.item) loader.item.cardTop = 50
        if ("anchorItem" in loader.item) loader.item.anchorItem = widgetContainer
        if ("bar" in loader.item) loader.item.bar = fakeBar
      }
    })

    loaders[id] = loader
    return loader
  }

  onBarWidgetRegistryChanged: {
    if (preloaded || !barWidgetRegistry) return
    preloaded = true
    var available = barWidgetRegistry.availableIds()
    for (var i = 0; i < available.length; i++) getLoader(available[i])
    getLoader("omarchy.menu")
  }

  IpcHandler {
    target: "anchor.point"
    function toggle(id: string, payload: string): void { 
      var loader = getLoader(id)
      if (!loader) return
      if (loader.item) {
        if (typeof loader.item.toggle === "function") loader.item.toggle(payload)
        else if (typeof loader.item.togglePanel === "function") loader.item.togglePanel(payload)
        else if (typeof loader.item.open === "function") loader.item.opened ? (loader.item.close ? loader.item.close() : null) : loader.item.open(payload)
      } else {
        loader.onLoaded.connect(function() {
          if (typeof loader.item.toggle === "function") loader.item.toggle(payload)
          else if (typeof loader.item.togglePanel === "function") loader.item.togglePanel(payload)
          else if (typeof loader.item.open === "function") loader.item.open(payload)
        })
      }
    }
  }
}
