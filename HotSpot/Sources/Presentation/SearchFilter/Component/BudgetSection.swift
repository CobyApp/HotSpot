import SwiftUI

struct BudgetSection: View {
    let selectedBudgets: [String]
    let onBudgetSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("予算")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Budget.allCases, id: \.self) { budget in
                        Button {
                            onBudgetSelected(budget.rawValue)
                        } label: {
                            Text(budget.name)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedBudgets.contains(budget.rawValue) ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedBudgets.contains(budget.rawValue) ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
} 