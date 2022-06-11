import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/database.dart';

class UpdateDataScreen extends StatefulWidget {
  late String data;
  late String userId;
  UpdateDataScreen({
    required this.data,
    required this.userId,
  });

  @override
  State<UpdateDataScreen> createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int textLength = 0;
  late String note;
  TextEditingController _noteController = TextEditingController();
  bool _isProcessing = false;
  late Timestamp tp;
  @override
  void initState() {
    super.initState();
    _noteController.text = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Note',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          right: 10,
          left: 10,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    textLength = val.length;
                  });
                },
                controller: _noteController,
                onSaved: (val) {
                  setState(() {
                    note = val!;
                  });
                },
                validator: (val) {
                  if (val!.length > 60) {
                    return "Length is more than 40.";
                  } else if (val.isEmpty ||
                      val.length == 0 ||
                      val == " " ||
                      val.trim() == "") {
                    return "Enter Valid Note.";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Write a note",
                  prefixIcon: Icon(
                    Icons.note_rounded,
                    color: Colors.grey,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                    letterSpacing: 2,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "$textLength/60",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _isProcessing
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightBlueAccent,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _noteController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.065,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.lightBlueAccent,
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              note = _noteController.text;
                              setState(() {
                                _isProcessing = true;
                              });
                              await Database.updateItem(
                                  description: _noteController.text,
                                  docId: widget.userId);
                              Navigator.of(context).pop();
                              setState(() {
                                _noteController.clear();
                                note = "";
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.065,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Colors.lightBlueAccent,
                            alignment: Alignment.center,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
