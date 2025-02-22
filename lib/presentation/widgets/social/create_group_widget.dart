import 'package:flutter/material.dart';

class CreateGroupWidget extends StatefulWidget {
  final Function(String name, String description)? onCreateGroup;

  const CreateGroupWidget({
    super.key,
    this.onCreateGroup,
  });

  @override
  State<CreateGroupWidget> createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onCreateGroup?.call(
        _nameController.text,
        _descriptionController.text,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 스터디 그룹 만들기'),
        actions: [
          TextButton(
            onPressed: _handleSubmit,
            child: const Text('완료'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 그룹 이름 입력
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '그룹 이름',
                hintText: '예: 알고리즘 스터디, TOEIC 900점 도전',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '그룹 이름을 입력해주세요';
                }
                if (value.length < 2) {
                  return '그룹 이름은 2자 이상이어야 합니다';
                }
                return null;
              },
              maxLength: 30,
            ),
            const SizedBox(height: 16),

            // 그룹 설명 입력
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '그룹 설명',
                hintText: '그룹의 목표와 활동 내용을 입력해주세요',
              ),
              maxLines: 3,
              maxLength: 200,
            ),

            const SizedBox(height: 24),

            // 안내 메시지
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text(
                          '그룹 생성 시 주의사항',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• 그룹을 생성하면 자동으로 그룹장이 됩니다\n'
                          '• 그룹 이름과 설명은 나중에 수정할 수 있습니다\n'
                          '• 부적절한 내용이 포함된 경우 그룹이 제한될 수 있습니다',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}