import SwiftUI
import CobyDS

struct BudgetSection: View {
    let selectedBudgets: [String]
    let onBudgetSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("予算")
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
                .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Budget.allCases, id: \.self) { budget in
                        FilterButton(
                            title: budget.name,
                            isSelected: selectedBudgets.contains(budget.rawValue),
                            action: { onBudgetSelected(budget.rawValue) }
                        )
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
} 
