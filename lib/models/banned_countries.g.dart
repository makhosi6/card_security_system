// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banned_countries.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannedCountryAdapter extends TypeAdapter<BannedCountry> {
  @override
  final int typeId = 2;

  @override
  BannedCountry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannedCountry()..code = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, BannedCountry obj) {
    writer
      ..writeByte(1)
      ..writeByte(10)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannedCountryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
