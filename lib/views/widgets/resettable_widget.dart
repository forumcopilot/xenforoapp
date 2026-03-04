import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/context/site_context.dart';
import 'package:get/get.dart';

abstract class FCStatefulWidget<T extends StatefulWidget> extends State<T> {
  // Note: userIsLoggedIn should now be accessed through SiteContext
  // This will need to be updated in each widget that uses this mixin
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  void setError(String error) {
    isError.value = true;
    errorMessage.value = error;
  }

  void clearError() {
    isError.value = false;
    errorMessage.value = '';
  }
}

/// A mixin that provides reset functionality for list widgets
mixin FCListStatefulWidget<T extends StatefulWidget> on FCStatefulWidget<T> {
  /// Method to reset the list data and scroll position
  void resetList();

  /// Method to refresh the list data
  Future<void> refreshList();
}

/// A mixin that provides reset functionality for tab widgets
mixin FCTabStatefulWidget<T extends StatefulWidget> on FCStatefulWidget<T> {
  /// Method to reset all tabs and their content
  void resetTab();
}
