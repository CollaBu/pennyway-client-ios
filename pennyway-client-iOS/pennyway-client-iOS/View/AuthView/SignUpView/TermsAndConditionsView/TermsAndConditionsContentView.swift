import SwiftUI

struct TermsAndConditionsContentView: View {
    // MARK: Private

    @Binding var isSelectedAllBtn: Bool
    @State private var isSelectedUseBtn: Bool = false
    @State private var isSelectedInfoBtn: Bool = false

    let privacyPolicy = """
    [차례]

    1. 총칙
    2. 개인정보 수집에 대한 동의
    3. 개인정보의 수집 및 이용목적
    4. 수집하는 개인정보 항목
    5. 개인정보의 처리 및 보유 기간
    6. 개인정보 제 3자 제공에 관한 사항
    7. 개인정보 처리업무의 위탁에 관한 사항
    8. 개인정보의 파기 절차 및 방법에 관한 사항
    9. 미이용자의 개인정보 파기 등에 관한 조치
    10. 개인정보를 자동으로 수집하는 장치의 설치, 운영 및 그 거부에 관한 사항
    11. 행태정보의 수집,이용,제공 및 거부 등에 관한 사항
    12. 개인정보 보호책임자에 관항 사항
    13. 정보 주체의 권익 침해에 대한 구제방법
    14. 동의 항목 철회에 관한 사항
    15. 개인정보 처리방침의 변경에 관한 사항

    1. 총칙

    본 서비스는 회원의 개인정보보호를 소중하게 생각하고, 회원의 개인정보를 보호하기 위하여 항상 최선을 다해 노력하고 있습니다.

    1) 페니웨이는 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」을 비롯한 모든 개인정보보호 관련 법률규정을 준수하고 있으며, 관련 법령에 의거한 개인정보처리방침을 정하여 이용자 권익 보호에 최선을 다하고 있습니다.

    2) 페니웨이는 「개인정보처리방침」을 제정하여 이를 준수하고 있으며, 이를 인터넷사이트 및 모바일 어플리케이션에 공개하여 이용자가 언제나 용이하게 열람할 수 있도록 하고 있습니다.

    3) 페니웨이는 「개인정보처리방침」을 통하여 귀하께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다.

    4) 페니웨이는 「개인정보처리방침」을 홈페이지 첫 화면 하단에 공개함으로써 귀하께서 언제나 용이하게 보실 수 있도록 조치하고 있습니다.

    5) 페니웨이는 「개인정보처리방침」을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.

    2. 개인정보 수집에 대한 동의

    귀하께서 본 사이트의 개인정보보호방침 또는 이용약관의 내용에 대해 「동의 한다」버튼 또는 「동의하지 않는다」버튼을 클릭할 수 있는 절차를 마련하여, 「동의 한다」버튼을 클릭하면 개인정보 수집에 대해 동의한 것으로 봅니다.

    3. 개인정보의 수집 및 이용 목적

    페니웨이는 정보주체의 자유와 권리 보호를 위해 ⌜개인정보 보호법⌟ 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 ⌜개인정보 보호법⌟ 제 30조에 따라 정보주체에게 개인정보의 처리와 보호에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.

    페니웨이는 다음의 목적을 위하여 개인정보를 처리합니다. 처리된 개인정보는 다음 목적 이외의 용도로 사용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

    1) 회원 가입 및 관리
    회원 가입 의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정 이용 방지, 각종 고지·통지, 고충처리를 목적으로 개인정보를 처리합니다.

    2) 서비스 제공
    서비스 제공, 콘텐츠 제공, 맞춤 서비스 제공, 본인인증을 목적으로 개인정보를 처리합니다.

    3) 마케팅 및 광고에의 활용
    신규 서비스 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공을 목적으로 개인정보를 처리합니다.

    4. 처리하는 개인정보의 항목

    페니웨이는 서비스 제공을 위해 필요 최소한의 범위에서 개인정보를 수집·이용합니다.

    1. 정보주체의 동의를 받지 않고 처리하는 개인정보 항목
    페니웨이는 다음의 개인정보 항목을 정보주체의 동의없이 처리하고 있습니다.
    ① 회원 서비스 운영
    • 법적 근거 : 개인정보 보호법 제15조 제1항 제4호('계약 이행')
    • 수집·이용 항목 : ID, 비밀번호

    2. 정보주체의 동의를 받아 처리하는 개인정보 항목
    페니웨이는 다음의 개인정보 항목을 ⌜개인정보 보호법⌟ 제15조 제1항 제1호 및 제22조 제1항 제7호에 따라 정보주체의 동의를 받아 처리하고 있습니다.
    ① 회원 서비스 운영
    • 수집·이용 항목 : 이름, 휴대전화번호, 접속 로그, 접속 IP 정보

    ② 문의사항 또는 불만처리

    • 수집·이용 항목 : 이메일, 문의 내용

    5. 개인정보의 처리 및 보유 기간

    원칙적으로, 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.

    1. 페니웨이는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

    2. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
    ① 회원 가입 및 관리: 법령이 정하는 경우를 제외하고는 회원 탈퇴 후, 재생 불가능한 삭제 처리를 위해 3일 이내까지 보유 및 이용
    ② 기록 보관:

          - 서비스 방문 기록: 3개월 (통신비밀보호법)
    ③ 단, 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지 보관합니다.

    6. 개인정보 제 3자 제공에 관한 사항

    본 서비스는 귀하의 개인정보를 "개인정보의 수집목적 및 이용목적"에서 고지한 범위 내에서 사용하며, 동 범위를 초과하여 이용하거나 타인 또는 타 기업·기관에 제공하지 않습니다.
    그러나 보다 나은 서비스 제공을 위하여 귀하의 개인정보를 업체 자페니웨이 또는 제휴사에게 제공하거나, 업체 자페니웨이 또는 제휴사와 공유할 수 있습니다. 개인정보를 제공하거나 공유할 경우에는 사전에 귀하께 업체 자페니웨이 그리고 제휴사가 누구인지, 제공 또는 공유되는 개인정보항목이 무엇인지, 왜 그러한 개인정보가 제공되거나 공유되어야 하는지, 그리고 언제까지 어떻게 보호·관리되는지에 대해 개별적으로 전자우편 및 서면을 통해 고지하여 동의를 구하는 절차를 거치게 되며, 귀하께서 동의하지 않는 경우에는 업체 자페니웨이 그리고 제휴사에게 제공하거나 공유하지 않습니다. 또한 이용자의 개인정보를 원칙적으로 외부에 제공하지 않으나, 아래의 경우에는 예외로 합니다.

    1) 이용자들이 사전에 동의한 경우

    2) 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우

    3) 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우

    7. 개인정보 처리업무의 위탁에 관한 사항

    페니웨이는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.

    수탁업체명: Amazon Web Service
    위탁하는 업무의 내용: 클라우드 서비스 DB 관리
    위탁 기간: 계약 종료 시까지

    8. 개인정보의 파기 절차 및 방법에 관한 사항

    1) 페니웨이는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.
    • 파기절차 : 개인정보 파기 사유가 발생한 개인정보를 선정하고, 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.
    • 파기방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제하고, 종이 문서에 기록된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.

    2) 페니웨이는 위탁계약 체결 시 「개인정보 보호법」 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 안전성 확보조치, 재위탁 제한, 수탁자에 대한 관리・감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.

    3) 「개인정보 보호법」 제26조 제6항에 따라 수탁자가 당사의 개인정보 처리업무를 재위탁하는 경우 <개인정보처리자명>의 동의를 받고 있습니다.

    4) 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.

    9. 미이용자의 개인정보 파기 등에 관한 조치

    1년간 서비스를 이용하지 않은 이용자의 개인정보는 별도로 분리하여 저장·관리하고 있습니다. 미이용자 개인정보는 분리 저장 후 4년간 보유하며, 이후 지체 없이 파기합니다.

    10. 개인정보를 자동으로 수집하는 장치의 설치, 운영 및 그 거부에 관한 사항

    페니웨이는 Google, Inc. (이하 “Google”이라 합니다)에서 제공하는 웹 로그 분석 도구인 Google Analytics를 이용하고 있습니다. 웹 로그 분석이란 웹 사이트 상에서 고객님의 서비스 이용 형태에 대한 분석을 의미합니다.
    Google은 페니웨이를 대신하여 정보를 처리하며 고객님의 웹 사이트 사용을 분석합니다. 이 과정에서 개인 식별이 가능한 어떠한 정보도 처리하지 않습니다.
    Google Analytics의 정보 처리에 관한 보다 자세한 내용은 [support.google.com/analytics/answer/6004245?hl=ko](http://support.google.com/analytics/answer/6004245?hl=ko) 을 참고하시기 바랍니다.
    [거부 방법]
    "마이페이지"의 "회원탈퇴(동의철회)"를 클릭하거나 개인정보관리책임자에게 E-mail등으로 연락하시면 즉시 개인정보의 삭제 등 필요한 조치를 하겠습니다.

    11. 행태정보의 수집,이용,제공 및 거부 등에 관한 사항

    페니웨이는 서비스 이용과정에서 정보주체에게 최적화된 맞춤형 서비스 및 혜택, 온라인 맞춤형 광고 등을 제공하기 위하여 행태정보를 수집·이용하고 있습니다.

    1) 수집하는 행태 정보의 항목: 이용자의 앱 서비스 방문 이력, 페이지 이동 이력

    2) 행태정보 수집 방법: 이용자의 앱 내에서 행해지는 주요 행동에 대해 생성정보 수집툴(Google Analytics)을 통해 자동 생성되어 저장

    3) 행태정보 수집 목적: 이용자의 성향에 기반한 사용 행태 분석, 정보 통계, CRM, 맞춤추천, 메시지발송

    4) 행태정보 보유 및 이용기간: 회원 탈퇴 또는 서비스 계약 종료 후 30일까지

    12. 개인정보 보호책임자에 관항 사항

    1) 페니웨이는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

    - 성명: 양재서
    - 연락처: [team.collabu@gmail.com](mailto:team.collabu@gmail.com)

    2) 정보주체는 페니웨이의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자에게 문의할 수 있습니다. 페니웨이는 정보주체의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.

    13. 정보 주체의 권익 침해에 대한 구제방법

    정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.

    1) 개인정보 분쟁조정위원회 : (국번없이) 1833-6972 ([www.kopico.go.kr](http://www.kopico.go.kr/))

    2) 인정보침해신고센터 : (국번없이) 118 ([privacy.kisa.or.kr](http://privacy.kisa.or.kr/))

    3) 대검찰청 : (국번없이) 1301 ([www.spo.go.kr](http://www.spo.go.kr/))

    4) 경찰청 : (국번없이) 182 ([ecrm.cyber.go.kr](http://ecrm.cyber.go.kr/))

    14. 동의항목 철회에 대한 사항

    회원가입 등을 통해 개인정보의 수집, 이용, 제공에 대해 귀하께서 동의하신 내용을 귀하는 언제든지 철회하실 수 있습니다. 동의철회는 "마이페이지"의 "회원탈퇴(동의철회)"를 클릭하거나 개인정보관리책임자에게 E-mail등으로 연락하시면 즉시 개인정보의 삭제 등 필요한 조치를 하겠습니다.
    페니웨이는 개인정보의 수집에 대한 회원탈퇴(동의철회)를 개인정보 수집시와 동등한 방법 및 절차로 행사할 수 있도록 필요한 조치를 하겠습니다.

    15. 개인정보 처리방침의 변경에 관한 사항

    1) 이 개인정보 처리방침은 2024.08.20부터 적용됩니다.

    2) 이 개인정보 처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지합니다.
    """

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                HStack {
                    Text("이용 약관 동의")
                        .font(.H1SemiboldFont())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.leading, 20)

