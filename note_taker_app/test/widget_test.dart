

import 'package:flutter/material.dart';
import 'package:flutter_notes/app.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
