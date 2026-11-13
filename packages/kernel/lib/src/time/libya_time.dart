/// Libya is UTC+2 all year, with no daylight saving. Stores' hours, "today"
/// and every time the apps show are Libya's, whatever zone the phone is
/// set to (a phone set to Cairo's is an hour off in summer), as the
/// backend reads them.
const libyaOffset = Duration(hours: 2);

/// [instant] as Libya's clocks read it: a UTC [DateTime] whose fields
/// (year to second, weekday) are Libya's.
DateTime libyaClock(DateTime instant) => instant.toUtc().add(libyaOffset);

/// The moment Libya's clocks read [year]-[month]-[day] [hour]:[minute],
/// in the phone's time. Out-of-range fields roll over, as [DateTime]'s do.
DateTime libyaTime(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
]) => DateTime.utc(
  year,
  month,
  day,
  hour,
  minute,
).subtract(libyaOffset).toLocal();
