import 'package:flutter/material.dart';

class StudyNavigation {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<T?> push<T>(Widget page) {
    return navigatorKey.currentState!.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> pushReplacement<T>(Widget page) {
    return navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop<T>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  static void popToFirst() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed<T>(routeName, arguments: arguments);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(
      (route) => route.settings.name == routeName,
    );
  }
}
