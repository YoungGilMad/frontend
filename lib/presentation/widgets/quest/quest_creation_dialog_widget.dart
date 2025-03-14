import 'package:flutter/material.dart';
import 'package:app_beh/data/models/quest_item_model.dart';

class QuestCreationDialog extends StatefulWidget {
  final Function(QuestItemModel) onQuestCreated;

  const QuestCreationDialog({super.key, required this.onQuestCreated});

  @override
  _QuestCreationDialogState createState() => _QuestCreationDialogState();
}

class _QuestCreationDialogState extends State<QuestCreationDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<String> tags = [
    '운동 및 스포츠',
    '공부',
    '자기개발',
    '취미',
    '명상 및 스트레칭',
    '기타'
  ];
  String? selectedTag;
  int selectedHours = 1;
  int selectedMinutes = 0;

  @override
  void initState() {
    super.initState();
    selectedTag = tags.first;
  }

  String getDifficulty(int selectedHours) {
    if (selectedHours >= 0 && selectedHours < 2) {
      return 'easy';
    } else if (selectedHours > 1 && selectedHours < 5) {
      return 'medium';
    } else if (selectedHours > 4 && selectedHours < 7) {
      return 'hard';
    } else {
      return 'UNKNOWN';
    }
  }

  void _submitQuest() {
    if (titleController.text.isEmpty) return;

    final newQuest = QuestItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: contentController.text,
      difficulty: getDifficulty(selectedHours),
      deadline: null,
      createdAt: DateTime.now(),
      totalTime: Duration(hours: selectedHours, minutes: selectedMinutes),
    );

    widget.onQuestCreated(newQuest);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '퀘스트 생성',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // 제목 입력
              Text("제목", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: '퀘스트 제목을 입력하세요.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 내용 입력
              Text("내용", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '퀘스트 내용을 입력하세요',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // 목표 시간 설정
              Text('목표 시간', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedHours,
                      decoration: const InputDecoration(
                        labelText: '시간',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(6, (i) => i + 1)
                          .map((h) => DropdownMenuItem(
                        value: h,
                        child: Text('$h시간'),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => selectedHours = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedMinutes,
                      decoration: const InputDecoration(
                        labelText: '분',
                        border: OutlineInputBorder(),
                      ),
                      items: [0, 15, 30, 45]
                          .map((m) => DropdownMenuItem(
                        value: m,
                        child: Text('$m분'),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => selectedMinutes = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 태그 선택
              Text('태그', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedTag,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: tags
                    .map((tag) => DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                ))
                    .toList(),
                onChanged: (value) => setState(() => selectedTag = value),
              ),
              const SizedBox(height: 24),

              // 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                  FilledButton(
                    onPressed: _submitQuest,
                    child: const Text('생성'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}