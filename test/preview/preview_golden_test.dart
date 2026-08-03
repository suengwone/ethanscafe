import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cafe_app/features/home/presentation/home_screen.dart';
import 'package:cafe_app/features/points/presentation/points_screen.dart';

Future<void> _loadFont(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) {
    return;
  }
  final bytes = await file.readAsBytes();
  final fontLoader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await fontLoader.load();
}

Future<void> _loadFonts() async {
  await _loadFont('Roboto', '/System/Library/Fonts/AppleSDGothicNeo.ttc');

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    await _loadFont(
      'MaterialIcons',
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
  }
}

void main() {
  setUpAll(() async {
    await _loadFonts();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'points_data': jsonEncode({
        'membershipId': 'MEMBER-12345678',
        'balance': 1250,
        'history': [
          {
            'id': 'h3',
            'type': 'earn',
            'description': '매장 결제',
            'amount': 550,
            'paymentAmount': 5500,
            'createdAt': '2026-08-01T10:30:00.000',
          },
          {
            'id': 'h2',
            'type': 'use',
            'description': '포인트 결제',
            'amount': -500,
            'createdAt': '2026-07-25T14:05:00.000',
          },
          {
            'id': 'h1',
            'type': 'earn',
            'description': '매장 결제',
            'amount': 1200,
            'paymentAmount': 12000,
            'createdAt': '2026-07-20T09:12:00.000',
          },
        ],
      }),
    });
  });

  Future<void> configureView(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('포인트 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PointsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(PointsScreen),
      matchesGoldenFile('../../preview/points_screen.png'),
    );
  });

  testWidgets('홈 화면 스크린샷', (WidgetTester tester) async {
    await configureView(tester);

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('../../preview/home_screen.png'),
    );
  });
}
