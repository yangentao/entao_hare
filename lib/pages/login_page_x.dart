// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'pages.dart';

/// return token
typedef OnLogin = Future<Result<String>> Function(String phone, String pwd);

/// return main page
typedef OnLoginPrepare = Future<Result<Widget>> Function();

class LoginPageX extends HarePage {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final HareText _tipText = HareText(
    "",
    style: const TextStyle(color: Colors.redAccent),
    textAlign: TextAlign.center,
  );
  final OnLogin _onLogin;
  final OnLoginPrepare _onPrepare;

  bool _showPassword = false;

  // TODO, 这个变量，在登录成功后， 要改变
  bool hasToken;

  LoginPageX({required this.hasToken, required OnLogin login, required OnLoginPrepare prepare}) : _onPrepare = prepare, _onLogin = login, super() {
    _phoneController.text = lastPhonePrefer.value;
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
      Result<String> r = await _onLogin(phone, pwd);
      if (r is Failure) {
        _tipText.update(r.message);
        r.showError();
        return;
      }
      Result<Widget> pr = await _onPrepare();
      if (pr is Failure) {
        _tipText.update(pr.message);
        pr.showError();
        return;
      }
      if (pr is Success<Widget>) {
        lastPhonePrefer.value = phone;
        context.replacePage(pr.value);
      }
    } catch (e) {
      Toast.error("加载失败: $e");
      updateState();
      return;
    }
  }

  Future<void> _tryPrepare() async {
    Result<Widget> pr = await _onPrepare();
    if (pr is Success<Widget>) {
      context.replacePage(pr.value);
    } else {
      updateState();
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
              },
            ),
          ),
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
              },
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _loginClick,
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(120, 42)),
          child: const Text("登录"),
        ),
        space(height: 8),
        _tipText,
      ]).paddings(hor: 24, top: 24, bottom: 8).carded().constrainedBox(maxWidth: 360),
    ).centered();
  }
}
