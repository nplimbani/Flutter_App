import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Interest Calculator App",
    home: SIForm(),
    theme: ThemeData(
      cursorColor: Colors.red,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
      brightness: Brightness.dark,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  String currentValue = '';
  String _character = '';
  String nv = '';

  @override
  void initState(){
    currentValue = _currencies[0];
  }

  TextEditingController principleValueController = TextEditingController();
  TextEditingController rateValueController = TextEditingController();
  TextEditingController termValueController = TextEditingController();

  String result = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Interest Calculaor"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            getAssetImage(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: const Text('Simple Interest'),
                      leading: Radio(
                        value: "simple",
                        groupValue: _character,
                        onChanged: (String value) {
                          setState(() {
                            _character = value;
                            debugPrint(
                                _character + " is selected...");
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: const Text('Compound Interest'),
                      leading: Radio(
                        value: "compound",
                        groupValue: _character,
                        onChanged: (String value) {
                          setState(() {
                            _character = value;
                            debugPrint(
                              _character + " is selected...");
                            });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 5.0,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                style: textStyle,
                keyboardType: TextInputType.number,
                controller: principleValueController,
                decoration: InputDecoration(
                  labelStyle: textStyle,
                  labelText: "Principal",
                  hintText: "Enter a principal amount e.g. 10000",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                style: textStyle,
                keyboardType: TextInputType.number,
                controller: rateValueController,
                decoration: InputDecoration(
                  labelStyle: textStyle,
                  labelText: "Rate of Interest",
                  hintText: "Enter a rate per year",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      style: textStyle,
                      keyboardType: TextInputType.number,
                      controller: termValueController,
                      decoration: InputDecoration(
                        labelStyle: textStyle,
                        labelText: "Term",
                        hintText: "Enter number of years",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 10.0,
                ),
                Expanded(
                  child: DropdownButton<String>(
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: currentValue,
                    onChanged: (String newValue) {
                      //_setSelectedValue(newValue);
                      this.nv = newValue;
                      setState(() {
                        this.currentValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Calculate",
                        textScaleFactor: 1.75,
                      ),
                      onPressed: () {
                        this.result = _getEffectiveAmount(this.nv);
                        onDialogOpen(context, this.result);
                      }),
                ),
                Container(
                  width: 10.0,
                ),
                Expanded(
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Reset",
                        textScaleFactor: 1.75,
                      ),
                      onPressed: () {
                        _reset();
                      }),
                ),
              ],
            ),
            /*Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                this.result,
                style: textStyle,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void _setSelectedValue(String newValue) {
    setState(() {
      this.currentValue = newValue;
    });
  }

  String _getEffectiveAmount(String currentValue) {
    String newResult;
    double p = double.parse(principleValueController.text);
    double r = double.parse(rateValueController.text);
    double n = double.parse(termValueController.text);

    double netPayableAmount = 0;
    if(_character == "simple") {
      debugPrint("I am counting simple interest..." + p.toString() + ":" + r.toString() + ":" + n.toString());
      netPayableAmount = p + (p * r * n) / 100;
    }

    else if(_character == "compound") {
      debugPrint("I am counting compound interest..." + p.toString() + ":" + r.toString() + ":" + n.toString());
      netPayableAmount = p * pow((1 + (r / 100)),n);
    }

    if(n==1) {
      newResult =
          "After $n year, you will have to pay total amount = $netPayableAmount $currentValue";
      debugPrint(
          "After $n year, you will have to pay total amount = $netPayableAmount $currentValue");
    }else{
      newResult =
          "After $n years, you will have to pay total amount = $netPayableAmount $currentValue";
      debugPrint(
          "After $n years, you will have to pay total amount = $netPayableAmount $currentValue");
    }
    return newResult;
  }

  void onDialogOpen(BuildContext context, String s) {
    debugPrint("......... $s .........");
    var alertDialog = AlertDialog(
      title: Text("NP is selected..."),
      content: Text(s),
      backgroundColor: Colors.green,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text(s),);
        });
  }

  void _reset(){
    principleValueController.text = '';
    rateValueController.text = '';
    termValueController.text = '';
    result = '';
    currentValue = _currencies[0];
  }
}

Widget getAssetImage() {
  AssetImage assetImage = AssetImage('images/interest.png');
  Image image = Image(
    image: assetImage,
    width: 125.0,
    height: 125.0,
  );
  return Container(
    child: image,
    margin: EdgeInsets.all(50.0),
  );
}
