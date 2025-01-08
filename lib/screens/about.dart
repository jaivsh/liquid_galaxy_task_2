import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        title: Text('About Me', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: BackButton(
        color: Colors.black
    ),),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C3E50),
              Color(0xFF4CA1AF),
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Profile Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/mypic.jpeg', // Add your image to assets
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Name
                  Text(
                    'Jaivardhan Shukla',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  // About Content
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildContentSection(
                            "Hello! I am Jaivardhan Shukla, a final-year undergraduate student in the Mining Engineering department at Visvesvaraya National Institute of Technology (VNIT), Nagpur. I am passionate about Flutter development, machine learning, and creating innovative mobile applications. With a strong focus on user experience and intelligent systems, I aim to leverage my technical expertise to create impactful solutions."
                        ),
                        SizedBox(height: 15),
                        _buildContentSection(
                            "My journey into app development began with a fascination for how mobile applications can transform user experiences and drive innovation. Over the years, I have worked on various projects involving Flutter, Firebase, state management, and API integration, while also exploring machine learning integration in mobile apps."
                        ),
                        SizedBox(height: 15),
                        _buildContentSection(
                            "I am particularly interested in developing cross-platform applications, implementing complex UI/UX designs, and creating intelligent mobile solutions that address real-world challenges. In addition to my academic pursuits, I actively participate in Flutter communities, contribute to open-source projects, and continuously enhance my skills in mobile development and machine learning."
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Social Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        FontAwesomeIcons.linkedin,
                        'https://www.linkedin.com/in/jaivardhan-shukla-3633a2190',
                      ),
                      SizedBox(width: 20),
                      _buildSocialButton(
                        FontAwesomeIcons.github,
                        'https://github.com/jaivsh',
                      ),
                      SizedBox(width: 20),
                      _buildSocialButton(
                        FontAwesomeIcons.instagram,
                        'https://www.instagram.com/jaivardhan_shukla/',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(String content) {
    return Text(
      content,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white,
        height: 1.5,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildSocialButton(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}