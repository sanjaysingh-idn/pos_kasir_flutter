import 'package:flutter/material.dart';
import 'package:pos_kasir/constant.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:intl/intl.dart';

class ProdukDetail extends StatefulWidget {
  // const ProdukDetail({super.key});
  const ProdukDetail({super.key, required this.product});

  final Map product;

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  // static final customCacheManager = CacheManager(
  //   Config('customCacheKey',
  //       stalePeriod: const Duration(days: 15), maxNrOfCacheObjects: 100),
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  key: UniqueKey(),
                  imageUrl: widget.product['image'] != null
                      ? "$imageUrl${widget.product['image']}"
                      : "assets/img_default/default.jpg",
                  placeholder: (context, url) => Container(
                    color: Colors.black,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.black,
                    child: const Icon(Icons.error),
                  ),
                  fit: BoxFit.scaleDown,
                  maxHeightDiskCache: 200,
                  maxWidthDiskCache: 200,
                ),
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nama Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['name'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['category']['name'],
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Stok',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['stock'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Harga Beli',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rp. ${NumberFormat('#,##0').format(widget.product['priceBuy'])}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Harga Jual',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Rp. ${NumberFormat('#,##0').format(widget.product['priceSell'])}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Kode Barcode',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['barcode'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.product['desc'],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
