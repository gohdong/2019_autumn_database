import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:dbapp/src/success_pay.dart';


class Payment extends StatelessWidget {

  List<String> select_list;
  DocumentSnapshot document_table; // movie.docuemnt
   // time_table.document

  Payment(List<String> getlist, DocumentSnapshot gettable) {

    select_list = getlist;
    document_table = gettable;
  }

  String check = "what?";

  @override
  Widget build(BuildContext context) {
    return IamportPayment(
      appBar: new AppBar(
        title: new Text('아임포트 결제'),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'iamport',
      /* [필수입력] 결제 데이터 */
      data: PaymentData.fromJson({
        'pg': 'html5_inicis',                                          // PG사
        'payMethod': 'card',                                           // 결제수단
        'name': '아임포트 결제데이터 분석',                                  // 주문명
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'amount': 100,                                             // 결제금액
        'buyerName': "client_ID",                                           // 구매자 이름
        'buyerTel': '01012345678',                                     // 구매자 연락처
        'buyerEmail': 'example@naver.com',                             // 구매자 이메일
        'buyerAddr': '서울시 강남구 신사동 661-16',                         // 구매자 주소
        'buyerPostcode': '06018',                                      // 구매자 우편번호
        'appScheme': 'example',                                        // 앱 URL scheme
      }),
      /* [필수입력] 콜백 함수 */
//      callback: (Map<String, String> result) {
//        print("callback 함수 진입");
//        Navigator.pushReplacementNamed(
//          context,
//          '/Result',
////          Result(arguments : result),
//          arguments: result,
//        );
//      },

      callback: (Map<String, String> result) {
        print("콜백함수 진입@@@@@@@@");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(check)));

//        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Success(this.select_list, this.document_table)));
      },
    );
  }
}


//
//class Result extends StatelessWidget {
//  bool getIsSuccessed(Map<String, String> result) {
//    if (result['imp_success'] == 'true') {
//      return true;
//    }
//    if (result['success'] == 'true') {
//      return true;
//    }
//    return false;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    Map<String, String> result = ModalRoute.of(context).settings.arguments;
//    bool isSuccessed = getIsSuccessed(result);
//    String message = isSuccessed ? '성공하였습니다' : '실패하였습니다';
//
//    return Scaffold(
//      appBar: new AppBar(
//        title: Text('아임포트 결과'),
//      ),
//      body: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Text(
//            message,
//            style: TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 20.0,
//            ),
//          ),
//          Container(
//            padding: EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 50.0),
//            child: Column(
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Expanded(
//                          flex: 4,
//                          child: Text('아임포트 번호', style: TextStyle(color: Colors.grey))
//                      ),
//                      Expanded(
//                        flex: 5,
//                        child: Text(result['imp_uid'] ?? '-'),
//                      ),
//                    ],
//                  ),
//                ),
//                isSuccessed ? Container(
//                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Expanded(
//                          flex: 4,
//                          child: Text('주문 번호', style: TextStyle(color: Colors.grey))
//                      ),
//                      Expanded(
//                        flex: 5,
//                        child: Text(result['merchant_uid'] ?? '-'),
//                      ),
//                    ],
//                  ),
//                ) : Container(
//                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Expanded(
//                        flex: 4,
//                        child: Text('에러 메시지', style: TextStyle(color: Colors.grey)),
//                      ),
//                      Expanded(
//                        flex: 5,
//                        child: Text(result['error_msg'] ?? '-'),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//