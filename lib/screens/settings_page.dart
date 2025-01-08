import 'package:flutter/material.dart';
import 'package:untitled/components/connection_flag.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:untitled/connections/ssh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool connectionStatus = false;
  late SSH ssh;

  // Controllers and other existing logic remains the same
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _loadSettings();
    _connectToLG();
  }

  // Keep all your existing methods (_connectToLG, _loadSettings, _saveSettings, dispose)
  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    _rigsController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('sshPort') ?? '';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('sshPort', _sshPortController.text);
    }
    if (_rigsController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', _rigsController.text);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.grey[700]),
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.1, end: 0);
  }

  Widget _buildButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, connectionStatus);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Connection Settings',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ConnectionFlag(status: connectionStatus),
                ),
                _buildTextField(
                  controller: _ipController,
                  label: 'IP Address',
                  hint: 'Enter Master IP',
                  icon: Icons.computer,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _usernameController,
                  label: 'LG Username',
                  hint: 'Enter your username',
                  icon: Icons.person,
                ),
                _buildTextField(
                  controller: _passwordController,
                  label: 'LG Password',
                  hint: 'Enter your password',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                _buildTextField(
                  controller: _sshPortController,
                  label: 'SSH Port',
                  hint: '22',
                  icon: Icons.settings_ethernet,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField(
                  controller: _rigsController,
                  label: 'No. of LG rigs',
                  hint: 'Enter the number of rigs',
                  icon: Icons.memory,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildButton(
                  text: 'CONNECT TO LG',
                  icon: Icons.cast,
                  onPressed: () async {
                    await _saveSettings();
                    SSH ssh = SSH();
                    bool? result = await ssh.connectToLG();
                    if (result == true) {
                      setState(() {
                        connectionStatus = true;
                      });
                      print('Connected to LG successfully');
                    }
                  },
                ),
                _buildButton(
                  text: 'SEND COMMAND TO LG',
                  icon: Icons.send,
                  onPressed: () async {
                    SSH ssh = SSH();
                    await ssh.connectToLG();
                    SSHSession? execResult = await ssh.execute();
                    if (execResult != null) {
                      print('Command executed successfully');
                    } else {
                      print('Failed to execute command');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}