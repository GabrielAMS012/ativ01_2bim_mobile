import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AbstractService<T> {
  final String baseUrl = "http://localhost:3000/";

  String recurso();

  T fromJson(Map<String, dynamic> json);

  Future<List<T>> getAll() async {
    final response = await http.get(Uri.parse("${baseUrl}${recurso()}"));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => fromJson(item)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Erro ao carregar dados');
    }
  }

  Future<void> create(T item, Map<String, dynamic> toJson) async {
    final response = await http.post(
      Uri.parse("${baseUrl}${recurso()}"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toJson),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar item');
    }
  }

  Future<void> update(String id, Map<String, dynamic> toJson) async {
    final response = await http.put(
      Uri.parse("${baseUrl}${recurso()}/$id"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(toJson),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar item');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse("${baseUrl}${recurso()}/$id"));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar item');
    }
  }
}
