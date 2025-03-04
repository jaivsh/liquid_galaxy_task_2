import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:untitled/components/connection_flag.dart';
import '../connections/ssh.dart';

bool connectionStatus = false;
const String searchPlace = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SSH ssh;
  bool _isLoading = false;
  String _tourStatus = '';
  double _tourProgress = 0;

  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _connectToLG();
  }

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    double? fontSize,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 26, color: color),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: fontSize ?? 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Liquid Galaxy App',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () async {
              await Navigator.pushNamed(context, '/settings');
              _connectToLG();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black87),
            onPressed: () async {
              await Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Connection Status
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: ConnectionFlag(
                status: connectionStatus,
              ),
            ),

            // Progress Indicator (only shown when loading)
            if (_isLoading) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _tourProgress >= 0 ? _tourProgress : 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _tourProgress >= 0 ? Colors.blue : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tourStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _tourProgress >= 0 ? Colors.blue : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Grid of Action Cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: constraints.maxWidth / (constraints.maxHeight / 2),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          _buildActionCard(
                            title: 'Relaunch LG',
                            icon: Icons.refresh,
                            color: Colors.blue,
                            onTap: () async {
                              await ssh.relaunchLG();
                            },
                          ),
                          _buildActionCard(
                            title: 'Shutdown LG',
                            icon: Icons.power_settings_new,
                            color: Colors.red,
                            onTap: () async {
                              await ssh.shutdownLG();
                            },
                          ),
                          _buildActionCard(
                            title: 'Clean KML',
                            icon: Icons.cleaning_services,
                            color: Colors.orange,
                            onTap: () async {
                              await ssh.cleanKML();
                            },
                          ),
                          _buildActionCard(
                            title: 'Clean Logo',
                            icon: Icons.clear_all,
                            color: Colors.indigo,
                            onTap: () async {
                              await ssh.cleanLogo();
                            },
                          ),
                          _buildActionCard(
                            title: 'Set Slave\nRefresh',
                            icon: Icons.sync,
                            color: Colors.teal,
                            fontSize: 11.5,
                            onTap: () async {
                              await ssh.setSlaveRefresh();
                            },
                          ),
                          _buildActionCard(
                            title: 'Send KML 1',
                            icon: Icons.send,
                            color: Colors.green,
                            onTap: () async {
                              if (_isLoading) return;
                              setState(() {
                                _isLoading = true;
                                _tourProgress = 0;
                                _tourStatus = 'Initializing...';
                              });

                              await ssh.sendKML1AndStartTour(
                                onProgress: (status, progress) {
                                  setState(() {
                                    print(status);
                                    _tourStatus = status;
                                    _tourProgress = progress;
                                    if (progress == 1.0 || progress == -1) {
                                      _isLoading = false;
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          _buildActionCard(
                            title: 'Send KML 2',
                            icon: Icons.send,
                            color: Colors.green,
                            onTap: () async {
                              if (_isLoading) return;
                              setState(() {
                                _isLoading = true;
                                _tourProgress = 0;
                                _tourStatus = 'Initializing...';
                              });

                              await ssh.sendMarsKML(
                                onProgress: (status, progress) {
                                  setState(() {
                                    print(status);
                                    _tourStatus = status;
                                    _tourProgress = progress;
                                    if (progress == 1.0 || progress == -1) {
                                      _isLoading = false;
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          // _buildActionCard(
                          //   title: 'Send KML 2',
                          //   icon: Icons.send_and_archive,
                          //   color: Colors.deepPurple,
                          //   onTap: () async {
                          //     await ssh.execute();
                          //   },
                          // ),
                          _buildActionCard(
                            title: 'Set Logo',
                            icon: Icons.image,
                            color: Colors.amber,
                            onTap: () async {
                              await ssh.setLogo();
                            },
                          ),
                          _buildActionCard(
                            title: 'Reboot KML',
                            icon: Icons.restart_alt,
                            color: Colors.redAccent,
                            onTap: () async {
                              await ssh.rebootKML();
                            },
                          ),
                        ],
                      );
                    }
                ),
              ),
            ),

            // Footer Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Liquid Galaxy Task 2 application by Jaivardhan Shukla',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}