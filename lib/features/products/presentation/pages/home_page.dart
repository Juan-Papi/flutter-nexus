import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_nexus/features/products/domain/entities/product.dart';
import 'package:flutter_nexus/features/products/products_module.dart';
import '../blocs/product_bloc/product_bloc.dart';
import '../blocs/product_bloc/product_event.dart';
import '../blocs/product_bloc/product_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<ProductBloc>()..add(const LoadProducts()),
      child: const _HomeBody(),
    );
  }
}

// ─── Body (StatefulWidget para el TextField con debounce) ─────────────────────

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final trimmed = query.trim();
      // BlocProvider.of evita el conflicto de extensión con flutter_modular
      final bloc = BlocProvider.of<ProductBloc>(context);
      if (trimmed.isEmpty) {
        bloc.add(const LoadProducts());
      } else {
        bloc.add(SearchProducts(trimmed));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ListenableBuilder(
                  listenable: _searchController,
                  builder: (_, __) => _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Limpiar',
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const Expanded(child: _ProductList()),
        ],
      ),
    );
  }
}

// ─── Lista de productos ───────────────────────────────────────────────────────

class _ProductList extends StatelessWidget {
  const _ProductList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) => switch (state) {
        ProductInitial() => const Center(
            child: Text('Busca o explora los productos'),
          ),
        ProductLoading() => const Center(child: CircularProgressIndicator()),
        ProductLoaded(:final products) when products.isEmpty => const Center(
            child: Text('No se encontraron productos'),
          ),
        ProductLoaded(:final products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => _ProductTile(product: products[i]),
          ),
        ProductOffline(:final recentProducts) => _OfflineView(
            products: recentProducts,
            onRetry: () =>
                BlocProvider.of<ProductBloc>(context).add(const LoadProducts()),
          ),
        ProductError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
      },
    );
  }
}

// ─── Vista offline ────────────────────────────────────────────────────────────

class _OfflineView extends StatelessWidget {
  const _OfflineView({required this.products, required this.onRetry});

  final List<Product> products;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: Colors.orange.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, size: 18, color: Colors.orange),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Sin conexión · Últimos visitados',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => _ProductTile(product: products[i]),
          ),
        ),
      ],
    );
  }
}

// ─── Tile individual ──────────────────────────────────────────────────────────

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.thumbnail,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 40),
        ),
      ),
      title: Text(
        product.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '\$${product.price.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
          const SizedBox(width: 2),
          Text(product.rating.toStringAsFixed(1)),
        ],
      ),
      onTap: () => Modular.to.pushNamed(
        ProductModule.detail,
        arguments: product.id,
      ),
    );
  }
}
