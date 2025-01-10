import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/entities/screen_overlay_entity.dart';

import '../entities/kml_entity.dart';
import 'dart:convert'; // For utf8 encoding
import 'dart:typed_data'; // For Uint8List
import 'dart:async';


class KMLContent {
  static const String asianCitiesKML = r'''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>Asian Historical Cities Tour</name>

    <!-- City Information Overlays with improved styling -->
    <ScreenOverlay id="info-kyoto">
      <name>Kyoto Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px; border-left: 4px solid #ffaa00;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Kyoto (794-1868)</h2>
          • Japan's imperial capital for over 1000 years<br/>
          • 1600 Buddhist temples, 400 Shinto shrines<br/>
          • 17 UNESCO World Heritage sites<br/>
          • Center of Japanese arts and culture
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-xian">
      <name>Xian Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px; border-left: 4px solid #ffaa00;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Xi'an (Chang'an)</h2>
          • Eastern terminus of the Silk Road<br/>
          • Capital of 13 dynasties<br/>
          • Home to Terracotta Army<br/>
          • World's largest city during Tang Dynasty
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-angkor">
      <name>Angkor Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px; border-left: 4px solid #ffaa00;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Angkor (802-1431)</h2>
          • Capital of Khmer Empire<br/>
          • World's largest pre-industrial city<br/>
          • Home to Angkor Wat temple complex<br/>
          • Advanced hydraulic engineering system
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-delhi">
      <name>Delhi Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px; border-left: 4px solid #ffaa00;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Delhi - City of Seven Cities</h2>
          • Capital of Delhi Sultanate and Mughals<br/>
          • Home to Red Fort and Qutub Minar<br/>
          • Center of Indo-Islamic architecture<br/>
          • Multiple historic cities within modern Delhi
        </div>
      ]]></description>
    </ScreenOverlay>

    <ScreenOverlay id="info-istanbul">
      <name>Istanbul Info</name>
      <visibility>0</visibility>
      <overlayXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
      <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
      <size x="0.4" y="0.25" xunits="fraction" yunits="fraction"/>
      <description><![CDATA[
        <div style="color: white; font-family: Arial; font-size: 18px; background-color: rgba(0,0,0,0.85); padding: 20px; border-radius: 10px; border-left: 4px solid #ffaa00;">
          <h2 style="color: #ffaa00; margin: 0 0 10px 0;">Istanbul (Constantinople)</h2>
          • Capital of Roman, Byzantine, Ottoman Empires<br/>
          • Home to Hagia Sophia and Blue Mosque<br/>
          • Strategic location on Bosphorus Strait<br/>
          • Bridge between Europe and Asia
        </div>
      ]]></description>
    </ScreenOverlay>

    <gx:Tour>
      <name>City Tour</name>
      <gx:Playlist>
        <!-- Initial view -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>100</longitude>
            <latitude>30</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>0</tilt>
            <range>10000000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <!-- Kyoto -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>135.7681</longitude>
            <latitude>35.0116</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>50000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>
        
        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <gx:FlyTo>
          <gx:duration>2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>135.7681</longitude>
            <latitude>35.0116</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>5000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <!-- Xi'an -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>108.9398</longitude>
            <latitude>34.3416</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>50000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <gx:FlyTo>
          <gx:duration>2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>108.9398</longitude>
            <latitude>34.3416</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>5000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <!-- Angkor -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>103.8667</longitude>
            <latitude>13.4125</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>50000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <gx:FlyTo>
          <gx:duration>2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>103.8667</longitude>
            <latitude>13.4125</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>5000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <!-- Delhi -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>77.2090</longitude>
            <latitude>28.6139</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>50000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <gx:FlyTo>
          <gx:duration>2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>77.2090</longitude>
            <latitude>28.6139</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>5000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <!-- Istanbul -->
        <gx:FlyTo>
          <gx:duration>3</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>28.9784</longitude>
            <latitude>41.0082</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>50000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

        <gx:FlyTo>
          <gx:duration>2</gx:duration>
          <gx:flyToMode>smooth</gx:flyToMode>
          <LookAt>
            <longitude>28.9784</longitude>
            <latitude>41.0082</latitude>
            <altitude>0</altitude>
            <heading>0</heading>
            <tilt>60</tilt>
            <range>5000</range>
            <altitudeMode>relativeToGround</altitudeMode>
          </LookAt>
        </gx:FlyTo>

        <gx:Wait>
          <gx:duration>3</gx:duration>
        </gx:Wait>

      </gx:Playlist>
    </gx:Tour>
  </Document>
</kml>''';
  static const String marsCraterTourKML =r'''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2">
  <Document>
    <name>Mars Crater Tour</name>
    <description>A virtual tour of famous craters on Mars: Gale, Jezero, and Hellas Basin.</description>

    <!-- Switch to Mars -->
    <NetworkLink>
      <name>Switch to Mars</name>
      <Link>
        <href>http://lg1:81/mars.kml</href>
      </Link>
    </NetworkLink>

    <!-- Gale Crater -->
    <Placemark>
      <name>Gale Crater</name>
      <description>Gale Crater is home to Mount Sharp and was the landing site of the Curiosity rover. It offers key evidence of past water activity.</description>
      <Point>
        <coordinates>137.4,-4.6</coordinates>
      </Point>
      <LookAt>
        <longitude>137.4</longitude>
        <latitude>-4.6</latitude>
        <altitude>5000</altitude>
        <range>300000</range>
        <tilt>45</tilt>
        <heading>0</heading>
      </LookAt>
    </Placemark>

    <!-- Jezero Crater -->
    <Placemark>
      <name>Jezero Crater</name>
      <description>Jezero Crater is the landing site of the Perseverance rover. It features a delta system that could hold signs of ancient microbial life.</description>
      <Point>
        <coordinates>77.6,18.4</coordinates>
      </Point>
      <LookAt>
        <longitude>77.6</longitude>
        <latitude>18.4</latitude>
        <altitude>5000</altitude>
        <range>300000</range>
        <tilt>45</tilt>
        <heading>0</heading>
      </LookAt>
    </Placemark>

    <!-- Hellas Basin -->
    <Placemark>
      <name>Hellas Basin</name>
      <description>Hellas Basin is one of the largest impact basins in the solar system, with a depth of about 7 kilometers.</description>
      <Point>
        <coordinates>70.0,-42.0</coordinates>
      </Point>
      <LookAt>
        <longitude>70.0</longitude>
        <latitude>-42.0</latitude>
        <altitude>5000</altitude>
        <range>500000</range>
        <tilt>45</tilt>
        <heading>0</heading>
      </LookAt>
    </Placemark>

    <!-- gx:Tour for a guided experience -->
    <gx:Tour>
      <name>Mars Crater Guided Tour</name>
      <gx:Playlist>
        <!-- Gale Crater Flyover -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <LookAt>
            <longitude>137.4</longitude>
            <latitude>-4.6</latitude>
            <altitude>5000</altitude>
            <range>100000</range>
            <tilt>60</tilt>
            <heading>0</heading>
          </LookAt>
        </gx:FlyTo>

        <!-- Jezero Crater Flyover -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <LookAt>
            <longitude>77.6</longitude>
            <latitude>18.4</latitude>
            <altitude>5000</altitude>
            <range>100000</range>
            <tilt>60</tilt>
            <heading>0</heading>
          </LookAt>
        </gx:FlyTo>

        <!-- Hellas Basin Flyover -->
        <gx:FlyTo>
          <gx:duration>5.0</gx:duration>
          <LookAt>
            <longitude>70.0</longitude>
            <latitude>-42.0</latitude>
            <altitude>5000</altitude>
            <range>200000</range>
            <tilt>60</tilt>
            <heading>0</heading>
          </LookAt>
        </gx:FlyTo>
      </gx:Playlist>
    </gx:Tour>

    <!-- Switch back to Earth -->
    <NetworkLink>
      <name>Switch back to Earth</name>
      <Link>
        <href>http://lg1:81/earth.kml</href>
      </Link>
    </NetworkLink>

  </Document>
</kml>
''';
}
// Progress callback type
typedef ProgressCallback = void Function(String status, double progress);

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  int get leftScreen {
    final rigs = int.tryParse(_numberOfRigs);
    if (rigs == null || rigs <= 0) {
      return 1;
    }
    if (rigs == 1) {
      return 1;
    }
    return (rigs / 2).floor() + 2;
  }

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
  //Future<void> cleanLogo() async {
   // try {
     // if (_client == null) return;

      //for (var i = 2; i <= int.parse(_numberOfRigs); i++) {
       // await _client?.run("echo '' > /var/www/html/kml/slave_$i.kml");
     // }
    //} catch (e) {
     // print('Failed to clean logo: $e');
   // }
 // }

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
  //Future<void> setLogo() async {
    //try {
      //if (_client == null) return;

      //const String logoContent = '''<?xml version="1.0" encoding="UTF-8"?>
        //<kml xmlns="http://www.opengis.net/kml/2.2">
         // <ScreenOverlay>
         //   <name>Logo</name>
          //  <Icon>
           //   <href>https://1.bp.blogspot.com/-POkV83Ut-7k/XdjpKI4M8AI/AAAAAAAHdXA/VSFXPJQsIOkdqtkJrGnh59WxaRqaQEtmQCLcBGAsYHQ/s1600/LOGO%2BLIQUID%2BGALAXY-sq1000-%2BOKnoline.png</href>
            //</Icon>
            //<overlayXY x="0" y="1" xunits="fraction" yunits="fraction"/>
            //<screenXY x="0.02" y="0.98" xunits="fraction" yunits="fraction"/>
            //<size x="0.2" y="0.2" xunits="fraction" yunits="fraction"/>
          //</ScreenOverlay>
        //</kml>''';

      //await _client?.run(
        //  "echo '$logoContent' > /var/www/html/kml/slave_1.kml"
      //);
    //} catch (e) {
      //print('Failed to set logo: $e');
   // }
 // }

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

  Future<void> sendKML1AndStartTour({ProgressCallback? onProgress}) async {
    try {
      if (_client == null) {
        onProgress?.call('Error: SSH client not initialized', 0);
        return;
      }

      // Step 1: Create directory
      onProgress?.call('Preparing environment...', 0.1);
      await _client?.run('mkdir -p /var/www/html/kmls');

      // Step 2: Upload KML content
      onProgress?.call('Uploading KML file...', 0.2);
      final sftp = await _client?.sftp();
      final sftpFile = await sftp?.open('/var/www/html/kmls/asian_cities.kml',
          mode: SftpFileOpenMode.create | SftpFileOpenMode.write);

      // Convert string to Stream<Uint8List> and write
      final kmlStream = Stream.fromIterable(
          [Uint8List.fromList(utf8.encode(KMLContent.asianCitiesKML))]
      );
      await sftpFile?.write(kmlStream);
      await sftpFile?.close();

      onProgress?.call('KML file uploaded successfully', 0.3);
      print(sftpFile.toString());

      // Step 3: Link the KML file
      onProgress?.call('Configuring tour...', 0.35);
      await _client?.run('echo "http://lg1:81/kmls/asian_cities.kml" > /var/www/html/kmls.txt');

      // Step 4: Start the tour
      onProgress?.call('Initializing tour...', 0.4);
      await Future.delayed(const Duration(seconds: 2));
      await _client?.run('echo "playtour=City Tour" > /tmp/query.txt');

      // Step 5: Track tour progress
      onProgress?.call('Visiting Kyoto...', 0.5);
      await Future.delayed(const Duration(seconds: 11));

      onProgress?.call('Visiting Xi\'an...', 0.6);
      await Future.delayed(const Duration(seconds: 11));

      onProgress?.call('Visiting Angkor...', 0.7);
      await Future.delayed(const Duration(seconds: 11));

      onProgress?.call('Visiting Delhi...', 0.8);
      await Future.delayed(const Duration(seconds: 11));

      onProgress?.call('Visiting Istanbul...', 0.9);
      await Future.delayed(const Duration(seconds: 11));

      // Step 6: Cleanup
      onProgress?.call('Finalizing tour...', 0.95);
      await _client?.run('echo "exittour=true" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 1));
      await _client?.run('rm /var/www/html/kmls/asian_cities.kml');
      await _client?.run('echo "" > /var/www/html/kmls.txt');

      onProgress?.call('Tour completed successfully', 1.0);
    } catch (e) {
      onProgress?.call('Error during tour: $e', -1);
      // Cleanup on error
      try {
        await _client?.run('echo "exittour=true" > /tmp/query.txt');
        await _client?.run('rm /var/www/html/kmls/asian_cities.kml');
        await _client?.run('echo "" > /var/www/html/kmls.txt');
        onProgress?.call('Cleanup completed after error', -1);
      } catch (cleanupError) {
        onProgress?.call('Failed to cleanup after error: $cleanupError', -1);
      }
    }
  }

  Future<void> sendMarsKML({ProgressCallback? onProgress}) async {
    try {
      if (_client == null) {
        onProgress?.call('Error: SSH client not initialized', 0);
        return;
      }

      onProgress?.call('Preparing Mars tour...', 0.1);

      // Switch to Mars
      await _client?.run('echo "planet=mars" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 2));

      // Upload and start tour
      onProgress?.call('Uploading Mars tour...', 0.3);
      await _client?.run('echo \'${KMLContent.marsCraterTourKML}\' > /var/www/html/kmls/mars_tour.kml');
      await _client?.run('echo "http://lg1:81/kmls/mars_tour.kml" > /var/www/html/kmls.txt');

      onProgress?.call('Starting Mars tour...', 0.5);
      await Future.delayed(const Duration(seconds: 2));
      await _client?.run('echo "playtour=Mars Crater Guided Tour" > /tmp/query.txt');

      // Wait for tour completion
      await Future.delayed(const Duration(seconds: 25));

      // Switch back to Earth
      onProgress?.call('Returning to Earth...', 0.9);
      await _client?.run('echo "planet=earth" > /tmp/query.txt');
      await Future.delayed(const Duration(seconds: 2));

      onProgress?.call('Tour completed', 1.0);

    } catch (e) {
      onProgress?.call('Error: $e', -1);
    }
  }

  Future<void> stopTour() async {
    try {
      if (_client == null) return;
      await _client?.run('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Failed to stop tour: $e');
    }
  }

  Future<void> setLogo() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return;
      }

      // Create screen overlay using the entity
      final screenOverlay = ScreenOverlayEntity.logos();

      // Create KML entity
      final kml = KMLEntity(
        name: 'LG-Logo',
        content: '<name>Liquid Galaxy Logo</name>',
        screenOverlay: screenOverlay.tag,
      );

      // Send to the correct slave screen
      await _client?.run(
          "echo '${kml.body}' > /var/www/html/kml/slave_$leftScreen.kml"
      );

      print('Logo set successfully on screen $leftScreen');
    } catch (e) {
      print('Failed to set logo: $e');
    }
  }

  Future<void> cleanLogo() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return;
      }

      // Create a blank KML
      String blankKML = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document id="blank">
  </Document>
</kml>''';

      // Clean the logo from the left screen
      await _client?.run(
          "echo '$blankKML' > /var/www/html/kml/slave_$leftScreen.kml"
      );

      print('Logo cleaned successfully from screen $leftScreen');
    } catch (e) {
      print('Failed to clean logo: $e');
    }
  }
}