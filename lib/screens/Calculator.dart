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

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        title: Text("Calculator", style: appbarText),
      ),
      body: Container(
        margin: EdgeInsets.only(top: h * 0.1),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: h * 0.06, horizontal: w * 0.05),
              child: Text(
                input,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              child: Text(
                output,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
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
            ),
          ]
        ),
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

  clear() {
    setState(() {
      expression = "";
      right = 0;
      left = 0;
      output = "0";
    });
  }

  inputProcess(String input) {
    int len = expression.length;
    String lastInput = len > 0 ? expression[len - 1] : "";
    bool notAdd = false;

    if(input == "AC") {
      clear();
    }

    else if(input == "DEL") {
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

    else if(input == "=") {
      if(left > right) {
        int diff = left - right;
        while(diff-- > 0) {
          expression += ")";
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
        print('Expression: $exp');
        print('Evaluated expression: $eval\n  (with context: $cm)');
      } catch(e) {
        setState(() {
          this.error = e.toString();
        });
      }

    } else {
      if(len == 26) return;
      if(isOperator(input)) {
        if(len == 0 || lastInput == "(") {
          notAdd = true;
        }
        if(isOperator(lastInput)) {
          expression = expression.substring(0, expression.length - 1);
        }
      }

      else if(input == "(") {
        left++;
        if(lastInput != null && (double.tryParse(lastInput) != null || lastInput == ")")) {
          expression += "*";
        }
      }

      else if(input == ")") {
        if(len == 0 || left <= right|| (isOperator(lastInput) || lastInput == "(")) {
          notAdd = true;
        } else {
          right++;
        }
      } else if(input == "." && (len == 0 || isOperator(lastInput) || lastInput == "(" || lastInput == ")" || lastInput == ".")) {
        notAdd = true;
      }

      expression = notAdd ? expression : expression + input;
    }

    setState(() {
      this.input = this.expression.length == 0 ? "0" : this.expression;
    });

  }

  bool isOperator(String input) {
    if(input == "+" || input == "-" || input == "*" || input == "/") {
      return true;
    }
    return false;
  }
}
