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
  Widget Function(MaterialApp)? onBeforeRunApp;

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

  void themeDark({ThemeData? data, Color? seed, bool? useMaterial3}) {
    themeMode = ThemeMode.dark;
    if (data != null) {
      themeDataDark = data;
    } else if (seed != null) {
      ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.dark);
      themeDataDark = ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
    } else if (useMaterial3 != null) {
      themeDataDark = ThemeData.dark(useMaterial3: useMaterial3);
    }
  }

  void themeLight({ThemeData? data, Color? seed, bool? useMaterial3}) {
    themeMode = ThemeMode.light;
    if (data != null) {
      themeDataLight = data;
    } else if (seed != null) {
      ColorScheme cs = ColorScheme.fromSeed(seedColor: seed, dynamicSchemeVariant: DynamicSchemeVariant.fidelity, brightness: Brightness.light);
      themeDataLight = ThemeData.from(colorScheme: cs, useMaterial3: useMaterial3);
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
    MaterialApp app = MaterialApp(
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
    );
    if (onBeforeRunApp == null) {
      runApp(app);
    } else {
      runApp(onBeforeRunApp!(app));
    }
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
