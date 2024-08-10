class RiskPoint {
  final double xKoordinat;
  final double yKoordinat;
  final int kazaSayisi;
  final List<KazaSekli> kazaSekli;
  final List<HavaDurumu> havaDurumu;
  final List<Saatler> saatler;
  final List<Tarihler> tarihler;
  final List<Mevsimler> mevsimler;
  final List<YolKaplamaCinsi> yolKaplamaCinsi;
  final List<YolSinifi> yolSinifi;
  final List<GeceGunduz> geceGunduz;
  final int toplamOlu;
  final int toplamYarali;
  final List<YasalHizLimiti> yasalHizLimiti;
  final List<KazaSebebi> kazaSebebi;
  final List<CarpismaYeri> carpismaYeri;
  final List<GeoyatayGuzergah> geoyatayGuzergah;
  final List<GeoduseyGuzergah> geoduseyGuzergah;

  RiskPoint({
    required this.xKoordinat,
    required this.yKoordinat,
    required this.kazaSayisi,
    required this.kazaSekli,
    required this.havaDurumu,
    required this.saatler,
    required this.tarihler,
    required this.mevsimler,
    required this.yolKaplamaCinsi,
    required this.yolSinifi,
    required this.geceGunduz,
    required this.toplamOlu,
    required this.toplamYarali,
    required this.yasalHizLimiti,
    required this.kazaSebebi,
    required this.carpismaYeri,
    required this.geoyatayGuzergah,
    required this.geoduseyGuzergah,
  });

  // JSON'dan RiskPoint nesnesine dönüştürme
  factory RiskPoint.fromJson(Map<String, dynamic> json) {
    return RiskPoint(
      xKoordinat: json['xKoordinat'] ?? 0.0,
      yKoordinat: json['yKoordinat'] ?? 0.0,
      kazaSayisi: json['kazaSayisi'] ?? 0,
      kazaSekli: json['kazaSekli'] != null
          ? List<KazaSekli>.from(json['kazaSekli'].map((item) => KazaSekli.fromJson(item)))
          : [],
      havaDurumu: json['havaDurumu'] != null
          ? List<HavaDurumu>.from(json['havaDurumu'].map((item) => HavaDurumu.fromJson(item)))
          : [],
      saatler: json['saatler'] != null
          ? List<Saatler>.from(json['saatler'].map((item) => Saatler.fromJson(item)))
          : [],
      tarihler: json['tarihler'] != null
          ? List<Tarihler>.from(json['tarihler'].map((item) => Tarihler.fromJson(item)))
          : [],
      mevsimler: json['mevsimler'] != null
          ? List<Mevsimler>.from(json['mevsimler'].map((item) => Mevsimler.fromJson(item)))
          : [],
      yolKaplamaCinsi: json['yolKaplamaCinsi'] != null
          ? List<YolKaplamaCinsi>.from(json['yolKaplamaCinsi'].map((item) => YolKaplamaCinsi.fromJson(item)))
          : [],
      yolSinifi: json['yolSinifi'] != null
          ? List<YolSinifi>.from(json['yolSinifi'].map((item) => YolSinifi.fromJson(item)))
          : [],
      geceGunduz: json['geceGunduz'] != null
          ? List<GeceGunduz>.from(json['geceGunduz'].map((item) => GeceGunduz.fromJson(item)))
          : [],
      toplamOlu: json['toplamOlu'] ?? 0,
      toplamYarali: json['toplamYarali'] ?? 0,
      yasalHizLimiti: json['yasalHizLimiti'] != null
          ? List<YasalHizLimiti>.from(json['yasalHizLimiti'].map((item) => YasalHizLimiti.fromJson(item)))
          : [],
      kazaSebebi: json['kazaSebebi'] != null
          ? List<KazaSebebi>.from(json['kazaSebebi'].map((item) => KazaSebebi.fromJson(item)))
          : [],
      carpismaYeri: json['carpismaYeri'] != null
          ? List<CarpismaYeri>.from(json['carpismaYeri'].map((item) => CarpismaYeri.fromJson(item)))
          : [],
      geoyatayGuzergah: json['geoyatayGuzergah'] != null
          ? List<GeoyatayGuzergah>.from(json['geoyatayGuzergah'].map((item) => GeoyatayGuzergah.fromJson(item)))
          : [],
      geoduseyGuzergah: json['geoduseyGuzergah'] != null
          ? List<GeoduseyGuzergah>.from(json['geoduseyGuzergah'].map((item) => GeoduseyGuzergah.fromJson(item)))
          : [],
    );
  }
}

