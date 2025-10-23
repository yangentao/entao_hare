part of 'app.dart';

EntaoApp HareApp = EntaoApp();

class EntaoApp {
  String title = "App Title";
  ThemeMode themeMode = ThemeMode.system;
  ThemeData themeDataLight = ThemeData.light(useMaterial3: true);
  ThemeData? themeDataDark = ThemeData.dark(useMaterial3: true);

  GlobalKey<NavigatorState> globalKey = GlobalKey();

  BuildContext get currentContext => globalKey.currentContext!;

  ThemeData get currentTheme => globalKey.currentContext!.themeData;

  ThemeData get themeData => globalKey.currentContext!.themeData;

  TextTheme get textTheme => globalKey.currentContext!.themeData.textTheme;

  double listTileHorizontalTitleGap = 4;
  VoidCallback? onLogout;

  Locale? locale;
  List<Locale>? supportedLocales;
  LocalizationsDelegate<dynamic>? localDelegate;
  String Function(BuildContext)? onGenerateTitle;

  EntaoApp() {
    WidgetsFlutterBinding.ensureInitialized();
    onGlobalContext = () => currentContext;
  }

  Future<void> prepare() async {
    await LocalStore.prepare();
    await Dirs.prepare();
  }

  void logout() {
    onLogout?.call();
  }

  void themeDark({bool? useMaterial3, ThemeData? data, Color? seed}) {
    themeMode = ThemeMode.dark;
    if (data != null) {
      themeDataDark = data;
    } else if (seed != null) {
      themeDataDark = ThemeData(useMaterial3: useMaterial3, colorSchemeSeed: seed, brightness: Brightness.dark);
    } else if (useMaterial3 != null) {
      themeDataDark = ThemeData.dark(useMaterial3: useMaterial3);
    }
  }

  void themeLight({bool? useMaterial3, ThemeData? data, Color? seed}) {
    themeMode = ThemeMode.light;
    if (data != null) {
      themeDataLight = data;
    } else if (seed != null) {
      themeDataLight = ThemeData(useMaterial3: useMaterial3, colorSchemeSeed: seed, brightness: Brightness.light);
    } else if (useMaterial3 != null) {
      themeDataLight = ThemeData.light(useMaterial3: useMaterial3);
    }
  }

  //ListTileTheme
  void run(
    Widget? home, {
    TransitionBuilder? builder,
    ScrollBehavior? scrollBehavior,
    Color? color,
    Map<ShortcutActivator, Intent>? shortcuts,
    Map<Type, Action<Intent>>? actions,
    String? restorationScopeId,
    AnimationStyle? themeAnimationStyle,
  }) {
    runApp(
      MaterialApp(
        onGenerateTitle: onGenerateTitle ?? (c) => title,
        themeMode: themeMode,
        theme: themeDataLight,
        darkTheme: themeDataDark,
        locale: locale,
        supportedLocales: supportedLocales ?? [Locale("zh")],
        localizationsDelegates: [?localDelegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        debugShowCheckedModeBanner: false,
        navigatorKey: globalKey,
        home: home,
        builder: builder ?? appBuilder,
        scrollBehavior: scrollBehavior,
        color: color,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        themeAnimationStyle: themeAnimationStyle,
      ),
    );
  }

  Widget appBuilder(BuildContext context, Widget? w) {
    return Material(
      child: RouterDataWidget(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ListTileTheme(
            horizontalTitleGap: listTileHorizontalTitleGap,
            child: Overlay(
              initialEntries: [OverlayEntry(builder: (ctx) => Container(child: w))],
            ),
          ),
        ),
      ),
    );
  }

  void pop<T>([T? result]) {
    var c = currentContext;
    Navigator.of(c).pop(result);
  }
}
