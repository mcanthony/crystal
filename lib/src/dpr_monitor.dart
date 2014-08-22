part of crystal;

DprMonitor _gDprMonitor;

/**
 * Monitors the `window.devicePixelRatio` field.
 */
class DprMonitor implements DpiMonitor {
  double _lastRatio;
  StreamController _controller;
  Timer _timer;
  
  Stream<double> get onChange => _controller.stream;
  
  bool get usesUpdateRequests => true;
  
  double get pixelRatio {
    return _lastRatio;
  }
  
  factory DprMonitor() {
    if (_gDprMonitor == null) {
      _gDprMonitor = new DprMonitor._();
    }
    return _gDprMonitor;
  }
  
  DprMonitor._() {
    _lastRatio = window.devicePixelRatio;
    _controller = new StreamController.broadcast(onListen: _onListen,
        onCancel: _onCancel, sync: true);
  }
  
  void requestUpdate() {
    _timerCb(null);
  }
  
  void _onListen() {
    if (_timer == null) {
      _timer = new Timer.periodic(new Duration(milliseconds: 250), _timerCb);
    }
  }
  
  void _onCancel() {
    if (!_controller.hasListener) {
      assert(_timer != null);
      _timer.cancel();
      _timer = null;
    }
  }
  
  void _timerCb(_) {
    double ratio = window.devicePixelRatio;
    if (ratio != _lastRatio) {
      _lastRatio = ratio;
      _controller.add(ratio);
    }
  }
}
