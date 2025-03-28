import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeConfig {
  static Amplitude amplitude = Amplitude(Configuration(
    apiKey: dotenv.get("AMPLITUDE"),
  ));

  Future<void> init() async {
    await amplitude.isBuilt;

    // Send events to the server
    amplitude.flush();
  }
}
