import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';
import '../../widgets/quest/quest_list_widget.dart';

class DailyQuestScreen extends StatefulWidget {
  const DailyQuestScreen({super.key});

  @override
  State<DailyQuestScreen> createState() => _DailyQuestScreenState();
}

class _DailyQuestScreenState extends State<DailyQuestScreen> {
  final List<QuestItem> _quests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Daily Quest',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddQuestDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 퀘스트',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: QuestListWidget(
                  quests: _quests,
                  onQuestTap: _editQuest,
                  onQuestComplete: _completeQuest,
                  onQuestDelete: _deleteQuest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddQuestDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    String selectedDifficulty = 'easy';
    DateTime? selectedDeadline;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 퀘스트 추가'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '퀘스트 제목을 입력하세요',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: '설명',
                  hintText: '퀘스트 설명을 입력하세요',
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => DropdownButtonFormField<String>(
                  value: selectedDifficulty,
                  items: ['easy', 'medium', 'hard']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '난이도',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('마감 시간'),
                subtitle: Text(
                  selectedDeadline?.toString() ?? '설정되지 않음',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDateTimePicker(context);
                  if (mounted && picked != null) {  // mounted 체크 추가
                    setState(() {
                      selectedDeadline = picked;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isEmpty) return;
              Navigator.pop(context, {
                'title': titleController.text,
                'description': descController.text,
                'difficulty': selectedDifficulty,
                'deadline': selectedDeadline,
              });
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );

    if (mounted && result != null) {  // mounted 체크 추가
      setState(() {
        _quests.add(QuestItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: result['title'],
          description: result['description'],
          difficulty: result['difficulty'],
          deadline: result['deadline'],
          createdAt: DateTime.now(),
        ));
      });
    }
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    if (!mounted) return null;
    
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted || date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return null;

    return DateTime(
      date.year,
      date.month, 
      date.day,
      time.hour,
      time.minute,
    );
  }

  void _editQuest(QuestItem quest) {
    // TODO: Implement quest editing
  }

  void _completeQuest(QuestItem quest) {
    setState(() {
      final index = _quests.indexWhere((q) => q.id == quest.id);
      if (index != -1) {
        _quests.removeAt(index);
      }
    });
  }

  void _deleteQuest(QuestItem quest) {
    setState(() {
      _quests.removeWhere((q) => q.id == quest.id);
    });
  }
}