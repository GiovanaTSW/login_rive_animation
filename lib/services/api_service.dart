import 'dart:convert';

import 'package:http/http.dart' as http;

/// Cliente de la API Click & Tap (Spring Boot). Sustituye al viejo marketbackend.
class ApiService {
  // Web / iOS / macOS: localhost | Emulador Android: 10.0.2.2 | Celular: IP de la PC
  static const String baseUrl = 'http://localhost:8088';

  /// GET /api/products (catálogo público, paginado) -> lista de productos.
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final res = await http.get(Uri.parse('$baseUrl/api/products?size=50'));
    if (res.statusCode != 200) {
      throw Exception('Error al cargar productos (${res.statusCode})');
    }
    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    return (body['items'] as List).cast<Map<String, dynamic>>();
  }
}
