// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'pages.dart';

StringAttribute lastPhonePrefer = PreferProvider.instance.stringAttribute(key: "lastPhone");

typedef LoginCallback = Future<SingleResult<Widget>> Function(String phone, String pwd);

class LoginPage extends HareWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final HareText _tipText = HareText(
    "",
    style: const TextStyle(color: Colors.redAccent),
    textAlign: TextAlign.center,
  );
  bool _showPassword = false;
  LoginCallback onLogin;



  LoginPage(this.onLogin) : super() {
    _phoneController.text = lastPhonePrefer.value;
  }

  void _login() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    String phone = _phoneController.text.trim();
    String pwd = _pwdController.text.trim();

    SingleResult<Widget> r = await onLogin(phone, pwd);
    if (r.success) {
      lastPhonePrefer.value = phone;
      context.replacePage(r.value);
      return;
    }
    _tipText.update(r.message ?? "未知错误");
  }

  @override
  Widget build(BuildContext context) {
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
          onFieldSubmitted: (s) => _login(),
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
          onPressed: _login,
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(120, 42)),
          child: const Text("登录"),
        ),
        space(height: 8),
        _tipText,
      ]).paddings(hor: 24, top: 24, bottom: 8).carded().constrainedBox(maxWidth: 360),
    ).centered();
  }
}
