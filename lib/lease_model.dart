import 'dart:convert';

class LeaseModel {
  String? dataFim;
  int? valorDiaria;
  int? quilometragemInicial;
  int? quilometragemFinal;
  String? status;
  int? clienteId;
  int? veiculoId;
  String? dataInicio;
  int? pagamentoId;
  LeaseModel({
    this.dataInicio,
    this.dataFim,
    this.valorDiaria,
    this.quilometragemInicial,
    this.quilometragemFinal,
    this.status,
    this.clienteId,
    this.veiculoId,
    this.pagamentoId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data_fim': dataFim,
      'valor_diaria': valorDiaria,
      'quilometragem_inicial': quilometragemInicial,
      'quilometragem_final': quilometragemFinal,
      'status': status,
      'cliente_id': clienteId,
      'veiculo_id': veiculoId,
      'data_inicio': dataInicio,
      'pagamento_id': pagamentoId,
    };
  }

  String toJson() => json.encode(toMap());
}
