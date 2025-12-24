import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> networkStatusStream() async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
