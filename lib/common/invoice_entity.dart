// import 'package:e_invoice_qrcode_reader/core/helpers/common_helper.dart';
import 'dart:core';

import 'package:objectbox/objectbox.dart';

import 'common_helper.dart';

@Entity()
class InvoiceEntity {
  int id;
  String sellerName;
  String sellerTaxNumber;
  String invoiceDate;
  String invoiceTotal;
  String taxTotal;
  DateTime scannedDate;

  InvoiceEntity({
    this.id = 0,
     this.sellerName,
     this.sellerTaxNumber,
     this.invoiceDate,
     this.invoiceTotal,
     this.taxTotal,
     this.scannedDate,
  });

  InvoiceEntity copyWith({
    int id,
    String sellerName,
    String sellerTaxNumber,
    String invoiceDate,
    String invoiceTotal,
    String taxTotal,
    DateTime scannedDate,
  }) {
    return InvoiceEntity(
      id: id ?? this.id,
      sellerName: sellerName ?? this.sellerName,
      sellerTaxNumber: sellerTaxNumber ?? this.sellerTaxNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      invoiceTotal: invoiceTotal ?? this.invoiceTotal,
      taxTotal: taxTotal ?? this.taxTotal,
      scannedDate: scannedDate ?? this.scannedDate,
    );
  }

  factory InvoiceEntity.empty() => InvoiceEntity(
        id: 0,
        sellerName: "",
        sellerTaxNumber: "",
        invoiceDate: "",
        invoiceTotal: "",
        taxTotal: "",
        scannedDate: CommonHelper.emptyDate,
      );


}
// package com.github.busaeed.einvoice.qrbarcode;
//
//  class Tag {
//
//    int tag;
//    String value;
//
//    Tag(int tag, String value) {
//     if (value == null || value.trim().isEmpty) {
//       throw new Exception("Value cannot be null or empty");
//     }
//     this.tag = tag;
//     this.value = value;
//   }
//
//    int getTag() {
//     return this.tag;
//   }
//
//    String getValue() {
//     return this.value;
//   }
//
//    int getLength() {
//     return this.value.codeUnits.length;
//   }
//
//    String toHex(int value) {
//     String hex = String.format("%02X", value);
//     String input = hex.length % 2 == 0 ? hex : hex  + "0";
//     StringSink output = new StringBuffer();
//     for (int i = 0; i < input.length; i+=2) {
//       String str = input.substring(i, i+2);
//       output.append((char)int.parse(str, 16));
//     }
//     return output.toString();
//     }
//
//   @Override
//    String toString() {
//     return this.toHex(this.getTag()) + this.toHex(this.getLength()) + (this.getValue());
//   }
//
// }