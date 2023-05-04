import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as Math;
import 'package:intl/intl.dart' show DateFormat;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../../common/create_pdf.dart';
import '../../../../common/prod_items.dart';
// import '../../../../common/save_file_mobile.dart';
import '../../../../common/shop_model.dart';
import '../../../../common/ui.dart';
import '../../../services/auth_service.dart';
import '../../account/widgets/account_link_widget.dart';
import '../../bookings/widgets/booking_row_widget.dart';
import '../../bookings/widgets/booking_til_widget.dart';
import '../../../../common/save_file_mobile.dart'
    if (dart.library.html) '../../../../common/save_file_web.dart';

class FatoraView extends StatefulWidget {
  FatoraView(this.prods);
  final List<ProdItem> prods;
  // const FatoraView({Key key}) : super(key: key);

  @override
  State<FatoraView> createState() => _FatoraViewState();
}

class _FatoraViewState extends State<FatoraView> {
  Shop shop = Get.find<AuthService>().shop.value;
  // Shop(
  //     sellerName: "محمد",
  //     vaTnumber: "142345378352432",
  //     storeName: "طلي",
  //     storeAddress: "ibb-street",
  //     storeCity: "yemen",
  //     storePhone: "+967772537707");
  String f_n = "";

  @override
  void initState() {
    f_n = getRandom();
  }

  Math.Random random = Math.Random();
  getRandom() {
    return '#B' + (100000 + random.nextDouble() * 900000).floor().toString();
  }

