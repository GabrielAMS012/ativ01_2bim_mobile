import '../model/transacao.dart';
import 'abstract_service.dart';

class TransacoesService extends AbstractService<Transacao> {

  @override
  String recurso() {
    return "transacoes";
  }

  @override
  Transacao fromJson(Map<String, dynamic> json) {
    return Transacao.fromJson(json);
  }

  Future<void> createTransacao(Transacao transacao) {
    return create(transacao, transacao.toJson());
  }

  Future<void> updateTransacao(String id, Transacao transacao) {
    return update(id, transacao.toJson());
  }

  Future<void> deleteTransacao(int id) {
    return delete(id);
  }

  Future<List<Transacao>> listarTransacoes() async {
    return await getAll();
  }
}
