import 'package:flutter/material.dart';

enum ColorType {
  white("white", color: Colors.white, id: 0),
  black("black", color: Colors.black, id: 1),
  blue("blue", color: Color(0xFF129BFF), id: 2),
  green("green", color: Color(0xFF25BC22), id: 3),
  yellow("yellow", color: Color(0xFFFFC632), id: 4),
  orange("orange", color: Color(0xFFFF8A00), id: 5),
  red("red", color: Color(0xFFF82528), id: 6),
  purple("purple", color: Color(0xFFAA20EB), id: 7);

  final String name;
  final Color color;
  final int id;

  const ColorType(this.name, {required this.color, required this.id});
}
