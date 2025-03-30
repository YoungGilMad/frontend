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
  Color _selectedColor = Colors.black;
  double _fontSize = 24;
  Offset _textPosition = const Offset(100, 300); // 초기 위치
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _pickImage(); // 앱이 열리면 자동으로 갤러리 열기
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    } else {
      if (mounted) Navigator.pop(context); // 선택하지 않으면 뒤로 가기
    }
  }

  void _uploadStory() {
    if (_selectedImage == null) return;

    widget.onStoryUploaded();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리가 업로드되었습니다!')),
    );

    Navigator.pop(context);
  }

  void _addOrEditText(Offset position, {int? index}) {
    setState(() {
      _textPosition = Offset(position.dx, position.dy - 30); // 키보드 위쪽 배치
      _editingIndex = index;
      _textController.text = index != null ? texts[index].text : "";
      _selectedColor = index != null ? texts[index].color : Colors.black;
      _fontSize = index != null ? texts[index].fontSize : 24;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextControls(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _textController,
                  autofocus: true,
                  style: TextStyle(color: _selectedColor, fontSize: _fontSize),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "텍스트 입력...",
                    hintStyle: TextStyle(color: Colors.black45),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        if (_editingIndex != null) {
                          texts[_editingIndex!] = texts[_editingIndex!].copyWith(
                            text: value,
                            color: _selectedColor,
                            fontSize: _fontSize,
                          );
                        } else {
                          texts.add(StoryText(
                            text: value,
                            color: _selectedColor,
                            fontSize: _fontSize,
                            position: _textPosition,
                          ));
                        }
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('스토리 만들기', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_selectedImage != null)
            TextButton(
              onPressed: _uploadStory,
              child: const Text('공유하기', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: _selectedImage == null
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : GestureDetector(
        onTapUp: (details) {
          _addOrEditText(details.localPosition);
        },
        child: Stack(
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
                  onTap: () => _addOrEditText(texts[i].position, index: i),
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
                    textAlign: TextAlign.center,
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
      ),
    );
  }

  Widget _buildTextControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildColorPicker(),
            const SizedBox(width: 10),
            _buildFontSizeSlider(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    List<Color> colors = [
      Colors.black, Colors.white, Colors.red, Colors.blue,
      Colors.green, Colors.yellow, Colors.orange, Colors.purple, Colors.pink,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors.map((color) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: _selectedColor == color
                    ? Border.all(color: Colors.black, width: 2)
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
      width: 120,
      child: Slider(
        value: _fontSize,
        min: 12,
        max: 48,
        divisions: 8,
        activeColor: Colors.black,
        inactiveColor: Colors.black38,
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
