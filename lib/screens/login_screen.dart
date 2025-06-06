import 'package:flutter/material.dart';
import '../models/login_type.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final FocusNode _loginFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool _loading = false;
  bool _rememberMe = false;

  late AnimationController _logoAnimController;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _logoAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimController, curve: Curves.easeIn),
    );

    _logoAnimController.forward();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _loginCtrl.text = prefs.getString('saved_login') ?? '';
        _passCtrl.text = prefs.getString('saved_password') ?? '';
      }
    });
  }

  @override
  void dispose() {
    _loginCtrl.dispose();
    _passCtrl.dispose();
    _loginFocus.dispose();
    _passFocus.dispose();
    _logoAnimController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);

    final creds = LoginType(
      login: _loginCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    final success = await ApiService.signIn(creds);

    setState(() => _loading = false);

    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe && success) {
      await prefs.setString('saved_login', creds.login);
      await prefs.setString('saved_password', creds.password);
    } else {
      await prefs.remove('saved_login');
      await prefs.remove('saved_password');
    }
    await prefs.setBool('remember_me', _rememberMe);

    if (success) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _logoOpacity,
                  child: Image.asset('assets/logo-light1.png', height: 150),
                ),
                SizedBox(height: 10),
                _buildAnimatedInput(
                  label: 'Login',
                  controller: _loginCtrl,
                  focusNode: _loginFocus,
                  icon: Icons.person,
                ),
                _buildAnimatedInput(
                  label: 'Password',
                  controller: _passCtrl,
                  focusNode: _passFocus,
                  obscureText: true,
                  icon: Icons.lock,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() => _rememberMe = value!);
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    Text('Remember me', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 20),
                _loading
                    ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                    )
                    : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedInput({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    bool obscureText = false,
  }) {
    return AnimatedBuilder(
      animation: focusNode,
      builder: (context, _) {
        bool hasFocus = focusNode.hasFocus;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: hasFocus ? Colors.grey[850] : Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFocus ? Colors.blueAccent : Colors.grey[700]!,
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            style: TextStyle(color: Colors.white),
            obscureText: obscureText,
            cursorColor: Colors.blueAccent,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: hasFocus ? Colors.blueAccent : Colors.grey[500],
              ),
              icon: Icon(
                icon,
                color: hasFocus ? Colors.blueAccent : Colors.grey[500],
              ),
              border: InputBorder.none,
            ),
          ),
        );
      },
    );
  }
}
