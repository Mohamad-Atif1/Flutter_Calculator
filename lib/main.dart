import 'package:flutter/material.dart';
import 'package:fluttercalc/Calculator.dart';
import 'package:tflite_audio/tflite_audio.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Calculator calculator = Calculator();
  String audioText = ''; // speak to text
  bool isRecording = false;

  @override
  initState() {
    super.initState();
    TfliteAudio.loadModel(
      model: "assets/soundclassifier_with_metadata.tflite",
      label: "assets/labels.txt",
      inputType: "rawAudio",
      isAsset: true,
    );
  }

  void recording() {
    String recognition = '';
    if (!isRecording) {
      setState(() {
        isRecording = true;
      });
      var result = TfliteAudio.startAudioRecognition(
          sampleRate: 44100, bufferSize: 11016);
      result.listen((event) {
        recognition = event["recognitionResult"];
      }).onDone(() {
        setState(() {
          isRecording = false;
          audioText = recognition.split(" ")[1];
          calculator.buttonsOnClick(audioText);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 5),
                  child: Text(
                    (calculator.screenNum == '') ? '0' : calculator.screenNum,
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            symButtons("AC", "(-)", "%", "÷"),
            numButtons("7", "8", "9", "X"),
            numButtons("4", "5", "6", "-"),
            numButtons("1", "2", "3", "+"),
            lastRowBtn("0", ".", "=")
          ],
        ),
      ),
    );
  }

// first Row of the calculator (symbols)
  Widget symButtons(String but1, String but2, String but3, String but4) {
    return Row(children: [
      circleButton(but1, Colors.grey[400], Colors.black),
      recordButton(),
      circleButton(but3, Colors.grey[400], Colors.black),
      circleButton(but4, Colors.orange, Colors.white),
    ]);
  }

  // middle row of the calculator
  Widget numButtons(String but1, String but2, String but3, String but4) {
    return Row(children: [
      circleButton(but1, Colors.grey[900], Colors.white),
      circleButton(but2, Colors.grey[900], Colors.white),
      circleButton(but3, Colors.grey[900], Colors.white),
      circleButton(but4, Colors.orange, Colors.white),
    ]);
  }

// last row of the calculator
  Widget lastRowBtn(String but1, String but2, String but3) {
    return Row(
      children: [
        roundedButton(but1, Colors.grey[900], Colors.white, 2),
        roundedButton(but2, Colors.grey[900], Colors.white, 1),
        roundedButton(but3, Colors.orange, Colors.white, 1),
      ],
    );
  }

  Widget circleButton(
    String text,
    Color? bgcolor,
    Color? focolor,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              calculator.buttonsOnClick(text);
            });
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: bgcolor,
              foregroundColor: focolor,
              padding: const EdgeInsets.all(20)),
          child: Text(
            text,
            style: const TextStyle(fontSize: 39),
          ),
        ),
      ),
    );
  }

  Widget recordButton() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ElevatedButton.icon(
          onPressed: () {
            recording();
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: isRecording ? Colors.red : Colors.grey[400],
              foregroundColor: isRecording ? Colors.white : Colors.red,
              padding: const EdgeInsets.all(20)),
          icon: const Icon(
            Icons.mic,
            size: 40,
          ),
          label: Text(""),
        ),
      ),
    );
  }

  Widget roundedButton(
      String text, Color? bgcolor, Color? focolor, int gravity) {
    return Expanded(
      flex: gravity,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              calculator.buttonsOnClick(text);
            });
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(55)),
              backgroundColor: bgcolor, // Colors.grey[900],
              foregroundColor: focolor, // Colors.white,
              padding: const EdgeInsets.all(20)),
          child: Text(
            text,
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}
