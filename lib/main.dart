import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:locadora_veiculos/lease_model.dart';
import 'package:locadora_veiculos/main_button.dart';
import 'package:locadora_veiculos/main_date_picker_field.dart';
import 'package:locadora_veiculos/main_dropdown_field.dart';
import 'package:locadora_veiculos/main_text_field.dart';
import 'package:locadora_veiculos/register_payment_page.dart';
import 'package:locadora_veiculos/view_vehicle_page.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController initialKmController = TextEditingController(text: "");
  TextEditingController finalKmController = TextEditingController(text: "");
  DateTime? selectedFinalDate;
  DateTime? selectedInitialDate;
  String? selectedStatus;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.home,
                        size: 50,
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
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MainDatePickerField(
                          onSelect: (selectedDate) => setState(() {
                            selectedInitialDate = selectedDate;
                          }),
                          title: "Selecione a data inicial",
                        ),
                        const SizedBox(height: 8),
                        MainDatePickerField(
                          onSelect: (selectedDate) => setState(() {
                            selectedFinalDate = selectedDate;
                          }),
                          title: "Selecione a data final",
                        ),
                        const SizedBox(height: 8),
                        MainTextField(
                          controller: priceController,
                          title: "Valor da diária",
                          hint: "ex.: 10.00",
                        ),
                        const SizedBox(height: 8),
                        MainTextField(
                          controller: initialKmController,
                          title: "Quilometragem inicial",
                          hint: "ex.: 60",
                        ),
                        const SizedBox(height: 8),
                        MainTextField(
                          controller: finalKmController,
                          title: "Quilometragem final",
                          hint: "ex.: 160",
                        ),
                        const SizedBox(height: 8),
                        MainDropdownField<String>(
                          hint: "Selecione o status da locação",
                          title: "Status",
                          options: const ["PENDENTE", "CONCLUIDA", "CANCELADA"],
                          selected: null,
                          select: (status) {
                            selectedStatus = status;
                          },
                        ),
                        const SizedBox(height: 8),
                        MainButton(
                          text: "Seguir para pagamento",
                          onTap: () => Get.to(
                            () => RegisterPaymentPage(
                              lease: LeaseModel(
                                dataInicio:
                                    "${selectedInitialDate!.year}-${selectedInitialDate!.month}-${selectedInitialDate!.day}",
                                dataFim:
                                    "${selectedFinalDate!.year}-${selectedFinalDate!.month}-${selectedFinalDate!.day}",
                                valorDiaria: int.tryParse(priceController.text),
                                quilometragemInicial:
                                    int.tryParse(initialKmController.text),
                                quilometragemFinal:
                                    int.tryParse(finalKmController.text),
                                status: selectedStatus!,
                                clienteId: random.nextInt(3000),
                                veiculoId: random.nextInt(5000),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
