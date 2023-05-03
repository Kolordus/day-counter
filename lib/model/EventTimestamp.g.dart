// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventTimestamp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTimestampAdapter extends TypeAdapter<EventTimestamp> {
  @override
  final int typeId = 0;

  @override
  EventTimestamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventTimestamp(
      fields[0] as String,
      fields[1] as DateTime?,
      fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EventTimestamp obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTimestampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
