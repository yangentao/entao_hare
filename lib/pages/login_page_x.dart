// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'pages.dart';

/// return token
typedef OnLogin = Future<DataResult<String>> Function(String phone, String pwd);

/// return main page
typedef OnLoginPrepare = Future<DataResult<Widget>> Function();

class LoginPageX extends HarePage {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final HareText _tipText = HareText("", style: const TextStyle(color: Colors.redAccent), textAlign: TextAlign.center);
  final OnLogin _onLogin;
  final OnLoginPrepare _onPrepare;
  final LocalStringOpt _token;
  final LocalStringOpt _lastPhone = LocalStringOpt("lastPhone");
  bool _showPassword = false;

  bool get hasToken => _token.value != null;

  LoginPageX({String tokenKey = "token", required OnLogin login, required OnLoginPrepare prepare})
      : _onPrepare = prepare,
        _onLogin = login,
        _token = LocalStringOpt(tokenKey),
        super() {
    _phoneController.text = _lastPhone.value ?? "";
  }

  Future<void> _loginClick() async {
    loading(_tryLogin);
  }

  Future<void> _tryLogin() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    String phone = _phoneController.text.trim();
    String pwd = _pwdController.text.trim();

    try {
      DataResult<String> r = await _onLogin(phone, pwd);
      if (!r.success) {
        _tipText.update(r.message ?? "未知错误");
        r.showMessage();
        return;
      }
      _token.value = r.data!;
      DataResult<Widget> pr = await _onPrepare();
      if (!pr.success) {
        _token.value = null;
        _tipText.update(pr.message ?? "未知错误");
        pr.showMessage();
        return;
      }
      _lastPhone.value = phone;
      context.replacePage(pr.data!);
    } catch (e) {
      _token.value = null;
      Toast.error("加载失败: $e");
      updateState();
      return;
    }
  }

  Future<void> _tryPrepare() async {
    DataResult<Widget> pr = await _onPrepare();
    if (!pr.success) {
      _token.value = null;
      updateState();
    } else {
      context.replacePage(pr.data!);
    }
  }

  @override
  void postCreate() {
    super.postCreate();
    if (hasToken) {
      _tryPrepare();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasToken) {
      return "正在加载...".text(fontSize: 14).centered();
    }
    return Form(
      key: _formKey,
      child: ColumnMin([
        TextFormField(
          controller: _phoneController,
          cursorColor: Colors.deepOrange,
          maxLength: 32,
          validator: LengthValidator(minLength: 1, maxLength: 128, allowEmpty: false).call,
          decoration: InputDecoration(
              labelText: "手机号",
              prefixIcon: const Icon(Icons.person),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _phoneController.clear();
                  })),
        ),
        TextFormField(
          controller: _pwdController,
          cursorColor: Colors.deepOrange,
          obscureText: !_showPassword,
          maxLength: 32,
          onFieldSubmitted: (s) => _loginClick(),
          validator: LengthValidator(minLength: 1, maxLength: 128, allowEmpty: false).call,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: "密码",
              suffixIcon: IconButton(
                  icon: _showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                  onPressed: () {
                    _showPassword = !_showPassword;
                    updateState();
                  })),
        ),
        ElevatedButton(
          onPressed: _loginClick,
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(120, 42)),
          child: const Text("登录"),
        ),
        space(height: 8),
        _tipText
      ]).paddings(hor: 24, top: 24, bottom: 8).carded().constrainedBox(maxWidth: 360),
    ).centered();
  }
}
