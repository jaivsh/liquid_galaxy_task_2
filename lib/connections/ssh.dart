import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  // Initialize connection details from shared preferences
  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  // Connect to the Liquid Galaxy system
  Future<bool?> connectToLG() async {
    await initConnectionDetails();

    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );

      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  // Execute demo command
  Future<SSHSession?> execute() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final execResult = await _client!.execute('echo "search=Spain" >/tmp/query.txt');
      print('This one is working!');
          return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  // Relaunch LG Function
  Future<void> relaunchLG() async {
    try {
      if (_client == null) return;

      for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
        String cmd = """RELAUNCH_CMD="\\
          if [ -f /etc/init/lxdm.conf ]; then
            export SERVICE=lxdm
          elif [ -f /etc/init/lightdm.conf ]; then
            export SERVICE=lightdm
          else
            exit 1
          fi
          if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
          else
            echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
          fi
          " && sshpass -p $_passwordOrKey ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";

        await _client?.run(cmd);
      }
    } catch (e) {
      print('Failed to relaunch LG: $e');
    }
  }

  // Shutdown LG Function
  Future<void> shutdownLG() async {
    try {
      if (_client == null) return;

      for (var i = 1; i <= int.parse(_numberOfRigs); i++) {
        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i "echo $_passwordOrKey | sudo -S poweroff"'
        );
      }
    } catch (e) {
      print('Failed to shutdown LG: $e');
    }
  }

  // Clean KML Function
  Future<void> cleanKML() async {
    try {
      if (_client == null) return;

      await _client?.run('echo "" > /tmp/query.txt');
      await _client?.run("echo '' > /var/www/html/kmls.txt");
    } catch (e) {
      print('Failed to clean KML: $e');
    }
  }

  // Clean Logo Function
  Future<void> cleanLogo() async {
    try {
      if (_client == null) return;

      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        await _client?.run("echo '' > /var/www/html/kml/slave_$i.kml");
      }
    } catch (e) {
      print('Failed to clean logo: $e');
    }
  }

  // Set Slave Refresh Function
  Future<void> setSlaveRefresh() async {
    try {
      if (_client == null) return;

      for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\''
        );
      }
    } catch (e) {
      print('Failed to set slave refresh: $e');
    }
  }

  // Send KML Function
  Future<void> sendKML(String kmlName) async {
    try {
      if (_client == null) return;

      await _client?.run(
          "echo '\nhttp://lg1:81/$kmlName.kml' > /var/www/html/kmls.txt"
      );
    } catch (e) {
      print('Failed to send KML: $e');
    }
  }

  // Set Logo Function
  Future<void> setLogo() async {
    try {
      if (_client == null) return;

      const String logoContent = '''<?xml version="1.0" encoding="UTF-8"?>
        <kml xmlns="http://www.opengis.net/kml/2.2">
          <ScreenOverlay>
            <name>Logo</name>
            <Icon>
              <href>https://your-logo-url.com/logo.png</href>
            </Icon>
            <overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
            <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
            <size x="0.2" y="0.2" xunits="fraction" yunits="fraction"/>
          </ScreenOverlay>
        </kml>''';

      await _client?.run(
          "echo '$logoContent' > /var/www/html/kml/slave_1.kml"
      );
    } catch (e) {
      print('Failed to set logo: $e');
    }
  }

  // Reboot KML Function
  Future<void> rebootKML() async {
    try {
      if (_client == null) return;

      await cleanKML();
      await setSlaveRefresh();
      await relaunchLG();
    } catch (e) {
      print('Failed to reboot KML: $e');
    }
  }

  // Function to send and start KML tour with cleanup
  Future<void> sendKML1AndStartTour() async {
    try {
      if (_client == null) return;

      // Read the KML file from assets
      final file = File('assets/kmls/one.kml');
      final kmlContent = await file.readAsString();

      // Upload KML to LG using correct SFTP methods
      final sftp = await _client?.sftp();
      final sftpFile = await sftp?.open('/var/www/html/kmls/one.kml',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
      await sftpFile?.write(kmlContent.codeUnits as Stream<Uint8List>);
      await sftpFile?.close();

      // Link KML in kmls.txt
      await _client?.run(
          "echo '\nhttp://lg1:81/kmls/one.kml' > /var/www/html/kmls.txt"
      );

      // Wait for KML to load
      await Future.delayed(const Duration(seconds: 2));

      // Start the tour with correct name
      await _client?.run('echo "playtour=Asian Historical Cities Tour" > /tmp/query.txt');

      // Calculate total tour duration (all waits and fly durations)
      const int totalDuration = 60; // Add up all your wait and fly durations from KML

      // Wait for tour to complete then cleanup
      await Future.delayed(Duration(seconds: totalDuration));

      // Cleanup: Stop tour and remove KML
      await stopTour();
      await _client?.run('rm /var/www/html/kmls/one.kml');
      await _client?.run('echo "" > /var/www/html/kmls.txt');

    } catch (e) {
      print('Failed to send KML and start tour: $e');
      // Attempt cleanup even if there was an error
      try {
        await stopTour();
        await _client?.run('rm /var/www/html/kmls/one.kml');
        await _client?.run('echo "" > /var/www/html/kmls.txt');
      } catch (e) {
        print('Failed to cleanup after error: $e');
      }
    }
  }

  // Stop tour if needed
  Future<void> stopTour() async {
    try {
      if (_client == null) return;
      await _client?.run('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Failed to stop tour: $e');
    }
  }
}