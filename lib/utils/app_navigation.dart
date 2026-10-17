import 'package:flutter/material.dart';
import 'package:forumcopilot_sdk/forumcopilot_sdk.dart' show globalNavigatorKey;

/// How the module opens a page: one route type, so every page moves the same
/// way (the app theme's page transition, predictive back on Android, the
/// edge swipe on iOS), and Back returns to the page it was opened from.
///
/// Pages used to open two ways. `Get.to` builds a GetPageRoute, which ignores
/// the app's transition theme: a topic opened from Latest faded in over a
/// forum home that stood still, while one opened from Hot, through the
/// Navigator, moved the home aside. And GetX replaced or dropped pages on
/// its own (`Get.off`, `preventDuplicates`). Nothing here replaces a page or
/// clears the stack.
class AppNavigation {
  AppNavigation._();

  /// Opens [page] over the current one. [name] lets `Get.currentRoute`, which
  /// the sign-in prompts still read, see what is on top.
  static Future<T?> push<T>(BuildContext context, Widget page,
          {String? name}) =>
      _push<T>(Navigator.of(context), page, name);

  /// [push] for code with no widget of its own on screen (a tapped push
  /// notification, the sign-in prompt at start-up): the app's one navigator.
  static Future<T?> pushGlobal<T>(Widget page, {String? name}) {
    final navigator = globalNavigatorKey.currentState;
    if (navigator == null) return Future<T?>.value();
    return _push<T>(navigator, page, name);
  }

  /// Opens a form — a composer, an edit page — over the current page, as a
  /// full-screen dialog ([FormPageRoute]): it rises from the bottom and
  /// closes with ✕, where a page slides in from the side with ←.
  static Future<T?> pushForm<T>(BuildContext context, Widget page) =>
      _push<T>(Navigator.of(context), page, null, form: true);

  /// The page last opened here, while it may still be arriving.
  static Route<dynamic>? _arriving;
  static Type? _arrivingType;

  static Future<T?> _push<T>(NavigatorState navigator, Widget page, String? name,
      {bool form = false}) {
    // A second tap on a row, landing while the first one's page is still
    // sliding in, would open the same kind of page twice, and Back would
    // show it again. `Get.to` refused a page of the kind on top; this refuses
    // only one of the same kind still arriving.
    final arriving = _arriving;
    if (arriving != null &&
        _arrivingType == page.runtimeType &&
        arriving.isCurrent &&
        arriving is ModalRoute &&
        arriving.animation?.status == AnimationStatus.forward) {
      return Future<T?>.value();
    }
    final next = form ? FormPageRoute<T>(builder: (_) => page) : route<T>(page, name: name);
    _arriving = next;
    _arrivingType = page.runtimeType;
    return navigator.push<T>(next);
  }

  /// The route every page opens in.
  static MaterialPageRoute<T> route<T>(Widget page, {String? name}) =>
      MaterialPageRoute<T>(
        builder: (_) => page,
        settings: name == null ? null : RouteSettings(name: name),
      );
}

/// The route a form opens in: Material's full-screen dialog.
///
/// It rises from the bottom over the page it was opened from, which stays
/// where it is, and its app bar closes it with ✕ (the AppBar's own leading
/// for a full-screen dialog). Composers used to slide in from the side like
/// any page, with ←, as if they were a step deeper into the forum. On iOS
/// and macOS it is Cupertino's full-screen dialog, which also rises; there,
/// as for any full-screen dialog, the edge swipe does not close it.
class FormPageRoute<T> extends MaterialPageRoute<T> {
  FormPageRoute({required super.builder, super.settings})
      : super(fullscreenDialog: true);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 250);

  // The page underneath stays put, so it has nothing to be told.
  @override
  DelegatedTransitionBuilder? get delegatedTransition => null;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return super.buildTransitions(context, animation, secondaryAnimation, child);
    }
    // Material 3's emphasized easing: in fast and settling, out quickly.
    final curved = CurvedAnimation(
      parent: animation,
      curve: Easing.emphasizedDecelerate,
      reverseCurve: Easing.emphasizedAccelerate,
    );
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(curved),
      child: child,
    );
  }
}

/// Closing the page (or sheet, or dialog) a widget is on, after an await.
extension PopOwnRoute on BuildContext {
  /// Closes this widget's own route with [result], and nothing else.
  ///
  /// By the time a save or a network call answers, the reader may have left
  /// the page already (Back while it was saving) or opened another over it.
  /// A plain `Navigator.pop` then closed the page underneath, or the one on
  /// top: Back seemed to skip a screen.
  void popOwnRoute([Object? result]) {
    if (!mounted) return;
    final route = ModalRoute.of(this);
    if (route == null || !route.isActive) return;
    final navigator = Navigator.of(this);
    if (route.isCurrent) {
      navigator.pop(result);
    } else {
      navigator.removeRoute(route, result);
    }
  }
}
