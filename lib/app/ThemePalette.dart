part of 'app.dart';

final StringOptional themePrefer = PreferProvider.instance.stringOptional(key: "themeIdent");

class ThemePalette {
  final String ident;
  final Color color;
  final ThemeData? data;
  final WidgetBuilder? onDisplay;

  ThemePalette({required this.ident, required this.color, this.data, this.onDisplay});

  /// after HareApp.prepare()
  static bool loadTheme() {
    String? th = themePrefer.value;
    if (th == null) return false;
    ThemePalette? p = themeList.firstOr((e) => e.ident == th);
    if (p == null) return false;
    switch (th) {
      case T_SYS:
        HareApp.themeMode = ThemeMode.system;
        HareApp.themeDataLight = ThemeData.light(useMaterial3: false);
        HareApp.themeDataDark = ThemeData.dark(useMaterial3: false);
      case T_LIGHT:
        HareApp.themeMode = ThemeMode.light;
        HareApp.themeDataLight = ThemeData.light(useMaterial3: false);
      case T_DARK:
        HareApp.themeMode = ThemeMode.dark;
        HareApp.themeDataDark = ThemeData.dark(useMaterial3: false);
      default:
        ThemeData td = p._themeData();
        if (td.brightness == Brightness.light) {
          HareApp.themeMode = ThemeMode.light;
          HareApp.themeDataLight = td;
        } else {
          HareApp.themeMode = ThemeMode.dark;
          HareApp.themeDataDark = td;
        }
    }
    return true;
  }

  void _apply() {
    if (ident == T_SYS) {
      HareApp.themeState?.themeSystem();
    } else {
      HareApp.themeState?.theme(_themeData());
    }
    themePrefer.value = ident;
  }

  ThemeData _themeData() {
    if (data != null) return data!;
    switch (ident) {
      case T_SYS:
        return ThemeData.light(useMaterial3: false);
      case T_LIGHT:
        return ThemeData.light(useMaterial3: false);
      case T_DARK:
        return ThemeData.dark(useMaterial3: false);
      default:
        return LightThemeData(seed: color, useMaterial3: false);
    }
  }

  Widget _displayWidget() {
    switch (ident) {
      case T_SYS:
        return T_SYS.text(align: TextAlign.center, color: Colors.black87).centered().coloredBox(color);
      case T_LIGHT:
        return T_LIGHT.text(align: TextAlign.center, color: Colors.black87).centered().coloredBox(color);
      case T_DARK:
        return T_DARK.text(align: TextAlign.center, color: Colors.white).centered().coloredBox(color);
      default:
        return ColoredBox(color: color);
    }
  }

  static void showPalette(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return XGridView(
          items: themeList,
          itemView: (c) => (c.item.onDisplay?.call(ctx) ?? c.item._displayWidget()).container().inkWell(
            onTap: () {
              c.item._apply();
              HareApp.pop();
            },
          ),
          shrinkWrap: true,
          crossAxisExtent: 80,
          mainAxisExtent: 60,
        );
      },
    );
  }

  static List<ThemePalette> themeList = [
    ThemePalette(ident: T_SYS, color: Colors.white60),
    ThemePalette(ident: T_LIGHT, color: Colors.white60),
    ThemePalette(ident: T_DARK, color: Colors.black87),
    ThemePalette(ident: "pink", color: Colors.pink),
    ThemePalette(ident: "pinkAccent", color: Colors.pinkAccent),
    ThemePalette(ident: "red", color: Colors.red),
    ThemePalette(ident: "redAccent", color: Colors.redAccent),
    ThemePalette(ident: "deepOrange", color: Colors.deepOrange),
    ThemePalette(ident: "deepOrangeAccent", color: Colors.deepOrangeAccent),
    ThemePalette(ident: "orange", color: Colors.orange),
    ThemePalette(ident: "orangeAccent", color: Colors.orangeAccent),
    ThemePalette(ident: "amber", color: Colors.amber),
    ThemePalette(ident: "amberAccent", color: Colors.amberAccent),
    ThemePalette(ident: "yellow", color: Colors.yellow),
    ThemePalette(ident: "yellowAccent", color: Colors.yellowAccent),
    ThemePalette(ident: "limeAccent", color: Colors.limeAccent),
    ThemePalette(ident: "lime", color: Colors.lime),
    ThemePalette(ident: "lightGreenAccent", color: Colors.lightGreenAccent),
    ThemePalette(ident: "lightGreen", color: Colors.lightGreen),
    ThemePalette(ident: "green", color: Colors.green),
    ThemePalette(ident: "teal", color: Colors.teal),
    ThemePalette(ident: "greenAccent", color: Colors.greenAccent),
    ThemePalette(ident: "cyanAccent", color: Colors.cyanAccent),
    ThemePalette(ident: "tealAccent", color: Colors.tealAccent),
    ThemePalette(ident: "cyan", color: Colors.cyan),
    ThemePalette(ident: "lightBlueAccent", color: Colors.lightBlueAccent),
    ThemePalette(ident: "lightBlue", color: Colors.lightBlue),
    ThemePalette(ident: "blue", color: Colors.blue),
    ThemePalette(ident: "blueAccent", color: Colors.blueAccent),
    ThemePalette(ident: "indigoAccent", color: Colors.indigoAccent),
    ThemePalette(ident: "indigo", color: Colors.indigo),
    ThemePalette(ident: "deepPurpleAccent", color: Colors.deepPurpleAccent),
    ThemePalette(ident: "deepPurple", color: Colors.deepPurple),
    ThemePalette(ident: "purple", color: Colors.purple),
    ThemePalette(ident: "purpleAccent", color: Colors.purpleAccent),
    ThemePalette(ident: "brown", color: Colors.brown),
  ];
  static const String T_SYS = "跟随系统";
  static const String T_LIGHT = "浅色";
  static const String T_DARK = "深色";
}
