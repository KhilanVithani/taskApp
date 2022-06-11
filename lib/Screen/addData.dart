import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/database.dart';

class AddDate extends StatefulWidget {
  const AddDate({Key? key}) : super(key: key);

  @override
  State<AddDate> createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late int textLength = 0;
  late String note;
  TextEditingController _noteController = TextEditingController();
  bool _isProcessing = false;
  late Timestamp tp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create Note',
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
                        Colors.lightBlue,
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
                            color: Colors.lightBlue,
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
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
                                await Database.addItem(
                                    description: _noteController.text,
                                    ts: Timestamp.now(),
                                    isComplete: false);
                                setState(() {
                                  _isProcessing = true;
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.lightBlue,
                                    content: Container(
                                      child: Text(
                                        "Task Created.",
                                        style: TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                setState(() {
                                  _noteController.clear();
                                  note = "";
                                });
                              }
                            },
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width * 0.35,
                              color: Colors.lightBlue,
                              alignment: Alignment.center,
                              child: Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ))
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