  Qr qr;
  DateTime date = DateTime.now();
  GlobalKey gkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    qr = Qr(shop);
    return Scaffold(
      body: SafeArea(
        child: Column(

          children: [
            SizedBox(height: 10,),
            Center(
                child: Text(
                  "فاتورة ضريبية مبسطة",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 29),
                )),
            Flexible(
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration:
                    Ui.getBoxDecoration(border: Border.all(color: Colors.grey)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        // shrinkWrap: false,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Center(child: Text("${"invoice number".tr} : $f_n",textAlign: TextAlign.center,)),
                          Center(child: Text("  ${shop.storeName}")),
                          Center(
                              child: Text(
                            "  ${shop.storeAddress}",
                                textAlign: TextAlign.center,
                            style: Get.textTheme.caption,
                          )),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(" ${"Date".tr} :  "),
                                Text(
                                  DateFormat('dd-MM-yyyy',
                                          Get.locale.toString())
                                      .format(date),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.bodyText1,
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                          // Text(" تاريخ : ${date.toIso8601String()} "),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(" ${"Tax Number".tr}:  ${shop.vaTnumber} ",textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                    RepaintBoundary(key: gkey, child: qr.getQr())
                  ],
                ),
              ),
            ),
            Expanded(child: DataTable2SimpleDemo(widget.prods,shop)),
            BookingTilWidget(
              title: Text("Total".tr, style: Get.textTheme.subtitle2),
              actions: [Text(gettot(widget.prods).toString(), style: Get.textTheme.subtitle2)],
              content: Column(
                textDirection: TextDirection.ltr,
                children: [
                  BookingRowWidget(
                      description: "Total (not including value added):".tr,
                      descriptionFlex: 3,
                      hasDivider: false,
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 12, left: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Get.theme.focusColor.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${gettotal(widget.prods)}",
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  BookingRowWidget(
                      description: "${"Value added tax".tr} (${shop.tax}%):",
                      hasDivider: false,
                      descriptionFlex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 12, left: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Get.theme.focusColor.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${gettax(widget.prods)}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      )),
                  BookingRowWidget(
                      description: "${"Total".tr}:",
                      hasDivider: false,
                      descriptionFlex: 3,

                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 12, left: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Get.theme.focusColor.withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${gettot(widget.prods)}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      )),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                children: [
                  // AccountLinkWidget(
                  //   icon: Icon(Icons.checklist_rtl_outlined, color: Get.theme.accentColor),
                  //   text: Text("My Orders".tr),
                  //   onTap: (e) async {
                  //     // Get.to(() => CreatePdfStatefulWidget());
                  //   },
                  // ),
                  AccountLinkWidget(
                    icon: Icon(Icons.local_print_shop,
                        color: Get.theme.accentColor),
                    text: Text("Print the invoice".tr),
                    onTap: (e) async {
                      try {
                        Uint8List png;
                        pdfg pdf = pdfg(f_n, widget.prods, shop);
                        RenderRepaintBoundary boundry =
                        gkey.currentContext.findRenderObject();
                        var img = await boundry.toImage();
                        ByteData bytdata =
                        await img.toByteData(format: ImageByteFormat.png);
                        png = bytdata.buffer.asUint8List();
                        boundry.reassemble();
                        // await pdf.generateInvoice(png);
                        await pdf.generateInvoice2(png);
                      } catch (e) {
                        log("error   4734" + e.toString());
                      }
                    },
                  ),
                  // AccountLinkWidget(
                  //   icon: Icon(Icons.notifications_outlined, color: Get.theme.accentColor),
                  //   text: Text("Notifications".tr),
                  //   onTap: (e) {
                  //     // Get.toNamed(Routes.NOTIFICATIONS);
                  //   },
                  // ),
                  // AccountLinkWidget(
                  //   icon: Icon(Icons.chat_outlined, color: Get.theme.accentColor),
                  //   text: Text("Messages".tr),
                  //   onTap: (e) {
                  //     // Get.find<RootController>().changePage(2);
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double gettax(List<ProdItem> prods) {
    double r = 0;
    prods.forEach((element) async {
      r += element.price * element.count * shop.tax / 100;
    });
    return r.toPrecision(1);
  }

  double gettot(List<ProdItem> prods) {
    return gettotal(prods) + gettax(prods);
  }

  gettotal(List<ProdItem> prods) {
    double r = 0;
    prods.forEach((element) async {
      r += element.price * element.count;
    });
    return r;
  }
}

class Qr {
  final Shop shop;
  String s2;
  Qr(this.shop) {
    setStr();
  }
  setStr() {
    double t = 1000;
    double ta = shop.tax.toDouble();
    var co_n = shop.storeName + " ";
    var tax_id = shop.vaTnumber + " ";
    var creat_at = DateFormat('dd-MM-yyyy', "en" /* Get.locale.toString()*/)
            .format(DateTime.now()) +
        " ";
    // var creat_at=DateFormat.format(DateTime.now())+" ";
    String total = t.toString() + " ";
    String tax = ta.toString() + " ";
    // String s1=co_n+tax_id+creat_at+total+tax;
    // String encoded = base64.encode(utf8.encode(s1));
    BytesBuilder bb = BytesBuilder();
    bb.addByte(1);
    List<int> sellerNameByte = utf8.encode(co_n);
    bb.addByte(sellerNameByte.length);
    bb.add(sellerNameByte);

    bb.addByte(2);
    List<int> tax_idByte = utf8.encode(tax_id);
    bb.addByte(tax_idByte.length);
    bb.add(tax_idByte);

    bb.addByte(3);
    List<int> creat_atByte = utf8.encode(creat_at);
    bb.addByte(creat_atByte.length);
    bb.add(creat_atByte);

    bb.addByte(4);
    List<int> totalByte = utf8.encode(total);
    bb.addByte(totalByte.length);
    bb.add(totalByte);

    bb.addByte(5);
    List<int> taxByte = utf8.encode(tax);
    bb.addByte(taxByte.length);
    bb.add(taxByte);

    Uint8List qrqodebyte = bb.toBytes();
    Base64Encoder b = Base64Encoder();
    // final base64Decoder = base64.decoder;
    // final decodedBytes = base64Decoder.convert(utf8.s1);
    // Base64Encoder b=Base64Encoder();
    // Base64Decoder d=Base64Decoder();
    // // var co=d.convert(utf8.decode(s1));
    // s2= b.convert(decodedBytes);
    s2 = b.convert(qrqodebyte);
  }

  Widget getQr() {
    log('$s2');
    return BarcodeWidget(
      barcode: Barcode.qrCode(
        errorCorrectLevel: BarcodeQRCorrectionLevel.high,
      ),
      // data: 'https://pub.dev/packages/barcode_widget',
      data: '$s2',
      width: 200,
      height: 200,
    );
  }
}

class DataTable2SimpleDemo extends StatelessWidget {
  DataTable2SimpleDemo(this.prods, this.shop);
  final List<ProdItem> prods;
  final Shop shop;
  // const DataTable2SimpleDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DataTable2(
          showBottomBorder: false,
          columnSpacing: 0,
          dividerThickness: 2.7,
          horizontalMargin: 2,
          minWidth: 400,
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
          columns: [
            // DataColumn2(
            //   label: Text('#'),
            //   size: ColumnSize.S,
            // ),
            DataColumn2(
              label: Text('المنتجات ',style: TextStyle(color: Colors.white)),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text('الكمية',style: TextStyle(color: Colors.white)),
              size: ColumnSize.S,
            ),
            DataColumn(
              label: Text(' سعر الوحدة ',style: TextStyle(color: Colors.white,fontSize: 12),),
            ),
            DataColumn(
              label: Text(' ضريبة  \nالقيمة \n المضافة',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
              numeric: true,
            ),
            DataColumn(
              label: Text('السعر \n  شامل \n الضريبة',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
              prods.length,
              (index) => DataRow(
                  color: MaterialStateColor.resolveWith((states) =>index.isEven? Colors.grey.withAlpha(100):Colors.white),
                  cells: [
                    // DataCell(Text('$index' )),
                    DataCell(Text("${prods[index].name}")),
                    DataCell(Text("${prods[index].count}",textAlign: TextAlign.center,)),
                    DataCell(Text("${prods[index].price}")),
                    DataCell(Text(gettax(prods[index]).toString())),
                    DataCell(Text(gettot(prods[index])))
                  ]))),
    );
  }

  double gettax(ProdItem prod) {
    double r = prod.price * shop.tax / 100;
    return r;
  }

  String gettot(ProdItem prod) {
    double r = prod.price * prod.count;
    double rr = r + gettax(prod) * prod.count;
    return rr.toString();
  }
}

class pdfg {
  String f_n;
  List<ProdItem> prods;
  Shop shop;
  pdfg(String f_n, List<ProdItem> prods, Shop shpp) {
    this.f_n = f_n;
    this.prods = prods;
    this.shop = shpp;
    load();
  }
  ByteData data;
  ByteData im;
  Uint8List imData;
  Uint8List fontData;
  PdfFont contentFont;
  // pdfg() {
  //   load();
  // }
  void load() async {
    data = await rootBundle.load("assets/fonts/HacenTunisia.ttf");
    im = await rootBundle.load("assets/icon/notification.png");
  }

  Future<void> generateInvoice(Uint8List png) async {
    data = await rootBundle.load("assets/fonts/HacenTunisia.ttf");
    im = await rootBundle.load("assets/icon/notification.png");
    fontData = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    imData = im.buffer.asUint8List(im.offsetInBytes, im.lengthInBytes);

    contentFont = PdfTrueTypeFont(fontData, 9);
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    // final Size pageSize = page.getClientSize();
    final Size pageSize = Size(302,800);

    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid,png);
    //Draw grid
    drawGrid(page, grid, result,png);
    //Add invoice footer
    drawFooter(page, pageSize);
    final Size pageSize2 = page.getClientSize();
    log(pageSize2.toString());
    log(pageSize.toString());
    // return;
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }
  Future<void> generateInvoice2(Uint8List png) async {
    data = await rootBundle.load("assets/fonts/HacenTunisia.ttf");
    im = await rootBundle.load("assets/icon/notification.png");
    fontData = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    imData = im.buffer.asUint8List(im.offsetInBytes, im.lengthInBytes);
  double pagehight=  680+prods.length*20.0;
    contentFont = PdfTrueTypeFont(fontData, 9);
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
     document.pageSettings=PdfPageSettings(Size(302,pagehight));
    final PdfPage page = document.pages.add();
    //Get page client size
    // final Size pageSize = page.getClientSize();
    final Size pageSize = Size(302,pagehight);

    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    // final PdfGrid grid = getGrid();
    final PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: contentFont,
      // format: PdfStringFormat(
      //     textDirection: PdfTextDirection.rightToLeft,
      //     alignment: PdfTextAlignment.center,
      //     lineAlignment: PdfVerticalAlignment.bottom
      // )
    );
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader2(page, pageSize, " "," ",50);

    if(Get.find<AuthService>().logo!=null)
      drawimage(page, grid, Get.find<AuthService>().logo,Size(100, 100),50);
    drawTextCenter(page,pageSize,"${shop.storeName}",160);
    drawTextCenter(page,pageSize,"${shop.storeAddress}",170);
    drawTextCenter(page,pageSize," الرقم الضريبي:  ${shop.vaTnumber}",180);
    drawTextCenter(page,pageSize,"أهلاً بك",190);
    drawTextCenter(page,pageSize,"فاتورة ضريبية مبسطة",205);
    var l1 = 'رقم الفاتورة :';
    final PdfLayoutResult result2 = drawHeader2(page, pageSize, "$l1 $f_n "," ",220);
    final DateFormat format = DateFormat.yMd('en_US');
    final PdfLayoutResult result3 = drawHeader2(page, pageSize, "تاريخ: ${format.format(DateTime.now())}"," ",230);
    final PdfLayoutResult result4 = drawHeader2(page, pageSize, "امين الصندوق: المالك"," ",240);
    final PdfLayoutResult result5 = drawHeader2(page, pageSize, "نقطة بيع POS: POS1"," ",250);
    drawline(page, pageSize,result5);
    PdfLayoutResult result6;
    for (int i = 0; i < prods.length; i++)
      result6= drawProduct(page, pageSize, 270+i*26.0,prods[i]);

    // final PdfLayoutResult result6 = drawHeader2(page, pageSize, "نقطة بيع POS: POS1"," ",270);
    drawline(page, pageSize,result6);
    double last=280+prods.length*20.0;

    var l3 = 'المجموع قبل الضريبة :';
    var total=gettotal(prods);
    final PdfLayoutResult result7 = drawHeader2(page, pageSize, "$l3","$total",last+15);
    var l4 = 'ضريبة القيمة المضافة(${shop.tax}%) :';
    var total2=gettotaltax(prods);
    final PdfLayoutResult result8 = drawHeader2(page, pageSize, "$l4","$total2",last+30);
    var l5 = 'المجموع مع الضريبة (${shop.tax}%) :';
    var total3=total+total2;
    final PdfLayoutResult result9 = drawHeader2(page, pageSize, "$l5","${total3}",last+45);
    drawline(page, pageSize,result9);
    drawimage(page, grid, png,Size(227, 227),last+70);

    //Draw grid
    // drawGrid(page, grid, result,png);
    //Add invoice footer
    // drawFooter(page, pageSize);
    final Size pageSize2 = page.getClientSize();
    log(pageSize2.toString());
    log(pageSize.toString());
    // return;
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice2.pdf');
  }

  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid, Uint8List png) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
  if(Get.find<AuthService>().logo!=null)  page.graphics.drawImage(
      PdfBitmap(Get.find<AuthService>().logo),
      Rect.fromLTWH(25, 0, 90, 90),
    );
    page.graphics.drawString(
        'فاتورة ضريبية مبسطة'
        ' \n Simplified Tax Invoice',
        contentFont,
        // PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        // format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle)
        format: PdfStringFormat(
            textDirection: PdfTextDirection.rightToLeft,
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString(
        " س.ر " + getTotalAmount(grid).toString(), contentFont,
        // PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));

    // final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMd('en_US');
    var l1 = 'رقم الفاتورة :';
    var l2 = 'رقم تسجيل ضريبة القيمة المضافة :';
    final String invoiceNumber =
        '$l1 $f_n \r\n تاريخ: ${format.format(DateTime.now())}\r\n $l2 ${shop.vaTnumber}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    String address =
        '''${shop.storeName} \r\n ${shop.storeAddress} \r\n ${shop.storePhone}''';
    var arabicFormate = PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
      // alignment: PdfTextAlignment.center,
      // lineAlignment: PdfVerticalAlignment.bottom
    );
    PdfTextElement(
            text: invoiceNumber,
            font: contentFont,
            format: PdfStringFormat(
                textDirection: PdfTextDirection.rightToLeft,
                alignment: PdfTextAlignment.right,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 50),
                120, contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(
            text: address, font: contentFont, format: arabicFormate)
        .draw(
            // format: PdfLayoutFormat(breakType: PdfLayoutBreakType.),
            page: page,
            bounds: Rect.fromLTWH(
                30,
                120,
                pageSize.width - (contentSize.width + 30),
                pageSize.height - 120));
  }
  PdfLayoutResult drawHeader2(PdfPage page, Size pageSize,String right,String left,double dy) {
        page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));
      //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMd('en_US');
    final Size contentSize = contentFont.measureString(right);
    // ignore: leading_newlines_in_multiline_strings

    var arabicFormate = PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
      // alignment: PdfTextAlignment.center,
      // lineAlignment: PdfVerticalAlignment.bottom
    );
    PdfTextElement(
            text: right,
            font: contentFont,
            format: PdfStringFormat(
                textDirection: PdfTextDirection.rightToLeft,
                alignment: PdfTextAlignment.right,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 50),
                dy, contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(
            text: left, font: contentFont, format: arabicFormate)
        .draw(
            // format: PdfLayoutFormat(breakType: PdfLayoutBreakType.),
            page: page,
            bounds: Rect.fromLTWH(
                30,
                dy,
                pageSize.width - (contentSize.width + 30),
                pageSize.height - 120));
  }
  PdfLayoutResult drawProduct(PdfPage page, Size pageSize,double dy, ProdItem prod) {
        page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));
      //Create data foramt and convert it to text.f
    final DateFormat format = DateFormat.yMd('en_US');

    // ignore: leading_newlines_in_multiline_strings
String detail=  '${prod.name}';
   String detail2 ='  ${prod.count} x ${prod.price}';
String price="${prod.price * prod.count}";
        final Size contentSize = contentFont.measureString(detail);
    var arabicFormate = PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
      // alignment: PdfTextAlignment.center,
      // lineAlignment: PdfVerticalAlignment.bottom
    );
    PdfTextElement(
            text: detail,
            font: contentFont,
            format: PdfStringFormat(
                textDirection: PdfTextDirection.rightToLeft,
                alignment: PdfTextAlignment.right,
                lineAlignment: PdfVerticalAlignment.top))
        .draw(
            page: page,
            bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 50),
                dy, contentSize.width + 30, pageSize.height - 120));


     PdfTextElement(
            text: price, font: contentFont, format: arabicFormate)
        .draw(
            // format: PdfLayoutFormat(breakType: PdfLayoutBreakType.),
            page: page,
            bounds: Rect.fromLTWH(
                30,
                dy,
                pageSize.width - (contentSize.width + 30),
                pageSize.height - 120));
    return  PdfTextElement(
        text: detail2,
        font: contentFont,
        format: PdfStringFormat(
            textDirection: PdfTextDirection.rightToLeft,
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.top))
        .draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 50),
            dy+10, contentSize.width + 30, pageSize.height - 120));
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result, Uint8List png) {
    Rect totalPriceCellBounds;
    Rect quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0));

    //Draw grand total.d
    var t11 = "اجمالي المبلغ الخاضع للضريبة :  ";
    var t22 = "ضريبة القيمة المضافة(${shop.tax}%)";
    var t33 = "المجموع مع الضريبة(${shop.tax}%)";
    var arabicFormate = PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
      alignment: PdfTextAlignment.right,
      // lineAlignment: PdfVerticalAlignment.bottom
    );

    page.graphics.drawString(
        getTotalAmount(grid).toString() +
            " \r\n " +
            getTotalAmount(grid).toString() +
            " \r\n " +
            getTotalAmount(grid).toString(),
        contentFont,
        // PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        format: arabicFormate,
        bounds: Rect.fromLTWH(
            quantityCellBounds.left - 90,
            result.bounds.bottom + 10,
            quantityCellBounds.width,
            quantityCellBounds.height + 50));
    page.graphics.drawString(
        '$t11 \r\n $t22 \r\n $t33',
        // PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        contentFont,
        format: arabicFormate,
        bounds: Rect.fromLTWH(
            totalPriceCellBounds.left - 60,
            result.bounds.bottom + 10,
            totalPriceCellBounds.width + 40,
            totalPriceCellBounds.height + 50));
    page.graphics.drawImage(
      PdfBitmap(png),
      Rect.fromLTWH(200 , result.bounds.bottom+totalPriceCellBounds.height+50, 90, 90),
    );
  }
  void drawimage(PdfPage page, PdfGrid grid, Uint8List png,Size size,double dy) {
    page.graphics.drawImage(
      PdfBitmap(png),
      Rect.fromLTWH( (page.size.width-size.width)/2, dy,size.width , size.height),
      // Rect.fromCircle(   center: Offset((page.size.width+size.width)/2,(dy+size.width)/2), radius: size.width),
        // fromLTWH(200 , result.bounds.bottom, 90, 90),
    );
  }
  void drawline(PdfPage page, Size pageSize, PdfLayoutResult result) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(10, result.bounds.bottom),
        Offset(pageSize.width-10, result.bounds.bottom ));
  }
  //Draw the invoice footer data.
   drawTextCenter(PdfPage page, Size pageSize,String text,double dy) {
     final Size contentSize = contentFont.measureString(text);
  return PdfTextElement(
      text: text,
      font: contentFont,
      format: PdfStringFormat(
          textDirection: PdfTextDirection.rightToLeft,
          alignment: PdfTextAlignment.right,
          lineAlignment: PdfVerticalAlignment.top))
      .draw(
      page: page,
      bounds: Rect.fromLTWH((page.size.width-contentSize.width)/2,
          dy, contentSize.width , contentSize.height));
  }
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        // ignore: leading_newlines_in_multiline_strings
        '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? support@adventure-works.com''';

    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: contentFont,
      // format: PdfStringFormat(
      //     textDirection: PdfTextDirection.rightToLeft,
      //     alignment: PdfTextAlignment.center,
      //     lineAlignment: PdfVerticalAlignment.bottom
      // )
    );

    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    int r = 4;
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[r - 0].value = 'المنتجات ';
    headerRow.cells[r - 0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[r - 0].style = PdfGridCellStyle(
        format: PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
    ));
    headerRow.cells[r - 1].value = 'الكمية';
    headerRow.cells[r - 1].style = PdfGridCellStyle(
        format: PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
    ));
    headerRow.cells[r - 2].value = 'سعر الوحدة';
    headerRow.cells[r - 2].style = PdfGridCellStyle(
        format: PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
    ));
    headerRow.cells[r - 3].value = 'ضريبة القيمة المضافة';
    headerRow.cells[r - 3].style = PdfGridCellStyle(
        format: PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
    ));
    headerRow.cells[r - 4].value = 'السعر شامل ضريبة القيمة المضافة';
    headerRow.cells[r - 4].style = PdfGridCellStyle(
        format: PdfStringFormat(
      textDirection: PdfTextDirection.rightToLeft,
    ));
    //Add rows
    for (int i = 0; i < prods.length; i++)
      addProducts(prods[i].name, prods[i].count.toString(), prods[i].price,
          gettax(prods[i]), gettot(prods[i]), grid);
    // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 3, 149.97, grid);
    // addProducts('So-B909-M', 'Mountain Bike Socks,M', 9.5, 2, 19, grid);
    // addProducts('LJ-0192', 'Long-Sleeve Logo Jersey,M', 49.99, 4, 199.96, grid);
    // addProducts('FK-5136', 'ML Fork', 175.49, 6, 1052.94, grid);
    // addProducts('HL-U509', 'Sports-100 Helmet,Black', 34.99, 1, 34.99, grid);
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[0].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId, String productName, double price,
      double quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    int r = 4;
    row.cells[r - 0].value = productId;
    row.cells[r - 0].style = PdfGridCellStyle(
        font: PdfTrueTypeFont(fontData, 11),
        format: PdfStringFormat(
          textDirection: PdfTextDirection.rightToLeft,
        ));
    row.cells[r - 1].value = productName;
    row.cells[r - 2].value = price.toString();
    row.cells[r - 3].value = quantity.toString();
    row.cells[r - 4].value = total.toString();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[0].value as String;
      total += double.parse(value);
    }
    return total;
  }

  double gettax(ProdItem prod) {
    double r = prod.price * shop.tax / 100;
    return r;
  }
  double gettotaltax(List<ProdItem> prs) {
    double total = 0;
    for (int i = 0; i < prs.length; i++) {
      total+= prs[i].price*prs[i].count * shop.tax / 100;
    }
    return total.toPrecision(1);
  }

  double gettot(ProdItem prod) {
    double r = prod.price * prod.count;
    double rr = r + gettax(prod) * prod.count;
    return rr;
  }
  double gettotal(List<ProdItem> prs) {
    double total = 0;
    for (int i = 0; i < prs.length; i++) {
      total +=prs[i].price*prs[i].count;
    }
    return total;
  }
}
