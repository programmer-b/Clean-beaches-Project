import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_auth_app/firebase_options.dart';

class FirebaseServices {
  Future<void> init() async {
    /// Initialize Firebase
    await Firebase.initializeApp(
      name: 'firebase_auth_app',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    /// Catch errors that happen outside of the Flutter context,
    Isolate.current.addErrorListener(
      RawReceivePort((List<dynamic> pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last as StackTrace,
        );
      }).sendPort,
    );
  }
}
