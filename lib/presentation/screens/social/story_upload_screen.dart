import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class StoryUploadScreen extends StatefulWidget {
  final Function() onStoryUploaded;

  const StoryUploadScreen({super.key, required this.onStoryUploaded});

  @override
  State<StoryUploadScreen> createState() => _StoryUploadScreenState();
}

class _StoryUploadScreenState extends State<StoryUploadScreen> {
  File? _selectedImage;
  final TextEditingController _textController = TextEditingController();
  List<StoryText> texts = [];
  Color _selectedColor = Colors.white;
  double _fontSize = 24;
  Offset _newTextPosition = const Offset(100, 100); // 새 텍스트의 기본 위치

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  void _uploadStory() {
    if (_selectedImage == null) return;

    widget.onStoryUploaded();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리가 업로드되었습니다!')),
    );

    Navigator.pop(context);
  }

  void _addTextAtPosition(Offset position) {
    setState(() {
      _newTextPosition = position;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("텍스트 입력"),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "스토리 텍스트 입력"),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  texts.add(StoryText(
                    text: value,
                    color: _selectedColor,
                    fontSize: _fontSize,
                    position: _newTextPosition,
                  ));
                  _textController.clear();
                });
              }
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _textController.clear();
                Navigator.pop(context);
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    texts.add(StoryText(
                      text: _textController.text,
                      color: _selectedColor,
                      fontSize: _fontSize,
                      position: _newTextPosition,
                    ));
                    _textController.clear();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("추가"),
            ),
          ],
        );
      },
    );
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
      body: GestureDetector(
        onTapUp: (details) {
          _addTextAtPosition(details.localPosition);
        },
        child: Stack(
          children: [
            _selectedImage == null
                ? Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: const Text('이미지 선택'),
              ),
            )
                : Stack(
              children: [
                Positioned.fill(
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].position.dx,
                    top: texts[i].position.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          texts[i] = texts[i].copyWith(
                            position: Offset(
                              texts[i].position.dx + details.delta.dx,
                              texts[i].position.dy + details.delta.dy,
                            ),
                          );
                        });
                      },
                      child: Text(
                        texts[i].text,
                        style: TextStyle(
                          color: texts[i].color,
                          fontSize: texts[i].fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            _buildTextControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _buildColorPicker()),
                const SizedBox(width: 10),
                _buildFontSizeSlider(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    List<Color> colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: colors.map((color) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28, // 원 크기 키움
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: _selectedColor == color
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildFontSizeSlider() {
    return SizedBox(
      width: 100,
      child: Slider(
        value: _fontSize,
        min: 12,
        max: 48,
        divisions: 8,
        activeColor: Colors.white,
        inactiveColor: Colors.white38,
        onChanged: (value) {
          setState(() {
            _fontSize = value;
          });
        },
      ),
    );
  }
}

// **스토리에 추가될 텍스트를 저장하는 클래스**
class StoryText {
  final String text;
  final Color color;
  final double fontSize;
  final Offset position;

  StoryText({
    required this.text,
    required this.color,
    required this.fontSize,
    required this.position,
  });

  StoryText copyWith({String? text, Color? color, double? fontSize, Offset? position}) {
    return StoryText(
      text: text ?? this.text,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      position: position ?? this.position,
    );
  }
}
