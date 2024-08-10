import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_risk_information_system/screens/map_screen/google_maps_view.dart';

bool darkMode = true;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int decibel = 4;
  bool purpleCheckBox = true;
  bool blackCheckBox = true;
  bool blueCheckBox = true;
  bool orangeCheckBox = true;
  bool redCheckBox = true;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  leading: const Icon(
                    Icons.layers_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Harita Ayarları",
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        mapType = MapType.normal;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/normal.jpeg'),
                            radius: 25,
                          ),
                          const SizedBox(height: 15,),
                          Text("Varsayılan", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: mapType == MapType.normal ? Colors.white : Colors.grey, fontSize: 12),),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        mapType = MapType.hybrid;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/hybrid.jpeg'),
                            radius: 25,
                          ),
                          const SizedBox(height: 15,),
                          Text("Uydu", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: mapType == MapType.hybrid ? Colors.white : Colors.grey, fontSize: 12),),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        mapType = MapType.none;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/none.jpeg'),
                            radius: 25,
                          ),
                          const SizedBox(height: 15,),
                          Text("Tanımsız", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: mapType == MapType.none ? Colors.white : Colors.grey, fontSize: 12),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

                  trafficMapSetting(),
            darkModeSetting(),
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  leading: const Icon(
                    Icons.app_settings_alt,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Diğer Ayarlar",
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )),
            ),
           powerModeSetting(),
            decibelSetting(),
            ListTile(
              leading: Icon(Icons.language, color: Colors.white,),
              title: Text("Dil Seçenekleri", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
              subtitle: Text("Uygulama ve risk uyarılarının dil ayarları", style: GoogleFonts.quicksand(fontSize: 10),),
            ),

            Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.circle, color: Colors.white,),
                    title: Text("Risk Noktası Uyarısı", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
                    subtitle: Text("Hangi risk noktalarında uyarı alacağınızı düzenleyin", style: GoogleFonts.quicksand(fontSize: 10),),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                            child: IconButton(onPressed: () {
                              setState(() {
                                purpleCheckBox = !purpleCheckBox;
                              });
                            }, icon: Icon(purpleCheckBox ? Icons.check : Icons.close, color: Colors.purple,))
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: 70,
                            height: 70,
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(1000),
                            ),
                            child: IconButton(onPressed: () {
                              setState(() {
                                blackCheckBox = !blackCheckBox;
                              });
                            }, icon: Icon(blackCheckBox ? Icons.check : Icons.close, color: Colors.white,))
                        ),
                      ),

                  Expanded(
                    child: Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: IconButton(onPressed: () {
                          setState(() {
                            blueCheckBox = !blueCheckBox;
                          });
                        }, icon: Icon(blueCheckBox ? Icons.check : Icons.close, color: Colors.blue,))
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: IconButton(onPressed: () {
                          setState(() {
                            orangeCheckBox = !orangeCheckBox;
                          });
                        }, icon: Icon(orangeCheckBox ? Icons.check : Icons.close, color: Colors.orange,))
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: IconButton(onPressed: () {
                          setState(() {
                            redCheckBox = !redCheckBox;
                          });
                        }, icon: Icon(redCheckBox ? Icons.check : Icons.close, color: Colors.red,))
                    ),
                  ),

                            ],
                          ),
                ],
              ),
            ),
          ],
        ),
        ),

    );
  }

  Container trafficMapSetting() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: ListTile(
        leading: Icon(Icons.traffic_rounded, color: Colors.white,),
                      title: Text("Trafik Haritası", style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),),
        subtitle: Text("Trafik yoğunluğunu gösterir", style: GoogleFonts.quicksand(fontSize: 10),),
        trailing: TextButton(onPressed: (){setState(() {
                        trafficMap = !trafficMap;
                      });}, child: Text(trafficMap == true ? "Etkin" : "Devredışı", style: GoogleFonts.quicksand(color: Colors.white),)),
                    ),
    );
  }

  Container decibelSetting() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: ListTile(
        leading: Icon(Icons.graphic_eq, color: Colors.white,),
        title: Text(
          "Risk Uyarı Desibeli",
          style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
        ),
    subtitle: Text("Sesli uyarının şiddetini belirler", style: GoogleFonts.quicksand(fontSize: 10),),
        trailing: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            InkWell(
              onTap: () {
                setState(() {
                  decibel = decibel - 1;
                });
              },
              child: Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(7.0),
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.black
                ),
                child: Center(
                  child: Icon(
                    Icons.remove,
                          color: Colors.white,
                        ),
                ),
              ),
            ),

              Container(
                margin: const EdgeInsets.all(5.0),
                width: 15,
                child: Text(
                  decibel.toString(),
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                ),
              ),

              InkWell(
                onTap: () {
                  setState(() {
                    decibel = decibel + 1;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  margin: const EdgeInsets.all(7.0),
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.black
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container powerModeSetting() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: ListTile(
        leading: Icon(Icons.battery_saver_outlined, color: Colors.white,),
        title: Text(
          "Güç Tasarrufu Modu",
          style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
        ),
    subtitle: Text("Pil optimizasyonunu sağlar", style: GoogleFonts.quicksand(fontSize: 10),),
        trailing: Container(
          width: 60,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.red.withOpacity(0.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.power_off_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container darkModeSetting() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: ListTile(
        leading: Icon(Icons.dark_mode, color: Colors.white),
    subtitle: Text("Varsayılan olarak etkindir", style: GoogleFonts.quicksand(fontSize: 10),),
        title: Text(
          "Gece Modu",
          style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              darkMode = !darkMode;
            });
          },

          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: darkMode
                  ? Colors.green.withOpacity(0.4)
                  : Colors.red.withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment:
                  darkMode ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    darkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
