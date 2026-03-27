// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TutorAdapter extends TypeAdapter<Tutor> {
  @override
  final int typeId = 2;

  @override
  Tutor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tutor(
      serverId: fields[0] as int,
      lastname: fields[1] as String,
      firstname: fields[2] as String,
      patronymic: fields[3] as String,
      experience: fields[4] as int,
      description: fields[5] as String,
      subjects: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Tutor obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.serverId)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.patronymic)
      ..writeByte(4)
      ..write(obj.experience)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TutorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
