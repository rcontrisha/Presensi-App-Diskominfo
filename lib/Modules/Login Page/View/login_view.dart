import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userController.emailController,
              decoration: InputDecoration(labelText: 'NIP / E-Mail'),
            ),
            TextField(
              controller: userController.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: userController.rememberMe.value,
                    onChanged: (value) {
                      userController.rememberMe.value =
                          !userController.rememberMe.value;
                    },
                  ),
                ),
                Text('Remember me'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: userController.loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
