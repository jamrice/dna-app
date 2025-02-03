import 'package:flutter/material.dart';
import 'string.dart';

class noticeBoard extends StatelessWidget {
  const noticeBoard({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> items = ['Apple', 'Banana', 'Cherry', 'Date', 'Grape'];
    return Scaffold(
        appBar: AppBar(title: Text("요즘 국회")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsetsDirectional.all(20),
              child: Text("국회에 올라온 것을 확인해 보세요",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(items[index]));
                }
            )),
          ],
        ));
  }
}

final board1 = boardInfo(
    title: "산업집적활성화 및 공장설립에 관한 법률 일부개정법률안(이언주의원 등 11인)",
    billNum: 2207862,
    body: """제안이유

현행법에 따르면 지식산업센터에 대한 규제가 부재하여 분양 후 전매를 통한 투기행위가 발생하고 있어 실제 입주가 필요한 기업들의 입주비용이 증가하는 등 문제가 지속적으로 발생하고 있음. 더불어 분양승인 전에 홍보관을 설치하고 총사업비에 과도한 분양홍보관 비용을 포함시켜 분양가가 상승한다는 지적도 제기됨.
이에 지식산업센터를 분양받은 자가 전매를 하거나 전매를 알선할 수 없도록 하고, 지식산업센터를 설립한 자는 모집공고안 승인 전에 분양홍보관을 설치할 수 없도록 하여 지속적인 산업발전을 도모하려는 것임.


주요내용

가. 지식산업센터를 분양받은 자가 분양받은 자의 지위 또는 건축물을 전매하거나 전매를 알선하여서는 아니 되도록 함(안 제28조의4제5항 신설).
나. 지식산업센터를 임대받은 자는 이를 다른 사람에게 전대(轉貸)하여서는 아니 되도록 함(안 제28조의4제6항 신설).
다. 지식산업센터를 설립한 자는 모집공고안 승인을 받지 아니하고 분양홍보관을 설치할 수 없도록 함(안 제28조의4제7항 신설).
라. 시장ㆍ군수ㆍ구청장 또는 관리기관은 지식산업센터 입주업체에 대한 입주적합업종 해당 여부를 주기적으로 확인ㆍ점검하도록 함(안 제28조의6제5항 신설).""",
    summary: "",
    url:
        "https://likms.assembly.go.kr/bill/billDetail.do?billId=PRC_X2V4W1U1V2D9D1C3A5B3Z5A3I3I4G8",
    pdfUrl: "",
    date: DateTime(2025, 1, 31));
