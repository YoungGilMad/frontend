class Quest {
  final String title;
  final bool completed;
  final String? time;
  final String? details;

  Quest({
    required this.title,
    required this.completed,
    this.time,
    this.details,
  });
}

// models/quest.dart
class QuestGenerator {
  final String title;
  final String content;
  final int hours;
  final int minutes;
  final String tag;
  final List<String> days;

  QuestGenerator ({
    required this.title,
    required this.content,
    required this.hours,
    required this.minutes,
    required this.tag,
    required this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'hours': hours,
      'minutes': minutes,
      'tag': tag,
      'days': days,
    };
  }
}