
class Calculator {
  String screenNum = ''; // the number that appears on the screen
  double num1 = 0; // saving the first number that is chosen by the user
  double num2 = 0; // saving the second number that is chosen by the user
  bool num1Given = false; // this will be true when the full number1 is given
  String op = ''; // saving the operation that is chosen by the user

  String audioText = ''; // speak to text
  bool isRecording = false;
  final int SCREENWIDTH = 8; // number of numbers that can be displayed on the screen

  void buttonsOnClick(dynamic text) {
    switch (text) {
      case 'X':
        mul();
        break;
      case '-':
        sub();
        break;
      case '+':
        add();
        break;
      case '÷':
          div();
        break;
      case 'AC':
        AC();
        break;
      case '%':
          percent();
        break;
      case '=':
        calculate(op);
        op = '=';
        break;

      default:
        // for audio noise
        if(text == "Background"){
          return;
        }
        // stop repeating 000
        if (screenNum == '0'&& text!='.' || op == '=' ) {
          if(op == '='){
            AC();
          }
          screenNum = text;


        }
        else {
          if(( text == '.' && !screenNum.contains('.') ) || text != '.' ){
            screenNum = "$screenNum$text".length > SCREENWIDTH ? screenNum : "$screenNum$text";
            //print(screenNum);

          }

        }
        if (!num1Given) {
          num1 = double.parse(screenNum);
        } else {
          num2 = double.parse(screenNum);
        }
    }
  }


  void calculate(String op) {

    switch (op) {
      case "X":
        num1 = num1 * num2;
        screenNum = formatScreenNum("$num1");
        break;
      case '+':
        num1 = num1 + num2;
        screenNum = formatScreenNum("$num1");
        break;
      case '-':
        num1 = num1 - num2;
        screenNum =  formatScreenNum("$num1");
        break;
      case '÷':
        num1 = num1 / num2;
        screenNum =  formatScreenNum("$num1");
        break;
      case '%': // TODO: delete this %
    }
    // clear num2 to take a new number
    num2 = (op == 'X' || op == '÷') ? 1 : 0;
    // clear op


  }

// write the number in scientifc format
  String formatScreenNum(String number) {
//      print(number);
    if (number.length <= SCREENWIDTH) {
      return number;
    }

    int numOfIntegerDigits = 5;

    if (number.contains("e")) {

      int index_e = number.indexOf("e");
      String integer = number.substring(0, numOfIntegerDigits + 1);
      String expo = number.substring(index_e);
      String format = integer + expo;
      return format;
    }

      List<String> parts = number.split(".");
      String integer = parts[0];
      // if the integer part only has onr digit,
      // we don't need to write it as 'e+'
      if(integer.length == 1){
        return number.substring(0,8);
      }
      int numintegers = integer.length;
    number = number.replaceAll(".", "");

    // the number that will be shown on the screen before .
        String bf_dot = number.substring(0,1);
    // the number that will be shown on the screen after .
        String af_dot = number.substring(1,5);
    // actual number of integer -  the number that will be shown on the screen before
        int digits = numintegers - bf_dot.length;
        String expo = "e+$digits";
        String format = "$bf_dot.$af_dot$expo";
        return format;






  }


  void AC(){
    num1 = 0;
    num2 = 0;
    num1Given = false;
    screenNum = '0';
    op = '';
  }

  void percent(){
    if (!num1Given) {
      num1 = num1 / 100;
      screenNum = '$num1';
    }

    if (num1Given) {
      num2 = num2 / 100;
      screenNum = "$num2";
    }

    // selecting an operator means that the user give his first number
    num1Given = true;
  }


  void add(){
    // after selecting an operator the screen number should be 0
    // to be ready for taking the second number
    if (!num1Given) {
      screenNum = '0';
    }

    if (num1Given) {
      calculate(op);
      screenNum = '0';
    }

    // selecting an operator means that the user give his first number
    num1Given = true;

    op = '+';

  }


  void sub(){
    if (!num1Given) {
      screenNum = '0';
    }

    if (num1Given) {
      calculate(op);
      screenNum = '0';
    }

    // op may contain another operation,
    // i should be done then assign the new operation
    op = '-';
    // selecting an operator means that the user give his first number
    num1Given = true;
  }

  void mul(){
    if (!num1Given) {
      screenNum = '0'; // make it ready for taking the second number
    }


    if (num1Given) {
      // num1Given true means that this case was done more than once
      // number2 is ready
      // do calculation
      calculate(op);
      screenNum = '0';
    }

    // selecting an operator means that the user give his first number
    num1Given = true;
    op = 'X';
  }

  void div(){
    // after selecting an operator the screen number should be 0
    // to be ready for taking the second number
    if (!num1Given) {
      screenNum = '0';
    }

    if (num1Given) {
      calculate(op);
      screenNum = '0';
    }

    // selecting an operator means that the user give his first number
    num1Given = true;

    op = '÷';

  }
}