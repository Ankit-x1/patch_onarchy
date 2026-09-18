import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "ankit.gpu"

  property string label: "GPU --"

  function refresh() {
    if (!queryProc.running)
      queryProc.running = true
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: queryProc
    command: ["bash", "-lc", "nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits | head -n1"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var line = String(text || "").trim()
        if (line === "") {
          root.label = "GPU --"
          return
        }
        var parts = line.split(",")
        if (parts.length < 3) {
          root.label = "GPU --"
          return
        }
        var util = String(parts[0]).trim()
        var used = String(parts[1]).trim()
        var total = String(parts[2]).trim()
        root.label = "GPU " + util + "% " + used + "/" + total + "MiB"
      }
    }
    onExited: function(exitCode) {
      if (exitCode !== 0)
        root.label = "GPU --"
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.label
    slotSize: Style.bar.statusSlot
    fontSize: Style.font.caption
    tooltipText: "NVIDIA GPU utilization and VRAM"
    onPressed: {
      if (root.bar)
        root.bar.run("omarchy-launch-floating-terminal-with-presentation nvtop")
    }
  }
}
