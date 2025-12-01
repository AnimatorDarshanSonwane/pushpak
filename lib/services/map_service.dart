import '../core/constants.dart';

class MapService {
  Future<String> getRoute(double lat1, double lng1, double lat2, double lng2) async {
    // Later integrate Google Maps / Mapbox Directions API
    print("Fetching route from API using key: ${AppConstants.googleMapsApiKey}");
    
    await Future.delayed(const Duration(seconds: 1));
    return "FAKE_ROUTE_POLYLINE_DATA";
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return "Sample Address for ($lat , $lng)";
  }
}
