import 'dart:io';

import 'package:dating/common/common_widget.dart';
import 'package:dating/constants.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/onBoarding/select_prompt.dart';
import 'package:flutter/material.dart';

class AddPromptScreen extends StatefulWidget {
  const AddPromptScreen({
    Key? key,
    required this.image,
    required this.onDone,
    required this.isFromProfileView,
    this.prompt,
  }) : super(key: key);

  final String image;
  final String? prompt;
  final bool isFromProfileView;
  final Function(String prompt) onDone;

  @override
  State<AddPromptScreen> createState() => _AddPromptScreenState();
}

class _AddPromptScreenState extends State<AddPromptScreen> {
  String propmtText = 'Add a captions here';

  @override
  void initState() {
    super.initState();
    propmtText = widget.prompt == null || widget.prompt == ""
        ? 'Add a caption here'
        : widget.prompt ?? 'Add a caption here';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color:
                isDarkMode(context) ? Colors.white : Color(COLOR_BLUE_BUTTON),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'Add a Caption',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: widget.isFromProfileView
                    ? Image.network(
                        widget.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.image),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Select a caption',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPrompt(
                        onTap: (prompt) {
                          propmtText = prompt;
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    propmtText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  backgroundColor: Color(COLOR_BLUE_BUTTON),
                  textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Color(COLOR_BLUE_BUTTON))),
                ),
                child: Text(
                  propmtText != "Add a caption here" ? 'Save' : 'No Caption',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (propmtText != "Add a caption here") {
                    widget.onDone(propmtText);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              sizedBox20,
              if (propmtText != "Add a caption here")
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0573ac),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
