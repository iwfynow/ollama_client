import 'package:flutter/material.dart';


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.white
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 18,
      color: Colors.black,
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(selectedColor: Colors.black),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Colors.black;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateColor.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.black;
    }),
    trackOutlineColor: WidgetStatePropertyAll(Colors.black),
  ),
  searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(Color(0xFFF5F5F5))
    )
  );

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  drawerTheme: DrawerThemeData(backgroundColor: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 18,
      color: Colors.white,
    )
  ),
  searchBarTheme: SearchBarThemeData(
    backgroundColor: WidgetStatePropertyAll(Color(0xFF282828)),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    selectedColor: Colors.white,
    fillColor: Color(0xFF282828),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateColor.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Colors.black;
    }),
    trackColor: WidgetStateColor.resolveWith((state) {
      if (state.contains(WidgetState.selected)) {
        return Colors.black;
      }
      return Colors.white;
    }),
    trackOutlineColor: WidgetStatePropertyAll(Colors.white)
  ),
  listTileTheme: ListTileThemeData(textColor: Colors.white),
);

extension ThemeExtension on BuildContext {
  Color get customLongPressColor =>
      Theme.of(this).brightness == Brightness.light ? Colors.grey : Color(0xFF282828);
  Color get customUnselectedColor =>
      Theme.of(this).brightness == Brightness.light ? Colors.white : Colors.black;
  Color get customMessage =>
      Theme.of(this).brightness == Brightness.light ? Color(0xFFDFE1F8) : Color(0xFF282828);
  TextStyle get customMessageTextStyle => TextStyle(
    fontSize: 18,
    color: Theme.of(this).brightness == Brightness.light ? Colors.black : Color(0xFFDFE1F8),
  );



  TextStyle get nameModelsTextStyle => TextStyle(
    fontSize: 15,
    color: Theme.of(this).brightness == Brightness.light ? Colors.black : Color(0xFFDFE1F8),
  );
  Color get nameModelsBorderColor => Theme.of(this).brightness == Brightness.light 
  ? Colors.black : Colors.white;
  Color get showBottomColorChoosen => Theme.of(this).brightness == Brightness.light
  ? Colors.white : Colors.black;
  Color get showBottomColorUnchoosen => Theme.of(this).brightness == Brightness.light
  ? Colors.black : Colors.white;



  TextStyle get customMessageError => TextStyle(color: Colors.red, fontSize: 17);
  Color get customContainerError => Theme.of(this).brightness == Brightness.light ? Color(0xFFFDF8F4) : Color(0xFF17120E);

}
