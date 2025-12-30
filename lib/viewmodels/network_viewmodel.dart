import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkViewModel extends ChangeNotifier with WidgetsBindingObserver {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _periodicTimer;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  NetworkViewModel() {
    WidgetsBinding.instance.addObserver(this);
    _initConnectivity();
    checkNow(); // ViewModel create zalyavar lagch check kara
    _periodicTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      checkNow();
    });
  }

  Future<void> _initConnectivity() async {
    try {
      // 🔹 Step 1: Initial check
      final List<ConnectivityResult> initialResults =
          await _connectivity.checkConnectivity();
      _updateConnectionStatus(initialResults);

      // 🔹 Step 2: Listen for future changes
      _subscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          _updateConnectionStatus(results);
        },
        onError: (error) {
          // Optional: Log error if needed
          debugPrint('Connectivity stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize connectivity: $e');
      // Fallback: assume connected or handle gracefully
      _isConnected = true;
      notifyListeners();
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Agar koi bhi interface connected hai (WiFi, Mobile, etc.) → connected
    final bool nowConnected = results.any(
      (result) => result != ConnectivityResult.none,
    );

    // Sirf tab notify karo jab actual change ho → unnecessary rebuilds avoid
    if (_isConnected != nowConnected) {
      _isConnected = nowConnected;
      debugPrint('🌐 Network status changed: $_isConnected');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      notifyListeners(); // 🔥 UI ko turant update karega
    }
  }

  /// Manual refresh (optional - agar kahi se force check karna ho)
  Future<void> checkNow() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Manual check failed: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNow(); // App resume zalyavar network check kara
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }
}