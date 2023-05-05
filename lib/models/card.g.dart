// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankCardAdapter extends TypeAdapter<BankCard> {
  @override
  final int typeId = 1;

  @override
  BankCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankCard()
      ..cardNumber = fields[1] as String?
      ..cardHolder = fields[2] as String?
      ..cardType = fields[3] as String?
      ..expiry = fields[4] as String?
      ..cvvNumber = fields[5] as String?
      ..country = fields[6] as String?
      ..lastUpdate = fields[7] as int?;
  }

  @override
  void write(BinaryWriter writer, BankCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.cardNumber)
      ..writeByte(2)
      ..write(obj.cardHolder)
      ..writeByte(3)
      ..write(obj.cardType)
      ..writeByte(4)
      ..write(obj.expiry)
      ..writeByte(5)
      ..write(obj.cvvNumber)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.lastUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
