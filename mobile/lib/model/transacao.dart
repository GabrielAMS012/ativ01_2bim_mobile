class Transacao {
  String id;
  double valor;
  String nome;
  String tipo;


  Transacao({
    required this.id,
    required this.nome,
    required this.valor,
    required this.tipo,
  });

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'],
      valor: json['valor'],
      tipo: json['tipo'],
      nome: json['nome']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valor': valor,
      'tipo': tipo,
      'nome': nome,
    };
  }
}
