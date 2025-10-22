import 'package:flutter_test/flutter_test.dart';
import 'package:pawcus/core/models/app_usage_entry.dart';
import 'package:pawcus/core/services/pet_service.dart';
import '../mocks/fake_app_usage_service.dart';
import '../mocks/fake_permissions_service.dart';

void main() {
  test('checkDailyAppUsage applies penalty on heavy usage', () async {
    // Arrange: create fake heavy usage (3 hours total)
    final heavyEntries = [
      AppUsageEntry(packageName: 'com.example.app1', usageSeconds: 3600),
      AppUsageEntry(packageName: 'com.example.app2', usageSeconds: 3600),
      AppUsageEntry(packageName: 'com.example.app3', usageSeconds: 3600),
    ];

    final appUsage = FakeAppUsageService(heavyEntries);
    final perms = FakePermissionsService(true);
    final service = PetService(appUsage, perms);
    await service.init();

    final before = service.pet.value.petStat;

    // Act
    await service.checkDailyAppUsage();

    // Assert
    final after = service.pet.value.petStat;
    expect(after.happiness, lessThan(before.happiness));
    expect(after.energy, lessThan(before.energy));
  });

  test('checkDailyAppUsage applies reward on light usage', () async {
    // Arrange: create fake light usage (30 minutes total)
    final lightEntries = [
      AppUsageEntry(packageName: 'com.example.app1', usageSeconds: 900),
      AppUsageEntry(packageName: 'com.example.app2', usageSeconds: 900),
    ];

    final appUsage = FakeAppUsageService(lightEntries);
    final perms = FakePermissionsService(true);
    final service = PetService(appUsage, perms);
    await service.init();

    final before = service.pet.value.petStat;

    // Act
    await service.checkDailyAppUsage();

    // Assert
    final after = service.pet.value.petStat;
    expect(after.happiness, greaterThan(before.happiness));
    expect(after.energy, greaterThan(before.energy));
  });

  test('checkDailyAppUsage does nothing when permission denied', () async {
    final entries = [
      AppUsageEntry(packageName: 'com.example.app1', usageSeconds: 3600),
    ];

    final appUsage = FakeAppUsageService(entries);
    final perms = FakePermissionsService(false); // permission denied
    final service = PetService(appUsage, perms);
    await service.init();

    final before = service.pet.value.petStat;

    // Act
    await service.checkDailyAppUsage();

    // Assert - no changes
    final after = service.pet.value.petStat;
    expect(after.happiness, equals(before.happiness));
    expect(after.energy, equals(before.energy));
  });
}
