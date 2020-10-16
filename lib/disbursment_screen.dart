import 'package:flutter/material.dart';
import 'package:hrapps/provider/disbursment_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

// ignore: must_be_immutable
class DisbursmentScreen extends StatefulWidget {
  @override
  _DisbursmentScreen createState() => _DisbursmentScreen();
}

class _DisbursmentScreen extends State<DisbursmentScreen> {
  @override
  Widget build(BuildContext context) {
    var date = new DateTime.now();
    String bulan = namaBulan(date.month.toString());
    String tahun = date.year.toString();
    String hari = date.day.toString();
    var cardTextStyle = TextStyle(
        fontFamily: "Montserrat Regular", fontSize: 14, color: Colors.white);
    var cardTextStyle1 = TextStyle(
        fontFamily: "Montserrat Regular", fontSize: 14, color: Colors.grey);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifikasi Pencairan',
        ),
      ),
      //ADAPUN UNTUK LOOPING DATA PEGAWAI, KITA GUNAKAN LISTVIEW BUILDER
      //KARENA WIDGET INI SUDAH DILENGKAPI DENGAN FITUR SCROLLING
      body: RefreshIndicator(
          onRefresh: () =>
              Provider.of<DisbursmentProvider>(context, listen: false)
                  .getDisbursment(),
          color: Colors.red,
          child: Container(
            margin: EdgeInsets.all(10),
            child: FutureBuilder(
              future: Provider.of<DisbursmentProvider>(context, listen: false)
                  .getDisbursment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                  );
                }
                return Consumer<DisbursmentProvider>(
                  builder: (context, data, _) {
                    print(data.dataDisbursment.length);
                    if (data.dataDisbursment.length == 0) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.hourglass_empty, size: 50),
                                title: Text(
                                  'DATA TIDAK DITEMUKAN',
                                  style: cardTextStyle1,
                                ),
                                subtitle: Text(''),
                              ),
                            ]),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Card(
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(
                                      Icons.note,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'ADA PENCAIRAN BARU NIH',
                                      style: cardTextStyle,
                                    ),
                                    subtitle: Text(
                                      'Selamat bekerja, sukses selalu',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ]),
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: data.dataDisbursment.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                      elevation: 4,
                                      child: InkWell(
                                        onTap: () {},
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Tooltip(
                                                message: messageStatus(
                                                    '${data.dataDisbursment[i].statusPencairan}'),
                                                child: Icon(
                                                  iconStatus(
                                                      '${data.dataDisbursment[i].statusPencairan}'),
                                                  color: colorStatus(
                                                      '${data.dataDisbursment[i].statusPencairan}'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                data.dataDisbursment[i].debitur,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        'Montserrat Regular'),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            'Plafond: ${formatRupiah(data.dataDisbursment[i].plafond)}',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontFamily:
                                                    'Montserrat Regular'),
                                          ),
                                          trailing: Text(
                                            '${data.dataDisbursment[i].tanggalAkad}',
                                          ),
                                        ),
                                      ));
                                }),
                          )
                        ],
                      );
                    }
                  },
                );
              },
            ),
          )),
    );
  }

  messageStatus(String status) {
    if (status == 'waiting') {
      return 'Menunggu Persetujuan';
    } else if (status == 'success') {
      return 'Disetujui Sales Leader';
    } else if (status == 'failed') {
      return 'Ditolak Sales Leader ';
    } else {
      return 'Menunggu Persetujuan';
    }
  }

  iconStatus(String status) {
    if (status == 'waiting') {
      return Icons.info;
    } else if (status == 'success') {
      return Icons.check;
    } else if (status == 'failed') {
      return Icons.cancel;
    } else {
      return Icons.info;
    }
  }

  colorStatus(String status) {
    if (status == 'waiting') {
      return Colors.blue;
    } else if (status == 'success') {
      return Colors.green;
    } else if (status == 'failed') {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  namaBulan(String bulan) {
    switch (bulan) {
      case '1':
        return 'Januari';
        break;
      case '2':
        return 'Februari';
        break;
      case '3':
        return 'Maret';
        break;
      case '4':
        return 'April';
        break;
      case '5':
        return 'Mei';
        break;
      case '6':
        return 'Juni';
        break;
      case '7':
        return 'Juli';
        break;
      case '8':
        return 'Agustus';
        break;
      case '9':
        return 'September';
        break;
      case '10':
        return 'Oktober';
        break;
      case '11':
        return 'November';
        break;
      case '12':
        return 'Desember';
        break;
    }
  }

  formatRupiah(String a) {
    FlutterMoneyFormatter fmf = new FlutterMoneyFormatter(
        amount: double.parse(a),
        settings: MoneyFormatterSettings(
          symbol: 'IDR',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 3,
        ));
    return 'IDR ' + fmf.output.withoutFractionDigits;
  }
}
