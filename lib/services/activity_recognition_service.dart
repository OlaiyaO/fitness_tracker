import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class ActivityRecognitionService {
  final FlutterActivityRecognition _activityRecognition =
      FlutterActivityRecognition.instance;
  StreamSubscription<Activity>? _activityStreamSubscription;

  Future<bool> isPermissionGranted() async {
    PermissionRequestResult reqResult;
    reqResult = await _activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      dev.log('Permission is permanently denied.');
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await _activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {
        dev.log('Permission is denied.');
        return false;
      }
    }

    return true;
  }

  void startListening(
      Function(Activity) onActivityReceive, Function(dynamic) onError) {
    _activityStreamSubscription = _activityRecognition.activityStream
        .handleError(onError)
        .listen(onActivityReceive);
  }

  void stopListening() {
    _activityStreamSubscription?.cancel();
  }
}
