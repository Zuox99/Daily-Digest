import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:dailydigest/theme/global.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  TextStyle buttonText = new TextStyle(fontSize: 25, color: Colors.white);

  String input = "0";
  var left = 0;
  var right = 0;
  String output = "0";
  String expression = "";
  String error = "";

  static const MAX_INPUT = 26;

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.black87,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        title: Text("Calculator", style: appbarText),
      ),
      body: Container(
        margin: EdgeInsets.only(top: h * 0.1),
        child: Column(
          children: <Widget>[
            inputBox(),
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
            outputBox(),
            keyboard(),
          ]
        ),
      ),
    );
  }

  Widget inputBox() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.05),
      child: Text(
        input,
        overflow: TextOverflow.clip,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget outputBox() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.05),
      child: Text(
        output,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget keyboard() {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: h * 0.006, horizontal: w * 0.01),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              button("AC", Colors.orange),
              button("(", Colors.orange),
              button(")", Colors.orange),
              button("/", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              button("7", Colors.black54),
              button("8", Colors.black54),
              button("9", Colors.black54),
              button("*", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              button("4", Colors.black54),
              button("5", Colors.black54),
              button("6", Colors.black54),
              button("-", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              button("1", Colors.black54),
              button("2", Colors.black54),
              button("3", Colors.black54),
              button("+", Colors.orange),
            ],
          ),
          Row(
            children: <Widget>[
              button(".", Colors.black54),
              button("0", Colors.black54),
              button("DEL", Colors.black54),
              button("=", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget button(String text, Color color) {
    return new Expanded(
        child: FlatButton(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid
            )
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            text,
            style: buttonText,
          ),
          onPressed: () {
            inputProcess(text);
            if(this.error.length != 0) {
              print(error);
              _showMyDialog();
            }
            error = "";
          }
        )
    );
  }

  Future _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text('Invalid input'),
        );
      },
    );
  }

  inputProcess(String input) {

    int len = expression.length;
    String lastInput = len > 0 ? expression[len - 1] : "";
    bool notAdd = false;

    if(input == "AC") {
      clear();
    }

    else if(input == "DEL") {
      del(len);
    }

    else if(input == "=") {
      getResult();
    }

    else {
      if(len == MAX_INPUT) return;

      if(isOperator(input)) {
        //don't add operator at the first position and after "(" or "."
        if(len == 0 || lastInput == "(" || lastInput == ".") {
          notAdd = true;
        }

        //if last current input are both operators, replace last one with current one
        //like: if last one is * and current one is +: ...8* -> ...8+
        if(isOperator(lastInput)) {
          expression = expression.substring(0, expression.length - 1);
        }
      }

      else if(input == "(") {
        left++;   //count number of "("

        if(lastInput == ".") {
          left--;
          notAdd = true;
        }

        //Automatically add * before "(", if last one is number or ")"
        //like: 7(9 + 1) -> 7 * (9 + 1), (7 + 1)(9 + 1) -> (7 + 1) * (9 + 1)
        if(lastInput != null && (double.tryParse(lastInput) != null || lastInput == ")")) {
          expression += "*";
        }
      }

      else if(input == ")") {
        //When number of "(" <= number of ")" or last input is operator or "(", don't add ")"
        if(len == 0 || left <= right|| (isOperator(lastInput) || lastInput == "(" || lastInput == ".")) {
          notAdd = true;
        } else {
          right++;    //count number of "("
        }
      }

      //conditions that can't add "."
      else if(input == "." && (len == 0 || isOperator(lastInput) || lastInput == "(" || lastInput == ")" || lastInput == ".")) {
        notAdd = true;
      }

      expression = notAdd ? expression : expression + input;
    }

    //update context in the input box
    setState(() {
      this.input = this.expression.length == 0 ? "0" : this.expression;
    });

  }

  clear() {
    setState(() {
      expression = "";
      right = 0;
      left = 0;
      output = "0";
    });
  }

  del(var len) {
    if(len > 0) {
      if(expression[len - 1] == "(") {
        left--;
      }
      if(expression[len - 1] == ")") {
        right--;
      }
    }
    expression = len > 0 ? expression.substring(0, len - 1) : "";
  }

  getResult() {

    //Automatically match ")" with "("
    if(left > right) {
      int diff = left - right;
      while(diff-- > 0) {
        expression += ")";
        right++;
      }
    }

    try{
      Parser p = new Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        this.output = eval.toString();

      });
//      print('Expression: $exp');
//      print('Evaluated expression: $eval\n  (with context: $cm)');
    } catch(e) {
      setState(() {
        this.error = e.toString();
      });
    }
  }

  bool isOperator(String input) {
    if(input == "+" || input == "-" || input == "*" || input == "/") {
      return true;
    }
    return false;
  }
}
