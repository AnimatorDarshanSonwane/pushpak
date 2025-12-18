// ignore_for_file: avoid_print

class RealtimeService {
  // For Firebase / Supabase / WebSockets later

  void listenToDriverLocation(String driverId, Function(double, double) callback) {
    // Mock realtime listener
    print("Listening to driver: $driverId");
  }

  Future<void> updateUserLocation(double lat, double lng) async {
    print("Updating user location to server...");
  }
}
