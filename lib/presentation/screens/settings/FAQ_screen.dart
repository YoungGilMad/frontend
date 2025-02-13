import 'package:flutter/material.dart';
import '../../widgets/common/app_bar_widget.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'FAQ',
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text('자주 묻는 질문 1'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('자주 묻는 질문 1에 대한 답변입니다.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('자주 묻는 질문 2'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('자주 묻는 질문 2에 대한 답변입니다.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}