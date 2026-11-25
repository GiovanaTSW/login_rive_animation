import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../theme/ct_theme.dart';
import 'login_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final Future<List<Map<String, dynamic>>> _future =
      ApiService.fetchProducts();
  int _tab = 0;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLICK & TAP'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _tab == 0 ? _catalog() : _account(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: CT.water,
        color: CT.navy,
        buttonBackgroundColor: CT.sea,
        items: const [
          Icon(Icons.storefront, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _account() =>
      Center(child: Text(FirebaseAuth.instance.currentUser?.email ?? ''));

  Widget _catalog() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final products = snap.data ?? [];
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) {
            final p = products[i];
            // La API pública expone disponibilidad (inStock); si el backend
            // enviara 'stock' exacto, se muestra.
            final stock = p['stock'] != null
                ? 'Stock: ${p['stock']}'
                : (p['inStock'] == true ? 'En stock' : 'Agotado');
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(p['name'].toString()),
                subtitle: Text('${p['category']['category']} · $stock'),
                trailing: Text(
                  '\$${p['price']}',
                  style: const TextStyle(
                    color: CT.prussian,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
