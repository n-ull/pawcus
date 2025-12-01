import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/core/components/stats_row.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/features/pet/screen.dart';
import 'package:pawcus/main.dart';
import 'package:pawcus/services/auth_service.dart';

import '../../mocks/mock_firebase_auth.dart';


void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    const testUserEmail = 'test@example.com';
    const testUserPassword = 'password';
    final auth = FirebaseAuthService(auth: TestFirebaseAuth());
    await auth.signUp(testUserEmail, testUserPassword);
    await setupServiceLocator(authService: auth);
  });

  Future<void> loadApp(tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('HomePage renders PetScreen', (tester) async {
    await loadApp(tester);
    expect(find.byType(PetScreen), findsOneWidget);
  });

  testWidgets('PetScreen renders all components', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2000)); // ✅ prevent overflow
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await loadApp(tester);
    final petImage = tester.widget<Image>(find.byType(Image));
    final expBar = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));

    expect(find.byType(Lottie), findsOneWidget);
    expect(find.byType(StatsRow), findsOneWidget);
    expect(petImage.image, isA<AssetImage>());
    expect((petImage.image as AssetImage).assetName, 'assets/pet.png');
    expect(find.textContaining('Lvl. '), findsOneWidget);
    expect(expBar.value, 0);
  });
}
