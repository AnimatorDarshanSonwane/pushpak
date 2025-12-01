import 'package:flutter/foundation.dart';

class HomeViewModel {
  ValueNotifier<int> counter = ValueNotifier<int>(0);

  void incrementCounter() {
    counter.value++;
  }
}
