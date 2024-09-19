import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locadora_veiculos/vehicle_model.dart';
import 'package:mysql_client/mysql_client.dart';

import 'main_button.dart';
import 'main_text_field.dart';

Future<MySQLConnection> createConnection() async {
  return MySQLConnection.createConnection(
    host: "localhost",
    port: 3306,
    userName: "local_username",
    password: "local_password",
    databaseName: "local_db",
  );
}

class ViewVehiclePage extends StatefulWidget {
  const ViewVehiclePage({super.key});

  @override
  State<ViewVehiclePage> createState() => _ViewVehiclePageState();
}

class _ViewVehiclePageState extends State<ViewVehiclePage> {
  TextEditingController plateInfoController = TextEditingController(text: "");
  VehicleModel? vehicle;
  bool foundVehicle = false;

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
                  const Icon(Icons.car_rental_rounded, size: 50),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      MainTextField(
                        controller: plateInfoController,
                        title: "Busca",
                        hint: "Digite a placa para buscar o veiculo",
                      ),
                      const SizedBox(height: 8),
                      if (foundVehicle && vehicle != null) ...{
                        MainTextField(
                          title: "Modelo",
                          hint: vehicle!.modelo,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Marca",
                          hint: vehicle!.marca,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Ano",
                          hint: "${vehicle!.ano}",
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Cor",
                          hint: vehicle!.cor,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Placa",
                          hint: vehicle!.placa,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Chassi",
                          hint: vehicle!.chassi,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Combustivel",
                          hint: vehicle!.combustivel,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Quilometragem",
                          hint: vehicle!.quilometragem,
                          readOnly: true,
                        ),
                        MainTextField(
                          title: "Status",
                          hint: vehicle!.status,
                          readOnly: true,
                        ),
                      }
                    ],
                  ),
                ),
              ),
              MainButton(
                text: "Buscar veiculo",
                onTap: () async {
                  var selectVehicle = await conn!.execute(
                    "SELECT * FROM veiculo WHERE placa = :placa LIMIT 1",
                    {"placa": plateInfoController.text},
                  );
                  if (selectVehicle.rows.isNotEmpty) {
                    setState(() {
                      foundVehicle = true;
                      vehicle = VehicleModel.fromMap(
                          selectVehicle.rows.first.assoc());
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
