import 'package:firebase_analytics/firebase_analytics.dart';

class GAUtil {
  Future<void> sendGAButtonEvent(String name, Map<String, dynamic> parameter) async {
    await FirebaseAnalytics.instance.logEvent(name: name, parameters: parameter);
  }
}
