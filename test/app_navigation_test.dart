import 'package:forumcopilot_flutter/utils/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A page that closes itself when its save answers must close only itself:
/// the reader may have gone Back already, or opened another page over it.
/// A plain `Navigator.pop` then closed the page underneath, or the one on
/// top, and Back seemed to skip a screen.
void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  late BuildContext formContext;

  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      home: const Scaffold(body: Text('Topic')),
    ));
    navigatorKey.currentState!.push(AppNavigation.route<Object?>(
      Builder(builder: (context) {
        formContext = context;
        return const Scaffold(body: Text('Form'));
      }),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('closes its page with the result', (tester) async {
    await openForm(tester);
    formContext.popOwnRoute(true);
    await tester.pumpAndSettle();
    expect(find.text('Form'), findsNothing);
    expect(find.text('Topic'), findsOneWidget);
  });

  testWidgets('after Back has already closed the page, closes nothing',
      (tester) async {
    await openForm(tester);
    final form = formContext;
    navigatorKey.currentState!.pop();
    await tester.pump(); // the page is on its way out, still mounted

    form.popOwnRoute(true);
    await tester.pumpAndSettle();
    expect(find.text('Topic'), findsOneWidget);
  });

  testWidgets('with another page opened over it, closes only its own',
      (tester) async {
    await openForm(tester);
    navigatorKey.currentState!.push(AppNavigation.route<void>(
      const Scaffold(body: Text('Profile')),
    ));
    await tester.pumpAndSettle();

    formContext.popOwnRoute(true);
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);

    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('Form'), findsNothing);
    expect(find.text('Topic'), findsOneWidget);
  });

  testWidgets('the result reaches whoever opened the page', (tester) async {
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      home: const Scaffold(body: Text('Topic')),
    ));
    final opened = navigatorKey.currentState!.push(AppNavigation.route<Object?>(
      Builder(builder: (context) {
        formContext = context;
        return const Scaffold(body: Text('Form'));
      }),
    ));
    await tester.pumpAndSettle();
    navigatorKey.currentState!.push(AppNavigation.route<void>(
      const Scaffold(body: Text('Profile')),
    ));
    await tester.pumpAndSettle();

    formContext.popOwnRoute('saved');
    await tester.pumpAndSettle();
    expect(await opened, 'saved');
  });

  testWidgets('a second tap while the page is arriving opens it once',
      (tester) async {
    late BuildContext listContext;
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      home: Builder(builder: (context) {
        listContext = context;
        return const Scaffold(body: Text('List'));
      }),
    ));
    void tapRow() => AppNavigation.push<void>(
        listContext, const Scaffold(body: Text('Topic page')));

    tapRow();
    await tester.pump(const Duration(milliseconds: 50));
    tapRow();
    await tester.pumpAndSettle();
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('Topic page'), findsNothing);
    expect(find.text('List'), findsOneWidget);

    // Once it has arrived, the same kind of page opens again.
    tapRow();
    await tester.pumpAndSettle();
    tapRow();
    await tester.pumpAndSettle();
    navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text('Topic page'), findsOneWidget);
  });
}
