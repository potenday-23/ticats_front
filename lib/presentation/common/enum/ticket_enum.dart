import 'package:freezed_annotation/freezed_annotation.dart';

enum TicketType {
  @JsonValue('0')
  type0,
  @JsonValue('1')
  type1,
  @JsonValue('2')
  type2,
}

enum TicketLayoutType {
  @JsonValue('0')
  layout0,
  @JsonValue('1')
  layout1,
  @JsonValue('2')
  layout2,
}

enum TicketSide { front, back }
