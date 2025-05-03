part of '../entao_app.dart';

EntaoApp HareApp = EntaoApp();

class EntaoApp {
  String title = "App Title";
  ThemeMode? _themeMode;
  ThemeData _themeData = ThemeData.light(useMaterial3: true);
  ThemeData? _darkThemeData;
  GlobalKey<NavigatorState> globalKey = GlobalKey();
  double listTileHorizontalTitleGap = 4;
  VoidCallback? onLogout;

  BuildContext get currentContext => globalKey.currentContext!;

  ThemeData get currentTheme => globalKey.currentContext!.themeData;

  ThemeData get themeData => globalKey.currentContext!.themeData;

  TextTheme get textTheme => globalKey.currentContext!.themeData.textTheme;

  EntaoApp() {
    WidgetsFlutterBinding.ensureInitialized();
    onGlobalContext = () => currentContext;
  }

  void logout() {
    onLogout?.call();
  }

  void themeDark({bool? useMaterial3}) {
    theme(theme: ThemeData.dark(useMaterial3: useMaterial3 ?? false));
  }

  void themeLight({bool? useMaterial3}) {
    theme(theme: ThemeData.light(useMaterial3: useMaterial3 ?? false));
  }

  void theme({ThemeMode? mode, ThemeData? theme, ThemeData? darkTheme, Color? seedColor, Color? darkSeedColor, bool? useMaterial3}) {
    if (theme != null) {
      _themeData = theme;
    } else if (seedColor != null) {
      _themeData = ThemeData(useMaterial3: useMaterial3, colorSchemeSeed: seedColor, brightness: Brightness.light);
    }
    if (darkTheme != null) {
      _darkThemeData = darkTheme;
    } else if (darkSeedColor != null) {
      _darkThemeData = ThemeData(useMaterial3: useMaterial3, colorSchemeSeed: darkSeedColor, brightness: Brightness.dark);
    }
    if (mode != null) {
      _themeMode = mode;
    } else {
      bool hasLight = theme != null || seedColor != null;
      bool hasDark = darkTheme != null || darkSeedColor != null;
      if (hasLight && !hasDark) {
        _themeMode = ThemeMode.light;
      } else if (hasDark && !hasLight) {
        _themeMode = ThemeMode.dark;
      }
    }
  }

  //ListTileTheme
  void run(Widget? home) {
    runApp(MaterialApp(
      title: title,
      themeMode: _themeMode,
      theme: _themeData,
      darkTheme: _darkThemeData,
      locale: const Locale("zh", 'CN'),
      supportedLocales: const [Locale('zh', 'CN'), Locale('en', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: globalKey,
      home: home,
      builder: _builder,
    ));
  }

  Widget _builder(BuildContext context, Widget? w) {
    return Material(
        child: RouterDataWidget(
            child: Directionality(
      textDirection: TextDirection.ltr,
      child: ListTileTheme(
        horizontalTitleGap: listTileHorizontalTitleGap,
        child: Overlay(initialEntries: [
          OverlayEntry(builder: (ctx) => Container(child: w)),
        ]),
      ),
    )));
  }

  void pop<T>([T? result]) {
    var c = currentContext;
    Navigator.of(c).pop(result);
  }
}
