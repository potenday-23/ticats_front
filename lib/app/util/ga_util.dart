import 'package:firebase_analytics/firebase_analytics.dart';

class GAUtil {
  Future<void> senGAButtonEvent(int id) async {
    await FirebaseAnalytics.instance.logEvent(name: 'button', parameters: {'id': id});
  }
}
