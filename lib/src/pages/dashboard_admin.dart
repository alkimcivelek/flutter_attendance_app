import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:uuid/uuid.dart';
import 'package:yoklama_sistemi/src/services/database.dart';

class GridDashboardAdmin extends StatefulWidget {
  GridDashboardAdmin({Key? key}) : super(key: key);

  @override
  State<GridDashboardAdmin> createState() => _GridDashboardAdminState();
}

class _GridDashboardAdminState extends State<GridDashboardAdmin> {
  int _duration = 15;
  final CountDownController _controller = CountDownController();

  DatabaseMethods db = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    var color = 0xff453658;
    List<Cards> list = List<Cards>.empty(growable: true);
    list.addAll([
      Cards(
          image: "lib/images/key.png",
          subtitle:
              "Öğrencilerin yoklama kaydının alınabilmesi için şifre oluşturun",
          title: "Kod Oluştur",
          buttonText: "Kod Oluştur",
          isButtonExist: true),
      Cards(
          image: "lib/images/sand-clock.png",
          subtitle:
              "Yoklama süresi başlatıldıktan sonra öğrenciler yoklamaya erişebilir",
          title: "Süreyi Başlat",
          buttonText: "Süreyi Başlat",
          isButtonExist: true),
      Cards(
          image: "lib/images/search.png",
          subtitle:
              "Hangi öğrencinin ne kadar devamsızlık yaptığını görüntüleyin",
          title: "Öğrenci Bilgileri",
          buttonText: "",
          isButtonExist: false),
      Cards(
          image: "lib/images/help-desk.png",
          subtitle: "Teknik aksaklık yaşamanız durumunda bize ulaşın",
          title: "Destek",
          buttonText: "",
          isButtonExist: false),
    ]);
    return Container(
      child: Scaffold(
        backgroundColor: HexColor("141d26"),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 15),
                    child: Text(
                      "Ana Sayfa",
                      style: GoogleFonts.lora(
                          textStyle: TextStyle(
                              color: Color.fromARGB(233, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 25)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0,
              ),
              Center(
                  child: CircularCountDownTimer(
                textStyle: GoogleFonts.lora(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                duration: _duration,
                controller: _controller,
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 5,
                ringColor: Colors.white.withOpacity(0.25),
                ringGradient: null,
                fillColor: HexColor("#84C9FB"),
                isReverse: true,
                isReverseAnimation: true,
                autoStart: false,
                isTimerTextShown: true,
                textFormat: CountdownTextFormat.S,
                onComplete: () async {
                  MessageDialog messageDialog = MessageDialog(
                    dialogBackgroundColor: HexColor("141d26"),
                    buttonOkColor: HexColor("#B33030"),
                    title: 'Süre sona erdi',
                    titleColor: Colors.white,
                    message:
                        'Öğrencilerin yoklama işlemini tamamlamaları için belirlenen süre sona erdi. Tekrar süreyi başlatmak için \'Süreyi Başlat\' butonuna tıklamanız gerekmektedir.',
                    messageColor: Colors.white,
                    buttonOkText: 'TAMAM',
                    dialogRadius: 15.0,
                    buttonRadius: 18.0,
                  );
                  await db.updateCountDownTimer(0);
                  await db.updateCode();
                  messageDialog.show(context,
                      barrierColor: Colors.black, barrierDismissible: false);
                },
              )),
              Expanded(
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14.0,
                          mainAxisSpacing: 14.0,
                          childAspectRatio: 1.2),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () async {},
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(children: [
                                if (list[index].image ==
                                    "lib/images/map.png") ...[
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                                Positioned(
                                  left: 5,
                                  right: 5,
                                  child: Image.asset(
                                    list[index].image,
                                    width: 55,
                                    height: 55,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Positioned(
                                  top: 60,
                                  left: 5,
                                  right: 5,
                                  child: Text(
                                    list[index].title,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Positioned(
                                  top: 85,
                                  left: 5,
                                  right: 5,
                                  child: Text(
                                    list[index].subtitle,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lora(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10)),
                                  ),
                                ),
                                list[index].isButtonExist
                                    ? Positioned(
                                        top: 112,
                                        left: 45,
                                        right: 45,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  switch (index) {
                                                    case 0:
                                                      var uid = Uuid();
                                                      var generatedCode = uid.v1();
                                                      generatedCode = generatedCode
                                                          .split("-")[0];
                                                      await db.saveGeneratedCode(
                                                          generatedCode);
                                                      var code = await db.getCode();
                                                      MessageDialog messageDialog =
                                                          MessageDialog(
                                                        dialogBackgroundColor:
                                                            HexColor("141d26"),
                                                        buttonOkColor:
                                                            HexColor("#4E944F"),
                                                        title: 'Kod Oluşturuldu',
                                                        titleColor: Colors.white,
                                                        message:
                                                            'Öğrencilerin yoklamalarını yapabilmesi için gerekli olan kod başarı ile oluşturuldu. Oluşturulan kod: ${code.get("code").toString()}',
                                                        messageColor: Colors.white,
                                                        buttonOkText: 'TAMAM',
                                                        dialogRadius: 15.0,
                                                        buttonRadius: 18.0,
                                                      );
                                                      messageDialog.show(context,
                                                          barrierColor:
                                                              Colors.black,
                                                          barrierDismissible:
                                                              false);
                                                      break;
                                                    case 1:
                                                      var snapshot =
                                                          await db.getCode();
                                                      if (await snapshot
                                                              .get("code")
                                                              .length <=
                                                          0) {
                                                        MessageDialog
                                                            messageDialog =
                                                            MessageDialog(
                                                          dialogBackgroundColor:
                                                              HexColor("141d26"),
                                                          buttonOkColor:
                                                              HexColor("#B33030"),
                                                          title: 'Kod Oluşturun',
                                                          titleColor: Colors.white,
                                                          message:
                                                              'Süreyi başlatabilmek için yeniden kod oluşturmanız gerekmektedir.',
                                                          messageColor:
                                                              Colors.white,
                                                          buttonOkText: 'TAMAM',
                                                          dialogRadius: 15.0,
                                                          buttonRadius: 18.0,
                                                        );
                                                        await db
                                                            .updateCountDownTimer(
                                                                0);
                                                        await db.updateCode();
                                                        messageDialog.show(context,
                                                            barrierColor:
                                                                Colors.black,
                                                            barrierDismissible:
                                                                false);
                                                      } else {
                                                        var code =
                                                            await db.getCode();
                                                        debugPrint(code
                                                            .toString()
                                                            .length
                                                            .toString());
                                                        _controller.start();
                                                        await db
                                                            .updateCountDownTimer(
                                                                _duration);
                                                      }
                                                      break;
                                                    default:
                                                      break;
                                                  }
                                                },
                                                child: Text(
                                                  list[index].buttonText,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(
                                                  primary: Colors.white,
                                                  backgroundColor:
                                                      HexColor("#84C9FB"),
                                                  onSurface: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    : Container(),
                                SizedBox(
                                  height: 5,
                                ),
                              ]),
                            ));
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

class Cards {
  String title;
  String subtitle;
  String image;
  String buttonText;
  bool isButtonExist;

  Cards(
      {required this.image,
      required this.subtitle,
      required this.title,
      required this.buttonText,
      required this.isButtonExist});
}
