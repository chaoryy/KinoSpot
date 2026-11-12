import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kinospot/data/api/api_service.dart';

class PosterImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const PosterImage({super.key, required this.url, this.fit = BoxFit.cover});

  String get _resolved {
    final u = url.trim();
    if (u.startsWith('http')) return u;
    return '${ApiService.baseUrl}${u.startsWith('/') ? '' : '/'}$u';
  }

  Widget _placeholder() => Container(
    color: const Color(0xFFD9D6F2),
    alignment: Alignment.center,
    child: const Icon(Icons.movie_outlined, size: 40, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return _placeholder();
    return CachedNetworkImage(
      imageUrl: _resolved,
      fit: fit,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }
}