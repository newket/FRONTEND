import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeConfig {
  static Amplitude amplitude =
  Amplitude.getInstance(instanceName: "newket");

  Future<void> init() async {
    amplitude.init(dotenv.get("AMPLITUDE"));

    amplitude.trackingSessionEvents(true);
  }
}