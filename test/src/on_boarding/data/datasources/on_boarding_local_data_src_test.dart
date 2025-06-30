import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:clean_arch_examples/src/on_boarding/data/datasources/on_boarding_local_data_src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSrc localDataSrc;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSrc = OnBoardingLocalDataSrcImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      await localDataSrc.cacheFirstTimer();

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
      'Should throw a cacheException when there is an error caching the data',
      () async {
        when(
          () => prefs.setBool(any(), any()),
        ).thenThrow((_) async => Exception());

        /// When testing errors for data source
        /// do not save it in 'result' rather use a 'methodCall'
        final methodCall = localDataSrc.cacheFirstTimer;

        expect(methodCall, throwsA(isA<CacheException>()));
        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(prefs);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'Should call [SharedPreferences] to check if the user is first timer and '
      'return the right response from storage when data exists',
      () async {
        when(() => prefs.getBool(any())).thenReturn(false);

        final result = await localDataSrc.checkIfUserFirstTimer();

        expect(result, false);
        verify(() => prefs.getBool(kFirstTimerKey));
        verifyNoMoreInteractions(prefs);
      },
    );

    test('Should return true if no data in storage', () async {
      when(() => prefs.getBool(any())).thenReturn(null);

      final result = await localDataSrc.checkIfUserFirstTimer();

      expect(result, true);
      verify(() => prefs.getBool(kFirstTimerKey));
      verifyNoMoreInteractions(prefs);
    });

    test('Should throw an [CacheException] when there is an error '
        'retrieving the data', () async {
      when(() => prefs.getBool(any())).thenThrow(Exception());

      final methodCall = localDataSrc.checkIfUserFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => prefs.getBool(kFirstTimerKey));
      verifyNoMoreInteractions(prefs);
    });
  });
}
