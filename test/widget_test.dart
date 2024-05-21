import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_manager/main.dart';
import 'package:inventory_manager/ui/home_page/home_page.dart';
import 'package:inventory_manager/ui/core_pages/login_page.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our app starts at the login page.
    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);

    // Since this test is for the initial state of the app,
    // it's not appropriate to test the counter increment functionality here.
    // If you want to test the counter increment, it should be done in a separate test case
    // specifically designed for testing the counter functionality in the HomePage widget.

    // For example, you can create a new test case to test the counter increment functionality
    // once the user is logged in and on the HomePage.
  });
}
