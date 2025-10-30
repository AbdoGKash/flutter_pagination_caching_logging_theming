// lib/cubit/theme_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.freezed.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({@Default(false) bool isDark}) = _ThemeState;

  @override
  bool get isDark => throw UnimplementedError();
}
