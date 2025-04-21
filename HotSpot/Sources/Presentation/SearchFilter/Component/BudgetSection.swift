import SwiftUI

struct BudgetSection: View {
    let selectedBudget: Int
    let onBudgetSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("予算")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach([0, 1, 2, 3, 4], id: \.self) { budget in
                        Button {
                            onBudgetSelected(budget)
                        } label: {
                            Text(budgetText(for: budget))
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedBudget == budget ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedBudget == budget ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func budgetText(for budget: Int) -> String {
        switch budget {
        case 0: return "指定なし"
        case 1: return "¥1,000~"
        case 2: return "¥3,000~"
        case 3: return "¥5,000~"
        case 4: return "¥10,000~"
        default: return "指定なし"
        }
    }
} 