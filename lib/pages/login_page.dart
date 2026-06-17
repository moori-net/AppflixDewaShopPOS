import 'package:flutter/material.dart';
import 'login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends LoginState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: appUrl,
                    onChanged: (value) => appUrl = value,
                    decoration: const InputDecoration(
                      labelText: 'App URL',
                    ),
                    validator: (String? value) => value?.isNotEmpty ?? false
                        ? null
                        : 'https://dewashop.de',
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: username,
                    onChanged: (value) => username = value,
                    decoration: const InputDecoration(
                      labelText: 'Benutzername',
                    ),
                    validator: (String? value) => value?.isNotEmpty ?? false
                        ? null
                        : 'Bitte geben Sie einen Benutzernamen ein',
                  ),
                  const SizedBox(height: 16.0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      TextFormField(
                        initialValue: password,
                        onChanged: (value) => password = value,
                        obscureText: !passwordVisible,
                        decoration:
                        const InputDecoration(labelText: 'Passwort'),
                        validator: (String? value) => value?.isNotEmpty ?? false
                            ? null
                            : 'Bitte geben Sie ein Passwort ein',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: onTogglePasswordVisibility,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                passwordVisible
                                    ? Icons.remove_red_eye_rounded
                                    : Icons.remove_red_eye_outlined,
                                color: Theme.of(context).colorScheme.onBackground,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            CheckboxListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              visualDensity: VisualDensity.compact,
              value: rememberLogin,
              onChanged: (value) =>
                  setState(() => rememberLogin = value ?? false),
              title: const Text('Login merken'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: ElevatedButton(
                  onPressed: onSubmitUser,
                  child: const Text('Anmelden'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/qr-scanner');
              },
              child: const Text('Zum QR-Code Scanner wechseln'),
            ),
          ],
        ),
      ),
    );
  }
}
