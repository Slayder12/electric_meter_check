import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'calculator_buttons.dart';

class MeterCheckPage1 extends StatefulWidget {
  const MeterCheckPage1({
    super.key,
  });

  @override
  State<MeterCheckPage1> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MeterCheckPage1> {
// buisness logic
  late Stopwatch stopwatch;
  late Timer timer;
  final double U = 0.22;
  double iA = 0, iB = 0, iC = 0, T = 0, p1 = 0, p2 = 0, P = 0, tr = 0;
  int impusle = 0, N = 0, kt = 0;
  int? meterAaccuracy;
  String str = "Введите данные";
  bool visibleHint = false;

  final String _doubleRegEx = r'(^\d*\.?\d*)';

  Color _rsultTextColor = Colors.white;
  final Color _colorRed = Colors.red;
  final Color _colorWhite = Colors.white;
  final Color _color1 = const Color(0xFF76D1FF);
  final Color _colorGrey = const Color(0xFF8F8F8F);
  final Color _dark = const Color(0xFF0E0E0E);

  final double sizeBox = 6;

  final _controllerKT = TextEditingController();
  final _controllerImpusle = TextEditingController();
  final _controllerIA = TextEditingController();
  final _controllerIB = TextEditingController();
  final _controllerIC = TextEditingController();
  final _controllerN = TextEditingController();
  final _controllerT = TextEditingController();

  FocusNode focusNodeKT = FocusNode();
  FocusNode focusNodeImpusle = FocusNode();
  FocusNode focusNodeIA = FocusNode();
  FocusNode focusNodeIB = FocusNode();
  FocusNode focusNodeIC = FocusNode();
  FocusNode focusNodeN = FocusNode();
  FocusNode focusNodeT = FocusNode();

  void handleStartStop() {
    if (stopwatch.isRunning) {
      stopwatch.stop();
      _controllerT.text = timerControllerFormattedText();
    } else {
      stopwatch.start();
    }
    if (stopwatch.isRunning) {
      stopwatch.reset();
    }
  }

  String timerFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;
    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(1, "0");
    return "$minutes:$seconds:$milliseconds";
  }

