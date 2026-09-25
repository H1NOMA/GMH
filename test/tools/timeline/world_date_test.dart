import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/core/utils/ids.dart';
import 'package:gmh/domain/models/entity.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/timeline/timeline.dart';
import 'package:gmh/domain/timeline/world_date.dart';

const _harptos = WorldCalendar(months: [
  (name: 'Hammer', days: 30),
  (name: 'Alturiak', days: 30),
  (name: 'Frostmoon', days: 30),
  (name: 'Deepwinter', days: 30),
  (name: 'Winter', days: 30),
], yearSuffix: 'DR');

void main() {
  WorldDate? p(String s, [WorldCalendar c = WorldCalendar.gregorian]) =>
      parseWorldDate(s, calendar: c);

  group('parseWorldDate', () {
    test('plain years and suffixes', () {
      expect(p('1492'), const WorldDate(1492));
      expect(p('1492 DR'), const WorldDate(1492));
      expect(p('  412  '), const WorldDate(412));
      expect(p(''), isNull);
      expect(p('the long ago'), isNull);
      expect(parseWorldDate(null), isNull);
    });

    test('year words pick the year among other numbers', () {
      expect(p('3rd Age, Year 412'), const WorldDate(412));
      expect(p('Третья эпоха, год 412'), const WorldDate(412));
      expect(p('Jahr 88 der Krone'), const WorldDate(88));
      expect(p('第三纪元 年412'), const WorldDate(412));
    });

    test('before the epoch is negative, in every language', () {
      expect(p('300 BC'), const WorldDate(-300));
      expect(p('300 BCE'), const WorldDate(-300));
      expect(p('300 до н. э.'), const WorldDate(-300));
      expect(p('300 v. Chr.'), const WorldDate(-300));
      expect(p('300 av. J.-C.'), const WorldDate(-300));
      expect(p('公元前300年'), const WorldDate(-300));
      expect(p('-50'), const WorldDate(-50));
    });

    test('numeric formats', () {
      expect(p('1492-03-12'), const WorldDate(1492, 3, 12));
      expect(p('1492-03'), const WorldDate(1492, 3));
      expect(p('12.03.1492'), const WorldDate(1492, 3, 12));
      expect(p('12/03/1492'), const WorldDate(1492, 3, 12));
    });

    test('Gregorian month names in the app languages', () {
      expect(p('12 March 1492'), const WorldDate(1492, 3, 12));
      expect(p('March 12, 1492'), const WorldDate(1492, 3, 12));
      expect(p('12 марта 1492'), const WorldDate(1492, 3, 12));
      expect(p('12. März 1492'), const WorldDate(1492, 3, 12));
      expect(p('12 mars 1492'), const WorldDate(1492, 3, 12));
      expect(p('May 1492'), const WorldDate(1492, 5));
    });

    test('custom calendar months, longest name first', () {
      expect(p('12 Frostmoon 1492 DR', _harptos),
          const WorldDate(1492, 3, 12));
      expect(p('Deepwinter 3, 1490', _harptos), const WorldDate(1490, 4, 3));
      expect(p('Winter 1490', _harptos), const WorldDate(1490, 5));
      // Gregorian names mean nothing in a custom calendar.
      expect(p('12 March 1492', _harptos), const WorldDate(1492));
    });

    test('ordering', () {
      final dates = [
        const WorldDate(1492, 3, 12),
        const WorldDate(-300),
        const WorldDate(1492),
        const WorldDate(1492, 3),
      ]..sort();
      expect(dates, [
        const WorldDate(-300),
        const WorldDate(1492),
        const WorldDate(1492, 3),
        const WorldDate(1492, 3, 12),
      ]);
    });
  });

  group('calendar', () {
    test('round-trips and tolerates garbage', () {
      final back = WorldCalendar.fromData(_harptos.toData());
      expect(back.months.map((m) => m.name), _harptos.months.map((m) => m.name));
      expect(back.yearSuffix, 'DR');
      expect(WorldCalendar.fromData(null).isGregorian, isTrue);
      expect(
          WorldCalendar.fromData({
            'months': [
              {'name': '', 'days': 3},
              42,
            ]
          }).isGregorian,
          isTrue);
      final suffixOnly = WorldCalendar.fromData({'yearSuffix': 'AR'});
      expect(suffixOnly.isGregorian, isTrue);
      expect(suffixOnly.yearSuffix, 'AR');
    });

    test('formatting uses the calendar', () {
      expect(formatWorldDate(const WorldDate(1492, 3, 12), _harptos),
          '12 Frostmoon 1492 DR');
      expect(formatWorldDate(const WorldDate(-300), WorldCalendar.gregorian),
          '-300');
    });
  });

  group('Timeline.build', () {
    var n = 0;
    Entity e(EntityKind kind, String name, [Map<String, Object?> a = const {}]) =>
        Entity(
            id: 'id${n++}',
            worldId: 'w',
            kind: kind,
            name: name,
            attributes: a,
            createdAt: 0,
            updatedAt: 0);

    test('events land in eras by reference or by date', () {
      final ash = e(EntityKind.era, 'Age of Ash',
          {'startDate': '1000', 'endDate': '1400'});
      final salt = e(EntityKind.era, 'Age of Salt', {'startDate': '1401'});
      final lost = e(EntityKind.era, 'Lost Age');
      final timeline = Timeline.build([
        ash,
        salt,
        lost,
        e(EntityKind.event, 'Fall', {'date': 'Year 1200'}),
        e(EntityKind.event, 'Flood', {'date': '1500'}),
        e(EntityKind.event, 'Dawn', {'date': '500'}),
        e(EntityKind.event, 'Rumor', {'era': '$entityRefPrefix${ash.id}'}),
        e(EntityKind.event, 'Myth'),
        e(EntityKind.character, 'Not history', {'date': '1200'}),
      ]);
      expect(timeline.eras.map((x) => x.entity.name),
          ['Age of Ash', 'Age of Salt', 'Lost Age']);
      expect(timeline.eras[0].events.map((x) => x.entity.name),
          ['Fall', 'Rumor']);
      expect(timeline.eras[1].events.map((x) => x.entity.name), ['Flood']);
      expect(timeline.loose.map((x) => x.entity.name), ['Dawn']);
      expect(timeline.undated.map((x) => x.name), ['Myth']);
      expect(timeline.dates, contains(const WorldDate(1500)));
    });

    test('an empty world is empty', () {
      expect(Timeline.build(const []).isEmpty, isTrue);
    });
  });
}
