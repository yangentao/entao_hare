part of 'app.dart';

class ThemeWidget extends StatefulWidget {
  final WidgetBuilder builder;

  const ThemeWidget(this.builder, {super.key});

  @override
  State<ThemeWidget> createState() {
    return ThemeState();
  }

  static ThemeState? of(BuildContext context) {
    return context.findRootAncestorStateOfType();
  }
}

class ThemeState extends State<ThemeWidget> {
  void themeSystem({ThemeData? light, ThemeData? dark}) {
    HareApp.themeMode = ThemeMode.system;
    HareApp.themeDataLight = light ?? ThemeData.light(useMaterial3: false);
    HareApp.themeDataDark = dark ?? ThemeData.dark(useMaterial3: false);
    setState(() {});
  }

  void theme(ThemeData data) {
    if (data.brightness == Brightness.light) {
      HareApp.themeMode = ThemeMode.light;
      HareApp.themeDataLight = data;
    } else {
      HareApp.themeMode = ThemeMode.dark;
      HareApp.themeDataDark = data;
    }
    setState(() {});
  }

  void themeDark({ThemeData? data, Color? seed, bool? useMaterial3}) {
    HareApp.themeMode = ThemeMode.dark;
    if (data != null) {
      HareApp.themeDataDark = data;
    } else if (seed != null) {
      ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.dark);
      HareApp.themeDataDark = ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
    } else if (useMaterial3 != null) {
      HareApp.themeDataDark = ThemeData.dark(useMaterial3: useMaterial3);
    }
    setState(() {});
  }

  void themeLight({ThemeData? data, Color? seed, bool? useMaterial3}) {
    HareApp.themeMode = ThemeMode.light;
    if (data != null) {
      HareApp.themeDataLight = data;
    } else if (seed != null) {
      ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.light);
      HareApp.themeDataLight = ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
    } else if (useMaterial3 != null) {
      HareApp.themeDataLight = ThemeData.light(useMaterial3: useMaterial3);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
