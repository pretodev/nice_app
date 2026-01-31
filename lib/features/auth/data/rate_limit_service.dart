import 'package:shared_preferences/shared_preferences.dart';

class RateLimitService {
  static const String _attemptCountKey = 'otp_attempt_count';
  static const String _requestCountKey = 'otp_request_count';
  static const String _requestTimesKey = 'otp_request_times';
  static const String _lockedUntilKey = 'otp_locked_until';
  
  static const int maxAttempts = 5;
  static const int maxRequestsPerHour = 3;
  static const Duration lockoutDuration = Duration(hours: 1);

  final SharedPreferences _prefs;

  RateLimitService(this._prefs);

  // Attempt tracking (per OTP code)
  int getAttemptCount() {
    return _prefs.getInt(_attemptCountKey) ?? 0;
  }

  Future<void> incrementAttemptCount() async {
    final count = getAttemptCount();
    await _prefs.setInt(_attemptCountKey, count + 1);
  }

  Future<void> resetAttemptCount() async {
    await _prefs.remove(_attemptCountKey);
  }

  bool isAttemptLimitExceeded() {
    return getAttemptCount() >= maxAttempts;
  }

  int getRemainingAttempts() {
    return maxAttempts - getAttemptCount();
  }

  // Request tracking (per hour)
  List<DateTime> getRequestTimes() {
    final times = _prefs.getStringList(_requestTimesKey) ?? [];
    return times.map((t) => DateTime.parse(t)).toList();
  }

  Future<void> addRequestTime() async {
    final times = getRequestTimes();
    times.add(DateTime.now());
    await _prefs.setStringList(
      _requestTimesKey,
      times.map((t) => t.toIso8601String()).toList(),
    );
  }

  Future<void> cleanOldRequests() async {
    final times = getRequestTimes();
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    final recentTimes = times.where((t) => t.isAfter(oneHourAgo)).toList();
    
    if (recentTimes.length != times.length) {
      await _prefs.setStringList(
        _requestTimesKey,
        recentTimes.map((t) => t.toIso8601String()).toList(),
      );
    }
  }

  Future<bool> isRequestLimitExceeded() async {
    await cleanOldRequests();
    final times = getRequestTimes();
    return times.length >= maxRequestsPerHour;
  }

  int getRemainingRequests() {
    final times = getRequestTimes();
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    final recentTimes = times.where((t) => t.isAfter(oneHourAgo)).toList();
    return maxRequestsPerHour - recentTimes.length;
  }

  // Lockout tracking
  Future<void> setLockout() async {
    final lockedUntil = DateTime.now().add(lockoutDuration);
    await _prefs.setString(_lockedUntilKey, lockedUntil.toIso8601String());
  }

  DateTime? getLockedUntil() {
    final lockedUntilStr = _prefs.getString(_lockedUntilKey);
    if (lockedUntilStr == null) return null;
    
    final lockedUntil = DateTime.parse(lockedUntilStr);
    if (lockedUntil.isBefore(DateTime.now())) {
      _prefs.remove(_lockedUntilKey);
      return null;
    }
    return lockedUntil;
  }

  bool isLocked() {
    return getLockedUntil() != null;
  }

  Future<void> clearLockout() async {
    await _prefs.remove(_lockedUntilKey);
  }

  // Reset all rate limiting
  Future<void> resetAll() async {
    await Future.wait([
      resetAttemptCount(),
      _prefs.remove(_requestTimesKey),
      clearLockout(),
    ]);
  }
}
