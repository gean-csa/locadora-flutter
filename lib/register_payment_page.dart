import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locadora_veiculos/lease_model.dart';
import 'package:mysql_client/mysql_client.dart';

import 'main_button.dart';
import 'main_date_picker_field.dart';
import 'main_dropdown_field.dart';
import 'view_vehicle_page.dart';

Future<MySQLConnection> createConnection() async {
  return MySQLConnection.createConnection(
    host: "10.0.2.2",
    port: 3306,
    userName: "root",
    password: "gean0",
    databaseName: "locadora_db",
  );
}

class RegisterPaymentPage extends StatefulWidget {
  const RegisterPaymentPage({super.key, required this.lease});

  final LeaseModel lease;

  @override
  State<RegisterPaymentPage> createState() => _RegisterPaymentPageState();
}

class _RegisterPaymentPageState extends State<RegisterPaymentPage> {
  String? selectedPayMethod;
  DateTime? selectedPayDate;

  MySQLConnection? conn;

  @override
  void initState() {
    super.initState();
    createConnection().then((connection) {
      conn = connection;
      conn!.connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: 1024,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.until(
                      (route) {
                        return route.settings.name == "/";
                      },
                    ),
                    child: const Icon(Icons.home, size: 50),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(const ViewVehiclePage()),
                    child: const Icon(
                      Icons.car_rental_rounded,
                      size: 50,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MainDatePickerField(
                        onSelect: (selectedDate) => setState(() {
                          selectedPayDate = selectedDate;
                        }),
                        title: "Selecione a data inicial",
                      ),
                      const SizedBox(height: 8),
                      MainDropdownField<String>(
                        hint: "Selecione o método de pagamento",
                        title: "Método de pagamento",
                        options: const [
                          'CREDITO',
                          'DEBITO',
                          'PIX',
                          'BOLETO',
                          'CHEQUE'
                        ],
                        selected: null,
                        select: (method) {
                          selectedPayMethod = method;
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              MainButton(
                text: "Cadastrar pagamento",
                onTap: () async {
                  var insertPay = await conn!.execute(
                    "INSERT INTO pagamento (data_pagamento, metodo_pagamento) VALUES (:data_pagamento, :metodo_pagamento)",
                    {
                      'data_pagamento':
                          "${selectedPayDate!.year}-${selectedPayDate!.month}-${selectedPayDate!.day}",
                      'metodo_pagamento': selectedPayMethod,
                    },
                  );
                  print('Inserted row id=${insertPay.lastInsertID}');
                  widget.lease.pagamentoId = insertPay.lastInsertID.toInt();
                  var insertLease = await conn!.execute(
                    "INSERT INTO locacao (data_inicio, data_fim, valor_diaria, quilometragem_inicial, quilometragem_final, status, cliente_id, veiculo_id, pagamento_id) VALUES (:data_inicio, :data_fim, :valor_diaria, :quilometragem_inicial, :quilometragem_final, :status, :cliente_id, :veiculo_id, :pagamento_id)",
                    widget.lease.toMap(),
                  );
                  print('Inserted row id=${insertLease.lastInsertID}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
