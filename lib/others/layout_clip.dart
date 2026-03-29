import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0, size.height - 7);
    path.quadraticBezierTo(
      size.width / 4.0,
      size.height,
      size.width / 2.0,
      size.height - 50,
    );
    path.quadraticBezierTo(
      (size.width * (3.0 / 4.0)),
      size.height - 100,
      size.width,
      size.height - 93,
    );
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DefaultClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomClip02 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 10);
    path.lineTo(size.width/8.0, size.height - 10);
    path.lineTo(size.width/8.0, size.height);
    path.lineTo(((size.width/2.0) + (size.width*3.0/8.0)), size.height);
    path.lineTo(((size.width/2.0) + (size.width*3.0/8.0)), size.height - 10);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);

    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