  String timerControllerFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;
    String milliseconds = (milli % 1000).toString();
    String seconds = ((milli ~/ 1000)).toString();
    return "$seconds.$milliseconds";
  }

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    timer = Timer.periodic(const Duration(milliseconds: 0), (timer) {
      setState(() {
        if (stopwatch.isRunning) {
          _controllerT.text = timerControllerFormattedText();
        }
        if (focusNodeImpusle.hasFocus && _controllerImpusle.text == "0") {
          _controllerImpusle.text = "";
        }
      });
    });
  }

  void _buttonPressed(String text) {
    TextEditingController currentController;
    if (focusNodeKT.hasFocus && text != '.') {
      currentController = _controllerKT;
    } else if (focusNodeImpusle.hasFocus && text != '.') {
      currentController = _controllerImpusle;
    } else if (focusNodeIA.hasFocus) {
      if (text == '.' && _controllerIA.text.contains('.')) {
        return;
      }
      currentController = _controllerIA;
    } else if (focusNodeIB.hasFocus) {
      if (text == '.' && _controllerIB.text.contains('.')) {
        return;
      }
      currentController = _controllerIB;
    } else if (focusNodeIC.hasFocus) {
      if (text == '.' && _controllerIC.text.contains('.')) {
        return;
      }
      currentController = _controllerIC;
    } else if (focusNodeN.hasFocus && text != '.') {
      currentController = _controllerN;
    } else if (focusNodeT.hasFocus) {
      if (text == '.' && _controllerT.text.contains('.')) {
        return;
      }
      currentController = _controllerT;
    } else {
      return; // Если ни одно поле не в фокусе, ничего не делаем
    }

    int cursorPos = currentController.selection.baseOffset;
    String newText = currentController.text;
    if (newText.length > 6) {
      return;
    }
    if (cursorPos >= 0) {
      // Есть позиция курсора
      newText =
          newText.substring(0, cursorPos) + text + newText.substring(cursorPos);
      cursorPos += text.length;
    } else {
      newText += text;
      cursorPos = newText.length;
    }
    currentController.text = newText;
    currentController.selection =
        TextSelection.fromPosition(TextPosition(offset: cursorPos));
  }

  void _removeText() {
    TextEditingController currentController;
    if (focusNodeKT.hasFocus) {
      currentController = _controllerKT;
    } else if (focusNodeImpusle.hasFocus) {
      currentController = _controllerImpusle;
    } else if (focusNodeIA.hasFocus) {
      currentController = _controllerIA;
    } else if (focusNodeIB.hasFocus) {
      currentController = _controllerIB;
    } else if (focusNodeIC.hasFocus) {
      currentController = _controllerIC;
    } else if (focusNodeN.hasFocus) {
      currentController = _controllerN;
    } else if (focusNodeT.hasFocus) {
      currentController = _controllerT;
    } else {
      return; // Если ни одно поле не в фокусе, ничего не делаем
    }

    int start = currentController.selection.start;
    int end = currentController.selection.end;
    if (start >= 0 && end > start) {
      // Есть выделенный текст
      String newText = currentController.text.substring(0, start) +
          currentController.text.substring(end);
      currentController.text = newText;
      currentController.selection =
          TextSelection.fromPosition(TextPosition(offset: start));
    } else if (start > 0) {
      // Нет выделения, но есть курсор
      String newText = currentController.text.substring(0, start - 1) +
          currentController.text.substring(start);
      currentController.text = newText;
      currentController.selection =
          TextSelection.fromPosition(TextPosition(offset: start - 1));
    }
  }

  void _validateInputValue() {
    if (_controllerKT.text == "" || int.parse(_controllerKT.text) <= 0) {
      _controllerKT.text = "1";
    }
    if (_controllerImpusle.text == "" ||
        int.parse(_controllerImpusle.text) <= 0) {
      _controllerImpusle.text = "0";
    }
    if (_controllerIA.text == "" ||
        _controllerIA.text == "." ||
        double.parse(_controllerIA.text) < 0) {
      _controllerIA.text = "0";
    }
    if (_controllerIB.text == "" ||
        _controllerIB.text == "." ||
        double.parse(_controllerIB.text) < 0) {
      _controllerIB.text = "0";
    }
    if (_controllerIC.text == "" ||
        _controllerIC.text == "." ||
        double.parse(_controllerIC.text) < 0) {
      _controllerIC.text = "0";
    }
    if (_controllerN.text == "" || int.parse(_controllerN.text) <= 0) {
      _controllerN.text = "1";
    }
    if (_controllerT.text == "" ||
        _controllerT.text == "." ||
        double.parse(_controllerT.text) < 0) {
      _controllerT.text = "0.0";
    }
    if (stopwatch.isRunning ||
        _controllerT.text == '0.0' ||
        _controllerT.text == '0') {
      stopwatch.stop();
      _controllerT.text = timerControllerFormattedText();
    }
  }

  void _parser() {
    kt = int.parse(_controllerKT.text);
    impusle = int.parse(_controllerImpusle.text);
    iA = double.parse(_controllerIA.text);
    iB = double.parse(_controllerIB.text);
    iC = double.parse(_controllerIC.text);
    N = int.parse(_controllerN.text);
    T = double.parse(_controllerT.text);
  }

  void _calculation() {
    p1 = 3600 * N / (T * impusle) * kt;
    if (p1.isNaN || p1.isInfinite) {
      p1 = 0;
    } else {
      p1 = (p1 * 100).round() / 100;
    }

    p2 = (iA + iB + iC) * U;
    if (p2.isNaN || p2.isInfinite) {
      p2 = 0;
    } else {
      p2 = (p2 * 100).round() / 100;
    }

    tr = (3600 * N / (p2 * impusle) * kt);
    if (tr.isNaN || tr.isInfinite) {
      tr = 0;
    } else {
      tr = (tr * 1000).round() / 1000;
    }

    P = (p2 - p1) / p1 * 100;
    if (P.isNaN || P.isInfinite || P == -100) {
      meterAaccuracy = null;
      visibleHint = false;
    } else {
      meterAaccuracy = P.round();
      visibleHint = true;
    }
  }

  void _changeColorText() {
    if (P.isNaN || P.isInfinite) {
      _rsultTextColor = _colorRed;
    } else {
      P = P.abs();
      if (P.round() <= 10) {
        _rsultTextColor = Colors.green;
      } else if (P.round() <= 20 && P.round() >= 10) {
        _rsultTextColor = Colors.yellow;
      } else {
        _rsultTextColor = _colorRed;
      }
    }
  }

  void _result() {
    _validateInputValue();
    _parser();
    setState(() {
      _calculation();
      _changeColorText();
    });
  }

  void changeFocus(FocusNode focusNode) {
    FocusScopeNode focus = FocusScope.of(context);
    focus.requestFocus(focusNode);
  }

  void _allReset() {
    changeFocus(focusNodeImpusle);
    stopwatch.stop();
    stopwatch.reset();
    _controllerKT.clear();
    _controllerImpusle.clear();
    _controllerIA.clear();
    _controllerIB.clear();
    _controllerT.clear();
    _controllerIC.clear();
    _controllerN.clear();
    _rsultTextColor = Colors.white;

    p1 = 0;
    p2 = 0;
    tr = 0;
    meterAaccuracy = null;
    visibleHint = false;
  }

  @override
  void dispose() {
    _controllerKT.dispose();
    _controllerImpusle.dispose();
    _controllerIA.dispose();
    _controllerIB.dispose();
    _controllerT.dispose();
    _controllerIC.dispose();
    _controllerN.dispose();

    focusNodeKT.dispose();
    focusNodeImpusle.dispose();
    focusNodeIA.dispose();
    focusNodeIB.dispose();
    focusNodeIC.dispose();
    focusNodeN.dispose();
    focusNodeT.dispose();
    super.dispose();
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RawMaterialButton(
            constraints: const BoxConstraints.expand(height: 60),
            fillColor: _dark,
            padding: const EdgeInsets.all(10.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14.0),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: () {
              if (buttonText != '⌫') {
                _buttonPressed(buttonText);
              } else {
                _removeText();
              }
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          'Класс точности прибора учета \n электроэнергии прямого включения',
          style: TextStyle(fontSize: 20, color: _colorGrey),
        ),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          children: [
            Center(
              child: Text(
                '${meterAaccuracy ?? str}${meterAaccuracy != null ? "%" : ""}',
                style: TextStyle(fontSize: 28, color: _rsultTextColor),
              ),
            ),
            SizedBox(height: sizeBox),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeKT);  
                          _controllerKT.clear();
                        });
                      },
                      child: TextFormField(
                          focusNode: focusNodeKT,
                          style: TextStyle(
                            fontSize: 20,
                            color: _colorWhite,
                          ),
                          keyboardType: TextInputType.none,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: _color1,
                          textAlign: TextAlign.center,
                          controller: _controllerKT,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _dark,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10.0),
                            labelText: ' Коэфф.Tрансформации',
                            labelStyle: TextStyle(color: _colorGrey),
                            hintText: 'Kt',
                            hintStyle: TextStyle(color: _colorGrey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: _colorGrey, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: _color1, width: 2.0),
                            ),
                          )),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeImpusle);                          
                          _controllerImpusle.clear();                        
                        });
                      },
                      child: TextFormField(
                          focusNode: focusNodeImpusle,
                          style: TextStyle(fontSize: 20, color: _colorWhite),
                          keyboardType: TextInputType.none,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: _color1,
                          textAlign: TextAlign.center,
                          autofocus: true,
                          controller: _controllerImpusle,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: _dark,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            labelText: ' Передаточное число',
                            labelStyle: TextStyle(color: _colorGrey),
                            hintText: 'imp/(kW*h)',
                            hintStyle: TextStyle(color: _colorGrey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: _colorGrey, width: 2.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: _color1, width: 2.0),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeBox),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeIA);  
                          _controllerIA.clear();
                        });
                      },
                      child: TextFormField(
                        onTap: () {                         
                          if (_controllerIA.text == "0") {
                            _controllerIA.clear();
                          }
                        },
                        focusNode: focusNodeIA,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.allow(
                              RegExp(_doubleRegEx))
                        ],
                        cursorColor: _color1,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        controller: _controllerIA,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _dark,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelText: ' Ток фазы A',
                          labelStyle: TextStyle(color: _colorGrey),
                          hintText: 'Ia',
                          hintStyle: TextStyle(color: _colorGrey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: _colorGrey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: _color1, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeIB);  
                          _controllerIB.clear();
                        });
                      },
                      child: TextFormField(
                        onTap: () {
                          if (_controllerIB.text == "0") {
                            _controllerIB.clear();
                          }
                        },
                        focusNode: focusNodeIB,
                        style: TextStyle(fontSize: 18, color: _colorWhite),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.allow(
                              RegExp(_doubleRegEx))
                        ],
                        cursorColor: _color1,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        controller: _controllerIB,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _dark,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelText: ' Ток фазы B',
                          labelStyle: TextStyle(color: _colorGrey),
                          hintText: 'Ib',
                          hintStyle: TextStyle(color: _colorGrey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: _colorGrey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: _color1, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sizeBox),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeIC);  
                          _controllerIC.clear();
                        });
                      },
                      child: TextFormField(
                        onTap: () {
                          if (_controllerIC.text == "0") {
                            _controllerIC.clear();
                          }
                        },
                        focusNode: focusNodeIC,
                        style: TextStyle(fontSize: 18, color: _colorWhite),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.allow(
                            RegExp(_doubleRegEx))
                        ],
                        cursorColor: _color1,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        controller: _controllerIC,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _dark,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelText: ' Ток фазы C',
                          labelStyle: TextStyle(color: _colorGrey),
                          hintText: 'Ic',
                          hintStyle: TextStyle(color: _colorGrey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: _colorGrey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: _color1, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeBox),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeN);  
                          _controllerN.clear();
                        });
                      },
                      child: TextFormField(
                        focusNode: focusNodeN,
                        style: TextStyle(fontSize: 20, color: _colorWhite),
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: _color1,
                        controller: _controllerN,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _dark,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelText: ' Кол-во импулсов',
                          labelStyle: TextStyle(color: _colorGrey),
                          hintText: 'n',
                          hintStyle: TextStyle(color: _colorGrey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: _colorGrey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: _color1, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          changeFocus(focusNodeT);  
                          _controllerT.clear();
                          stopwatch.reset();
                        });
                      },
                      child: TextField(
                        onTap: () {
                          if (_controllerT.text == "0.0" ||
                              _controllerT.text == "0") {
                            _controllerT.clear();
                          }
                        },
                        focusNode: focusNodeT,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(8),
                          FilteringTextInputFormatter.allow(
                              RegExp(_doubleRegEx))
                        ],
                        cursorColor: _color1,
                        keyboardType: TextInputType.none,
                        textAlign: TextAlign.center,
                        controller: _controllerT,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: _dark,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          labelText: 'Время',
                          labelStyle: TextStyle(color: _colorGrey),
                          hintText: 'sec',
                          hintStyle: TextStyle(color: _colorGrey),
                          prefixIcon: Icon(
                            Icons.timer,
                            color: _colorWhite,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: _colorGrey, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                            borderSide: BorderSide(color: _color1, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeBox),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RawMaterialButton(
                      constraints: const BoxConstraints.expand(height: 150),
                      padding: const EdgeInsets.all(30.0),
                      fillColor: _color1,
                      onPressed: () {
                        _allReset();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        "⟳",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RawMaterialButton(
                      constraints: const BoxConstraints.expand(height: 150),
                      padding: const EdgeInsets.all(30.0),
                      fillColor: (!stopwatch.isRunning) ? _color1 : Colors.red,
                      onPressed: () {
                        handleStartStop();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                      child: Text(
                        timerFormattedText(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: RawMaterialButton(
                      constraints: const BoxConstraints.expand(height: 150),
                      padding: const EdgeInsets.all(30.0),
                      fillColor: _color1,
                      onPressed: () {
                        _result();
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                      ),
                      child: const Text(
                        textAlign: TextAlign.center,
                        "=",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeBox),
            Column(children: [
              Row(children: [
                buildButton("1"),
                buildButton("2"),
                buildButton("3"),
              ]),
              Row(children: [
                buildButton("4"),
                buildButton("5"),
                buildButton("6"),
              ]),
              Row(children: [
                buildButton("7"),
                buildButton("8"),
                buildButton("9"),
              ]),
              Row(children: [
                buildButton("."),
                buildButton("0"),
                buildButton('⌫'),
              ]),
              SizedBox(height: sizeBox),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Visibility(
                visible: visibleHint,
                child: Text(
                  textAlign: TextAlign.start,
                  'Расчётное время: $tr сек\nРасчётная мощность: $p2 кВт\nМощность по замеру: $p1 кВт',
                  style: TextStyle(fontSize: 14, color: _colorGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
