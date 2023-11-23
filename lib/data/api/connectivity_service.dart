import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      print('Verificando conexão com a internet...');
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print('Status da conexão: ${result.toString()}');
    _connectionStatus = result;
  }

  void startListening() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void stopListening() {
    _connectivitySubscription.cancel();
  }

  ConnectivityResult getConnectionStatus() {
    return _connectionStatus;
  }
}
