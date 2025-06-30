import 'package:clean_arch_examples/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSrc {
  const OnBoardingLocalDataSrc();

  Future<void> cacheFirstTimer();

  Future<bool> checkIfUserFirstTimer();
}

const kFirstTimerKey = 'first_timer';

class OnBoardingLocalDataSrcImpl extends OnBoardingLocalDataSrc {
  const OnBoardingLocalDataSrcImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _prefs.setBool(kFirstTimerKey, false);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserFirstTimer() async {
    try {
      return _prefs.getBool(kFirstTimerKey) ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
