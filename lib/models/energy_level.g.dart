part of 'energy_level.dart';

class EnergyLevelAdapter extends TypeAdapter<EnergyLevel> {
  @override
  final int typeId = 1;

  @override
  EnergyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EnergyLevel.quickWin;
      case 1:
        return EnergyLevel.deepFocus;
      case 2:
        return EnergyLevel.lowEffort;
      default:
        return EnergyLevel.quickWin;
    }
  }

  @override
  void write(BinaryWriter writer, EnergyLevel obj) {
    switch (obj) {
      case EnergyLevel.quickWin:
        writer.writeByte(0);
        break;
      case EnergyLevel.deepFocus:
        writer.writeByte(1);
        break;
      case EnergyLevel.lowEffort:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
