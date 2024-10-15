import 'package:flutter/material.dart';
import 'package:mobile/service/transacoes_service.dart';

import 'model/transacao.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TransacoesPage(),
    );
  }
}

class TransacoesPage extends StatefulWidget {
  @override
  _TransacoesPageState createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  final TransacoesService _service = TransacoesService();
  late Future<List<Transacao>> _transacoes;

  @override
  void initState() {
    super.initState();
    _loadTransacoes();
  }

  void _loadTransacoes() {
    setState(() {
      _transacoes = _service.listarTransacoes();
    });
  }

  void _createTransacao(String nome, double valor, String tipo) async {
    String id = ((await _service.listarTransacoes()).map((tr) => int.parse(tr.id)).last + 1).toString();
    final transacao = Transacao(id: id, nome: nome, valor: valor, tipo: tipo);
    await _service.createTransacao(transacao);
    _loadTransacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transações')),
      body: FutureBuilder<List<Transacao>>(
        future: _transacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar transações'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma transação cadastrada.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final transacao = snapshot.data![index];
              return ListTile(
                title: Text(transacao.nome),
                subtitle: Text(
                    'Tipo: ${transacao.tipo} - Valor: ${transacao.valor.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final _nomeController = TextEditingController();
    final _valorController = TextEditingController();
    String _tipo = 'Credito';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Transação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: _tipo,
                items: ['Credito', 'Debito']
                    .map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipo = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final nome = _nomeController.text;
                final valor = double.tryParse(_valorController.text) ?? 0.0;
                _createTransacao(nome, valor, _tipo);
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}