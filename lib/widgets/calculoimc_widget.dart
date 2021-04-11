import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculoImcWidget extends StatefulWidget {
  @override
  _CalculoImcWidgetState createState() => _CalculoImcWidgetState();
}

class _CalculoImcWidgetState extends State<CalculoImcWidget> {
   int valor = 1;
  int tipo = 1;
  GlobalKey<FormState> formulario = GlobalKey<FormState>();
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController circunferenciaController = TextEditingController();
  String resultado_imc;
  String resultado_iac;

  void _radioValueHandler(int value) {
    setState(() {
      resultado_iac = null;
      resultado_imc = null;
      valor = value;
    });
  }

  void _radioTypeHandler(int value) {
    setState(() {
      resultado_iac = null;
      resultado_imc = null;
      tipo = value;
    });
  }

  void calculo_Imc() {
    double altura = double.parse(alturaController.text) / 100.0;
    double peso = double.parse(pesoController.text);
    double imc = peso / pow(altura, 2);
    setState(() {
      resultado_imc = imc.toStringAsFixed(2) + "\n\n" + getClassificacao(imc);
    });
  }

  void calculo_Iac() {
    double altura = double.parse(alturaController.text) / 100.0;
    double circunferencia = double.parse(circunferenciaController.text);
    double iac = (circunferencia / (altura * sqrt(altura))) - 18;
    setState(() {
      resultado_imc = null;
      resultado_iac = iac.toStringAsFixed(2) + "\n\n" + getClassificacao(iac);
    });
  }

  String getClassificacao(num imc) {
    String strClassificacao = "";

    if (valor == 1) {
      if (imc < 20) {
        strClassificacao = "Abaixo do peso";
      } else if (imc < 26.4) {
        strClassificacao = "Peso Ideal!";
      } else if (imc < 27.8) {
        strClassificacao = "Levemente acima do peso";
      } else if (imc < 31.1) {
        strClassificacao = "Acima do Peso";
      } else if (imc > 31.1) {
        strClassificacao = "Obesidade";
      }
    } else {
      if (imc < 18.5) {
        strClassificacao = "Abaixo do peso";
      } else if (imc < 24.9) {
        strClassificacao = "Peso Ideal!";
      } else if (imc < 29.9) {
        strClassificacao = "Levemente acima do peso";
      } else if (imc < 34.9) {
        strClassificacao = "Obesidade grau I";
      } else if (imc < 39.9) {
        strClassificacao = "Obesidade grau II";
      } else {
        strClassificacao = "Obesidade grau III";
      }
    }

    return strClassificacao;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formulario,
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 6),
              child: Column(children: [
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: tipo,
                      onChanged: _radioTypeHandler,
                    ),
                    new Text("IMC"),
                    Radio(
                      value: 1,
                      groupValue: tipo,
                      onChanged: _radioTypeHandler,
                    ),
                    new Text("IAC")
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: valor,
                      onChanged: _radioValueHandler,
                    ),
                    new Text("Masculino"),
                    Radio(
                      value: 1,
                      groupValue: valor,
                      onChanged: _radioValueHandler,
                    ),
                    new Text("Feminino")
                  ],
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                //Altura
                controller: alturaController,
                validator: (value) {
                  return value.isEmpty ? "altura" : null;
                },
                decoration: InputDecoration(
                  labelText: "Digite sua a altura em cm:",
                ),
              ),
            ),
            Visibility(
              child: Container(
                margin: EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pesoController,
                  validator: (value) {
                    return value.isEmpty ? "peso" : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Digite seu peso em Kg:",
                  ),
                ),
              ),
              visible: tipo == 0,
            ),
            Visibility(
              child: Container(
                margin: EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: circunferenciaController,
                  validator: (value) {
                    return value.isEmpty ? "circunferência do quadril" : null;
                  },
                  decoration: InputDecoration(
                      labelText: "Informe a circunferência do quadril:"),
                ),
              ),
              visible: tipo == 1,
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(resultado_imc == null
                  ? resultado_iac == null
                      ? ""
                      : "Seu IAC é = $resultado_iac"
                  : "Seu IMC é = $resultado_imc",
                  style: TextStyle(fontSize: 25, color: Colors.blue),
              ),                  
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  if (formulario.currentState.validate()) {
                    if (tipo == 0)
                      calculo_Imc();
                    else
                      calculo_Iac();
                  }
                },
                child: Text("Calcular"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
