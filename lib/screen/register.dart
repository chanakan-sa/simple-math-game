import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void registerUser() async {
    FocusScope.of(context).unfocus(); // ซ่อนคีย์บอร์ด

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog("กรุณากรอกอีเมลและรหัสผ่าน");
      return;
    }

    setState(() => isLoading = true);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showSuccessDialog("สมัครสมาชิกสำเร็จ! 🎉");
    } catch (e) {
      showErrorDialog("สมัครสมาชิกไม่สำเร็จ กรุณาลองใหม่");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('สำเร็จ!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text('เกิดข้อผิดพลาด', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('ตกลง'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Simple Math Game')),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 80, color: Colors.blueAccent),
                  Text('สมัครสมาชิก', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  SizedBox(height: 15),
                  _buildTextField(emailController, "Email", Icons.email),
                  SizedBox(height: 15),
                  _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
                  SizedBox(height: 20),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: registerUser,
                          style: _buttonStyle(),
                          icon: Icon(Icons.app_registration, color: Colors.white),
                          label: Text('สมัครสมาชิก', style: TextStyle(fontSize: 18)),
                        ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                    child: Text('มีบัญชีแล้ว? เข้าสู่ระบบ', style: TextStyle(color: Colors.blueAccent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      elevation: 5,
    );
  }
}
