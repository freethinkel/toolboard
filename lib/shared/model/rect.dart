import 'dart:ui';

class RectEntry {
  Size size;
  Offset offset;

  RectEntry({
    required this.size,
    required this.offset,
  });

  static RectEntry fromMap(Map data) {
    return RectEntry(
      offset: Offset(data['position']['x'], data['position']['y']),
      size: Size(
        data['size']['width'],
        data['size']['height'],
      ),
    );
  }

  Map toMap() {
    return ({
      'position': {
        'x': offset.dx,
        'y': offset.dy,
      },
      'size': {
        'width': size.width,
        'height': size.height,
      }
    });
  }
}
