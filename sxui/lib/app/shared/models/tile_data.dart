import 'package:flutter/widgets.dart';
import 'package:sxui/app/models/tile_size.dart';

class TileData {
  final String id;
  final TileSize size;
  final Widget Function(BuildContext) builder;

  const TileData({
    required this.id,
    required this.size,
    required this.builder,
  });

  TileData copyWith({TileSize? size}) =>
      TileData(id: id, size: size ?? this.size, builder: builder);
}