                Spacer().frame(height: 49 * DynamicSizeFactor.factor())

                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Button(action: {
                            let newSelection = !isSelectedAllBtn
                            isSelectedAllBtn = newSelection
                            isSelectedUseBtn = newSelection
                            isSelectedInfoBtn = newSelection
                        }, label: {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(maxWidth: .infinity, minHeight: 44 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: isSelectedAllBtn ? Color("Gray05") : Color("Gray02"))
                                    .cornerRadius(4)

                                Image("icon_check")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White01") : Color("Gray04"))
                                    .padding(.horizontal, 10)
                                Text("모두 동의할게요")
                                    .font(.H4MediumFont())
                                    .platformTextColor(color: isSelectedAllBtn ? Color("White01") : Color("Gray04"))
                                    .offset(x: 34 * DynamicSizeFactor.factor())
                            }
                        })
                        .buttonStyle(BasicButtonStyleUtil())

                        Spacer().frame(height: 29 * DynamicSizeFactor.factor())

                        VStack(alignment: .leading) {
                            // 하단 text내용 수정필요
                            AgreementSectionView(isSelected: $isSelectedUseBtn, title: "이용약관 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")

                            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                            // 하단 text내용 수정필요
//                            AgreementSectionView(isSelected: $isSelectedInfoBtn, title: "개인정보 처리방침 (필수)", contentText: "Sed ut perspiciatis, unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit")

                            AgreementSectionView(isSelected: $isSelectedInfoBtn, title: "개인정보 처리방침 (필수)", contentText: privacyPolicy)
                        }

                        Spacer().frame(height: 32 * DynamicSizeFactor.factor())
                    }
                }
                .padding(.horizontal, 20)
                .onChange(of: isSelectedUseBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
                .onChange(of: isSelectedInfoBtn) { _ in isSelectedAllBtn = isSelectedUseBtn && isSelectedInfoBtn }
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TermsAndConditionsView(viewModel: SignUpNavigationViewModel())
}
