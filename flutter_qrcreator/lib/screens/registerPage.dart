import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qrcreator/components/ScreenData.dart';
import 'package:flutter_qrcreator/constants.dart';

class registerPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final TextEditingController _school_name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 3,
                      width: winWidth,
                      color: qrButtonColor,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text("현재 학교를 등록해주세요"),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 400,
                child: RawKeyboardListener(
                  focusNode: _focusNode, // or FocusNode(),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    //validator: (value) => value!.isEmpty ? "학교를 입력해주세요" : null,
                    controller: _school_name,
                    decoration: InputDecoration(
                      hintText: "학교 명",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushNamed(context, "/Home",
                                  arguments: screen_data(
                                      _school_name.text.toString()));
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text("학교를 입력해주세요"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("확인"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text("학교 등록")),
                      SizedBox(
                        width: 80,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: qrCancelButtonColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("뒤로가기"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
