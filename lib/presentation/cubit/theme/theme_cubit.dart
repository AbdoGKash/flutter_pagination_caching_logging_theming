import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_caching_logging_theming/core/helper/theme_helper.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeStorage _storage;

  ThemeCubit(this._storage) : super(const ThemeState()) {
    final saved = _storage.getIsDark();
    emit(state.copyWith(isDark: saved));
  }

  void toggleTheme() {
    final newValue = !state.isDark;
    emit(state.copyWith(isDark: newValue));
    _storage.setIsDark(newValue);
  }

  void setDark(bool isDark) {
    emit(state.copyWith(isDark: isDark));
    _storage.setIsDark(isDark);
  }
}
