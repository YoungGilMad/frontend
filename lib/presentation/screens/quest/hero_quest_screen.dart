import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class HeroQuestScreen extends StatefulWidget {
  const HeroQuestScreen({super.key});

  @override
  State<HeroQuestScreen> createState() => _HeroQuestScreenState();
}

class _HeroQuestScreenState extends State<HeroQuestScreen> {
  final List<String> _questCategories = ['진행중', '완료', '실패'];
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '히어로 퀘스트',
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Show quest history
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 카테고리 선택 탭
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: List.generate(
                  _questCategories.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 8.0,
                        right: index == _questCategories.length - 1 ? 0 : 8.0,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedCategoryIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[200],
                          foregroundColor: _selectedCategoryIndex == index
                              ? Colors.white
                              : Colors.black87,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
                        child: Text(_questCategories[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 퀘스트 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 10, // TODO: Replace with actual quest count
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text('히어로 퀘스트 ${index + 1}'),
                        subtitle: const Text('퀘스트 설명이 여기에 표시됩니다.'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to quest detail
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new hero quest
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}