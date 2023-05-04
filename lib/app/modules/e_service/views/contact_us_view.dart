import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/welcome_widget.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key key}) : super(key: key);
  final size = 50.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تواصل معنا"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // primary: true,
            // shrinkWrap: true,
            children: [
              // HomeSearchBarWidget(),
              // AddressWidget(),
              SizedBox(
                height: 50,
              ),
              WelcomeWidget(
                  " اذا كانت لديك استفسارات او اسئلة او مقترح او شكوى تفضل وقم بالتواصل مع ذبيحة"),

// SizedBox(height: 20,),
//                Item("صندوق المقترحات والشكاوي ",(){
//
//                }),
              SizedBox(
                height: 50,
              ),
              SizedBox(height: 20),
              SizedBox(width: 10),

              InkWell(
                onTap: () {
                  launchUrl(
                      context, "mailto:info@dabeeha.com?subject=Hello&body=");
                },
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: InkWell(
                        onTap: () {
                          launchUrl(context,
                              "mailto:info@dabeeha.com?subject=Hello&body=");
                        },
                        child: Container(
                          alignment: Alignment.topRight,

                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                              image: new DecorationImage(
                                alignment: Alignment.topRight,
                                image: new ExactAssetImage(
                                  'assets/img/email.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26.withAlpha(60),
                                  offset: Offset(-5, 3),
                                  blurRadius: 5,
                                )
                              ]),
                          // child:Image.asset('assets/icon/whats.PNG')
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("EMail"),
                          Text(
                            "info@dabeeha.com",
                            style: TextStyle(color: Colors.blue[800]),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_back_ios)
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.grey.withOpacity(0.3),
              ).paddingSymmetric(horizontal: 60),
              SizedBox(height: 10),

              InkWell(
                onTap: () {
                  var phone = "0501152707";
                  // launchUrl(context, "https://web.hadirin.net/web/");
                  launch("tel:$phone");
                },
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: Container(
                        alignment: Alignment.topRight,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            image: new DecorationImage(
                              alignment: Alignment.topRight,
                              image: new ExactAssetImage(
                                'assets/img/call.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withAlpha(60),
                                offset: Offset(-5, 3),
                                blurRadius: 5,
                              )
                            ]),
                        // child:Image.asset('assets/icon/whats.PNG')
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Phone Number"),
                          Text(
                            "0501152707",
                            style: TextStyle(color: Colors.blue[800]),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_back_ios)
                  ],
                ).paddingSymmetric(horizontal: 20),
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.grey.withOpacity(0.3),
              ).paddingSymmetric(horizontal: 60),

              SizedBox(height: 20),
              // new SocialMediaWidget()
            ],
          ),
        ),
      ),
    );
  }
}

void launchUrl(context, String url) async {
  if (Platform.isIOS) {
    // for iOS phone only
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      launch(url);
    }
  } else {
    // android , web
    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(url)) {
      await launch(url);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: new Text("whatsapp no installed")));
    } else {
      launch(url);
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: new Text("whatsapp no installed")));
      // launch("tel:${number ?? ''}");
    }
  }
}
