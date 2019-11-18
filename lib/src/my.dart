import 'package:dbapp/src/login.dart';
import 'package:flutter/material.dart';


class My extends StatefulWidget {
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  @override
  Widget build(BuildContext context) {

    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()),
            );
          },
          child: Container(
            child: loginSection
          ),
        ),
        Container(
          height: 7,
          color: Colors.black12,
        ),
        Container(
          padding: EdgeInsets.only(top:10,bottom: 10),
          child: buttonSection,
        ),
        Container(
          height: 7,
          color: Colors.black12,
        ),
        Container(
          child: menuSection
        )
      ],
    );
  }
  Widget loginSection = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '로그인 후 이용해주세요 ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '로그인 하기',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        /*3*/
        Icon(
          Icons.account_circle,
          size: 50,
        ),
      ],
    ),
  );
  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(Icons.credit_card, '관람권/카드'),
        _buildButtonColumn(Icons.card_giftcard, '기프트카드'),
        _buildButtonColumn(Icons.local_movies, '내가 본 영화'),
        _buildButtonColumn(Icons.favorite_border, '볼래요'),
      ],
    ),
  );
  Widget menuSection = Column(
      children: <Widget>[
//        Divider(),
        ListTile(
          title: Text('개인정보 관리'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('공지사항'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('고객센터'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('설정'),
          trailing: Icon(Icons.arrow_forward_ios),

        ),
        Divider(),
      ]
  );

}
Column _buildButtonColumn(IconData icon, String label) {
//  Color color = Theme.of(context).primaryColor;
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.black12,
          foregroundColor: Colors.black,
          child: Icon(icon)),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,

          ),
        ),
      ),
    ],
  );
}
