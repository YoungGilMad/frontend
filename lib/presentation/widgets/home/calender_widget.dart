import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Todo {
  final String title;
  final String category;
  bool isCompleted;

  Todo({
    required this.title,
    required this.category,
    this.isCompleted = false,
  });
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  // Sample todo data
  final Map<DateTime, List<Todo>> _todos = {
    DateTime(2025, 2, 9): [
      Todo(title: '토익 영어 단어 암기', category: '학습'),
      Todo(title: '양파, 사과, 배, 참기름', category: '장보기'),
    ],
    DateTime(2025, 2, 10): [
      Todo(title: '영어 문법 공부', category: '학습'),
      Todo(title: '운동하기', category: '건강'),
    ],
    DateTime(2025, 2, 11): [
      Todo(title: '영어 문법 공부', category: '학습'),
      Todo(title: '운동하기', category: '건강'),
      Todo(title: '밥먹기', category: '건강'),
      Todo(title: '산책하기', category: '건강'),
    ],
    DateTime(2025, 2, 12): [
      Todo(title: '영어 문법 공부', category: '학습'),
      Todo(title: '운동하기', category: '건강'),
      Todo(title: '밥먹기', category: '건강'),
      Todo(title: '산책하기', category: '건강'),
      Todo(title: '영양제 먹기', category: '건강'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    initializeDateFormatting('ko_KR', null);
  }

  List<Todo> _getEventsForDay(DateTime day) {
    return _todos[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, 1, 1);
    final lastDay = DateTime(now.year, 12, 31);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          // Calendar section
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TableCalendar(
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: _focusedDay,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (isSameDay(_selectedDay, selectedDay)) {
                    _selectedDay = null;
                  } else {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  }
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Colors.blue.shade300,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
                markerDecoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              locale: 'ko_KR',
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  final todos = _getEventsForDay(date);
                  return Container(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (todos.isNotEmpty)
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.2 + (todos.length.clamp(1, 5) - 1) * 0.15),
                            ),
                          ),
                        Text(
                          '${date.day}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
                selectedBuilder: (context, date, _) {
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade300,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, date, _) {
                  final todos = _getEventsForDay(date);
                  return Container(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (todos.isNotEmpty)
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.2 + (todos.length.clamp(1, 5) - 1) * 0.15),
                            ),
                          ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Date header (always visible)
          if (_selectedDay != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${_selectedDay!.month}월 ${_selectedDay!.day}일',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Todos with AnimatedContainer
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _selectedDay != null ? (_getEventsForDay(_selectedDay!).length * 80.0) : 0,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                child: Column(
                  children: _selectedDay != null
                      ? _getEventsForDay(_selectedDay!).map((todo) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )).toList()
                      : [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}