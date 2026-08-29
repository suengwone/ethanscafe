import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:cafe_app/features/menu/presentation/menu_photo.dart';

import '../../support/localized_app.dart';

Future<void> pumpPhoto(WidgetTester tester, {String? imageUrl}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: testLocale,
      localizationsDelegates: testLocalizationsDelegates,
      supportedLocales: testSupportedLocales,
      home: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: ProductPhoto(
            name: '바닐라 라떼',
            imageUrl: imageUrl,
            fallbackAsset: 'assets/images/menu/espresso.png',
            fallbackIcon: LucideIcons.coffee,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('매장이 올린 사진이 없으면 분류 사진을 쓴다', (tester) async {
    await pumpPhoto(tester);

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
  });

  testWidgets('사진이 오는 동안에도 빈칸을 두지 않는다', (tester) async {
    // 목록에서 칸이 깜빡이면 스크롤이 지저분해진다.
    await pumpPhoto(tester, imageUrl: 'https://example.com/latte.jpg');
    await tester.pump();

    expect(find.byType(Image), findsWidgets);
    final images = tester.widgetList<Image>(find.byType(Image));
    expect(
      images.any((image) => image.image is AssetImage),
      isTrue,
      reason: '사진을 기다리는 동안 분류 사진이 자리를 지켜야 한다',
    );
  });

  testWidgets('자리 크기만큼만 디코딩한다', (tester) async {
    await pumpPhoto(tester, imageUrl: 'https://example.com/latte.jpg');
    await tester.pump();

    final network = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => image.image)
        .whereType<ResizeImage>()
        .toList();

    expect(network, isNotEmpty, reason: 'cacheWidth가 붙어 ResizeImage로 감싸져야 한다');
    // 60논리픽셀 × devicePixelRatio(테스트 기본 3.0)
    expect(network.first.width, 180);
  });
}
