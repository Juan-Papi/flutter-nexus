import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:flutter_nexus/features/products/domain/entities/product.dart';
import 'package:flutter_nexus/features/products/products_module.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Modular.get<ProductDetailBloc>()
        ..add(LoadProductDetail(productId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) => switch (state) {
            ProductDetailInitial() ||
            ProductDetailLoading() =>
              const Center(child: CircularProgressIndicator()),
            ProductDetailLoaded(:final product, :final recentProducts) =>
              _DetailBody(product: product, recentProducts: recentProducts),
            ProductDetailError(:final message, :final recentProducts) =>
              _ErrorBody(message: message, recentProducts: recentProducts),
          },
        ),
      ),
    );
  }
}

// ─── Cuerpo del detalle ───────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.product,
    required this.recentProducts,
  });

  final Product product;
  final List<Product> recentProducts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Imagen principal ────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.thumbnail,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 240,
                child: Center(
                    child: Icon(Icons.image_not_supported, size: 64)),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Título ──────────────────────────────────────────────────────────
          Text(
            product.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // ── Precio + descuento ──────────────────────────────────────────────
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${product.discountPercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Rating y stock ──────────────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(product.rating.toStringAsFixed(1)),
              const SizedBox(width: 16),
              Icon(Icons.inventory_2_outlined,
                  size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('${product.stock} en stock'),
            ],
          ),
          const SizedBox(height: 4),

          // ── Marca y categoría ───────────────────────────────────────────────
          if (product.brand != null)
            Text('Marca: ${product.brand}',
                style: TextStyle(color: Colors.grey.shade600)),
          Text('Categoría: ${product.category}',
              style: TextStyle(color: Colors.grey.shade600)),

          const Divider(height: 24),

          // ── Descripción ─────────────────────────────────────────────────────
          Text(
            'Descripción',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(product.description),

          if (recentProducts.isNotEmpty)
            _RecentProductsSection(recentProducts: recentProducts),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ─── Error con recientes ──────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.recentProducts});

  final String message;
  final List<Product> recentProducts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
          if (recentProducts.isNotEmpty)
            _RecentProductsSection(recentProducts: recentProducts),
        ],
      ),
    );
  }
}

// ─── Sección de recientes reutilizable ───────────────────────────────────────

class _RecentProductsSection extends StatelessWidget {
  const _RecentProductsSection({required this.recentProducts});

  final List<Product> recentProducts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24),
        Text(
          'Vistos recientemente',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recentProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final recent = recentProducts[index];
              return GestureDetector(
                onTap: () => Modular.to.pushNamed(
                  ProductModule.detail,
                  arguments: recent.id,
                ),
                child: SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          recent.thumbnail,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              size: 40),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recent.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
