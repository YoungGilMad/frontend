import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class StoryUploadScreen extends StatefulWidget {
  const StoryUploadScreen({Key? key}) : super(key: key);

  @override
  State<StoryUploadScreen> createState() => _StoryUploadScreenState();
}

class _StoryUploadScreenState extends State<StoryUploadScreen> {
  File? _selectedImage;
  final TextEditingController _textController = TextEditingController();
  TextStyle _textStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  Offset _textPosition = const Offset(100, 100);
  bool _isDragging = false;
  Color _textColor = Colors.white;
  double _fontSize = 24;
  bool _isBold = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void _uploadStory() {
    // 스토리 업로드 로직 구현
    // 이미지와 텍스트 정보를 서버에 전송

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리가 업로드되었습니다!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스토리 만들기'),
        actions: [
          if (_selectedImage != null)
            TextButton(
              onPressed: _uploadStory,
              child: const Text('공유하기'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage == null)
              _buildImagePickerButton()
            else
              _buildImageEditor(),

            if (_selectedImage != null)
              _buildTextControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerButton() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 64,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              '갤러리에서 이미지 선택하기',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageEditor() {
    return Stack(
      children: [
        Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (_textController.text.isNotEmpty)
          Positioned(
            left: _textPosition.dx,
            top: _textPosition.dy + 16, // 앱바 높이 고려
            child: GestureDetector(
              onPanStart: (_) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _textPosition = Offset(
                    _textPosition.dx + details.delta.dx,
                    _textPosition.dy + details.delta.dy,
                  );
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _isDragging = false;
                });
              },
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _textController.text,
                  style: _textStyle,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: '텍스트 입력',
              hintText: '스토리에 표시할 텍스트를 입력하세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          Text('텍스트 스타일 설정', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),

          // 텍스트 색상 선택
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (Color color in [
                  Colors.white,
                  Colors.black,
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.pink,
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _textColor = color;
                        _updateTextStyle();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _textColor == color ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 폰트 크기 조절
          Row(
            children: [
              const Text('폰트 크기: '),
              Expanded(
                child: Slider(
                  value: _fontSize,
                  min: 14,
                  max: 48,
                  divisions: 17,
                  label: _fontSize.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                      _updateTextStyle();
                    });
                  },
                ),
              ),
            ],
          ),

          // 굵기 설정
          Row(
            children: [
              const Text('굵게: '),
              Switch(
                value: _isBold,
                onChanged: (value) {
                  setState(() {
                    _isBold = value;
                    _updateTextStyle();
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.refresh),
            label: const Text('다른 이미지 선택하기'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTextStyle() {
    setState(() {
      _textStyle = TextStyle(
        color: _textColor,
        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: _fontSize,
      );
    });
  }
}