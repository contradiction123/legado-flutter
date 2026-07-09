import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:legado_flutter/main.dart';

void main() {
  testWidgets('App widget can be created', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: LegadoApp()),
    );
    expect(find.byType(LegadoApp), findsOneWidget);
  });
}