// Alt sınıflar
class KazaSekli {
  final String kazaTipi;
  final int adet;
  final double yuzde;

  KazaSekli({required this.kazaTipi, required this.adet, required this.yuzde});

  factory KazaSekli.fromJson(Map<String, dynamic> json) {
    return KazaSekli(
      kazaTipi: json['kazaTipi'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class HavaDurumu {
  final String havaDurumu;
  final int adet;
  final double yuzde;

  HavaDurumu({required this.havaDurumu, required this.adet, required this.yuzde});

  factory HavaDurumu.fromJson(Map<String, dynamic> json) {
    return HavaDurumu(
      havaDurumu: json['havaDurumu'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class Saatler {
  final String saat;
  final int adet;
  final double yuzde;

  Saatler({required this.saat, required this.adet, required this.yuzde});

  factory Saatler.fromJson(Map<String, dynamic> json) {
    return Saatler(
      saat: json['saat'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class Tarihler {
  final String tarih;
  final int adet;
  final double yuzde;

  Tarihler({required this.tarih, required this.adet, required this.yuzde});

  factory Tarihler.fromJson(Map<String, dynamic> json) {
    return Tarihler(
      tarih: json['tarih'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class Mevsimler {
  final String mevsim;
  final int adet;
  final double yuzde;

  Mevsimler({required this.mevsim, required this.adet, required this.yuzde});

  factory Mevsimler.fromJson(Map<String, dynamic> json) {
    return Mevsimler(
      mevsim: json['mevsim'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class YolKaplamaCinsi {
  final String yolKaplamaCinsi;
  final int adet;
  final double yuzde;

  YolKaplamaCinsi({required this.yolKaplamaCinsi, required this.adet, required this.yuzde});

  factory YolKaplamaCinsi.fromJson(Map<String, dynamic> json) {
    return YolKaplamaCinsi(
      yolKaplamaCinsi: json['yolKaplamaCinsi'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class YolSinifi {
  final String yolSinifi;
  final int adet;
  final double yuzde;

  YolSinifi({required this.yolSinifi, required this.adet, required this.yuzde});

  factory YolSinifi.fromJson(Map<String, dynamic> json) {
    return YolSinifi(
      yolSinifi: json['yolSinifi'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class GeceGunduz {
  final String geceGunduz;
  final int adet;
  final double yuzde;

  GeceGunduz({required this.geceGunduz, required this.adet, required this.yuzde});

  factory GeceGunduz.fromJson(Map<String, dynamic> json) {
    return GeceGunduz(
      geceGunduz: json['geceGunduz'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class YasalHizLimiti {
  final String yasalHizLimiti;
  final int adet;
  final double yuzde;

  YasalHizLimiti({required this.yasalHizLimiti, required this.adet, required this.yuzde});

  factory YasalHizLimiti.fromJson(Map<String, dynamic> json) {
    return YasalHizLimiti(
      yasalHizLimiti: json['yasalHizLimiti'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class KazaSebebi {
  final String kazaSebebi;
  final int adet;
  final double yuzde;

  KazaSebebi({required this.kazaSebebi, required this.adet, required this.yuzde});

  factory KazaSebebi.fromJson(Map<String, dynamic> json) {
    return KazaSebebi(
      kazaSebebi: json['kazaSebebi'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class CarpismaYeri {
  final String carpismaYeri;
  final int adet;
  final double yuzde;

  CarpismaYeri({required this.carpismaYeri, required this.adet, required this.yuzde});

  factory CarpismaYeri.fromJson(Map<String, dynamic> json) {
    return CarpismaYeri(
      carpismaYeri: json['carpismaYeri'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class GeoyatayGuzergah {
  final String geoyatayGuzergah;
  final int adet;
  final double yuzde;

  GeoyatayGuzergah({required this.geoyatayGuzergah, required this.adet, required this.yuzde});

  factory GeoyatayGuzergah.fromJson(Map<String, dynamic> json) {
    return GeoyatayGuzergah(
      geoyatayGuzergah: json['geoyatayGuzergah'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}

class GeoduseyGuzergah {
  final String geoduseyGuzergah;
  final int adet;
  final double yuzde;

  GeoduseyGuzergah({required this.geoduseyGuzergah, required this.adet, required this.yuzde});

  factory GeoduseyGuzergah.fromJson(Map<String, dynamic> json) {
    return GeoduseyGuzergah(
      geoduseyGuzergah: json['geoduseyGuzergah'],
      adet: json['Adet'],
      yuzde: json['%'],
    );
  }
}