import 'dart:convert';

class VehicleModel {
  String id;
  String modelo;
  String marca;
  int ano;
  String cor;
  String placa;
  String chassi;
  String combustivel;
  String quilometragem;
  String status;
  VehicleModel({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.ano,
    required this.cor,
    required this.placa,
    required this.chassi,
    required this.combustivel,
    required this.quilometragem,
    required this.status,
  });

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map['veiculo_id'] as String,
      modelo: map['modelo'] as String,
      marca: map['marca'] as String,
      ano: int.tryParse(map['ano']) as int,
      cor: map['cor'] as String,
      placa: map['placa'] as String,
      chassi: map['chassi'] as String,
      combustivel: map['combustivel'] as String,
      quilometragem: map['quilometragem'] as String,
      status: map['status'] as String,
    );
  }

  factory VehicleModel.fromJson(String source) =>
      VehicleModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
