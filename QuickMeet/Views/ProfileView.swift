import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SectionCard {
                    Text("MonsterX")
                        .font(.system(size: 24, weight: .bold))
                    Text("ID: QM2026")
                        .foregroundStyle(QMColor.textSecondary)
                }

                SectionCard {
                    NavigationLink("编辑资料") { EditProfileView() }
                    NavigationLink("设置") { Text("设置") }
                }
            }
            .padding(20)
        }
        .background(QMColor.background.ignoresSafeArea())
        .navigationTitle("我的")
    }
}
