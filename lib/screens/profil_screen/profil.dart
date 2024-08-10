import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    String gender = "Erkek";
    var textSize = 10.0;
    final PageController _pageController = PageController();
    int _currentPage = 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: ListView(
        children: [

      Expanded(   child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ClipOval(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 10,
                        backgroundColor: Colors.black,
                        child: Icon(gender == "Erkek" ? Icons.person : Icons.person_2, color: Colors.white, size: 50,),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text("Tevfik Ali Mutlu", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)),
                  Center(
                    child: Text("Katılma Tarihi - Ocak 2024", style: GoogleFonts.quicksand(fontSize: 10.0, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView( // Eklendi: SingleChildScrollView widget'ı
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          buildInfoRow("Telefon Numarası", "+90 551 021 95 21"),
                          SizedBox(height: textSize * 2),
                          buildInfoRow("E-mail Adresi", "tevfikalimutlu@hotmail.com"),
                          SizedBox(height: textSize * 2),
                          buildInfoRow("Cinsiyet",  gender),
                          SizedBox(height: textSize * 2),
                          buildInfoRow("Kullandığı Araç", "Araba"),
                          SizedBox(height: textSize * 2),
                          buildInfoRow("Konum", "Ankara"),
                          SizedBox(height: textSize * 2),
                          buildInfoRow("Ehliyet Sınıfı", "B"),
                        ],
                      ),
                    ),
                    buildInfoContainer("Yardım & Destek", Icons.question_mark, color: Colors.white),
                    buildInfoContainer("Gizlilik Politikası", Icons.security, color: Colors.white),
                    buildInfoContainer("TEKNOFEST Akıllı Ulaşım Yarışması", Icons.airplanemode_active_outlined, color: Colors.white),
                    buildInfoContainer("Yasal Bildiri", Icons.warning_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoContainer(String text, IconData icon, {Color? color}) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 25, color: color,),
              SizedBox(width: 15.0,),
              Text(text, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 12.0, color: color)),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined, size: 20.0, color: color),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.quicksand(fontSize: 12.0, color: Colors.white)),
        Text(value, style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white)),
      ],
    );
  }
}