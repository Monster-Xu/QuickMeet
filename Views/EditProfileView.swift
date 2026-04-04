import SwiftUI

struct EditProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard {
                    Text("编辑资料")
                        .font(.system(size: 22, weight: .bold))
                    PrimaryButton(title: "保存资料") { }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle("编辑资料")
    }
}
