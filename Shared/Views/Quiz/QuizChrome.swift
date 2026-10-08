import SwiftUI

// MARK: - Quiz Chrome
//
// The pieces every quiz session shares, so the four quiz types read as one product:
// a close button and inline title, a slim progress header, the question eyebrow,
// lettered answer rows, and a floating feedback toast.

extension View {
    /// Inline title plus a close button. On iOS 26 and later the system draws the button
    /// as a Liquid Glass circle, the same treatment as Apple's own modal flows.
    func quizChrome(title: String, onClose: @escaping () -> Void) -> some View {
        self
            .navigationTitle(title)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                    }
                    .accessibilityLabel("End Quiz")
                }
            }
    }
}

// MARK: - Progress Header

struct QuizProgressHeader: View {
    let progress: Double
    let current: Int
    let total: Int
    let score: Int
    var scoreNoun: String = "correct"

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.quaternary)
                    Capsule()
                        .fill(LinearGradient(colors: Theme.progressGradient, startPoint: .leading, endPoint: .trailing))
                        .frame(width: progress > 0 ? max(6, geo.size.width * progress) : 0)
                }
            }
            .frame(height: 5)
            .animation(.spring(response: 0.5, dampingFraction: 0.85), value: progress)

            HStack {
                Text("\(current) OF \(total)")
                    .foregroundStyle(.secondary)
                Spacer()
                Label("\(score) \(scoreNoun.uppercased())", systemImage: "checkmark")
                    .foregroundStyle(Theme.emerald)
                    .contentTransition(.numericText())
            }
            .font(.statLabel)
            .monospacedDigit()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Question \(current) of \(total), \(score) \(scoreNoun)")
    }
}

// MARK: - Question Eyebrow

/// The coloured dot and uppercase label above a question, with its source on the right.
struct QuestionEyebrow: View {
    let title: String
    let color: Color
    var reference: ContentReference?

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(title.uppercased())
                .font(.statLabel)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Spacer()
            if let reference {
                SourceReferenceBadge(reference: reference)
            }
        }
    }
}

// MARK: - Answer Row

enum AnswerState {
    case idle, correct, incorrect, dimmed
}

/// A lettered answer on a content surface. After the reveal, the right answer turns
/// emerald, a wrong pick turns red, and the rest step back.
struct AnswerRow: View {
    let index: Int
    let text: String
    let state: AnswerState

    private var letter: String { String(UnicodeScalar(65 + index).map(Character.init) ?? "•") }

    private var color: Color? {
        switch state {
        case .correct: return Theme.emerald
        case .incorrect: return .red
        default: return nil
        }
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 18, style: .continuous)

        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.map { AnyShapeStyle($0) } ?? AnyShapeStyle(.quaternary))
                    .frame(width: 30, height: 30)
                switch state {
                case .correct:
                    Image(systemName: "checkmark").font(.footnote.weight(.bold)).foregroundStyle(.white)
                case .incorrect:
                    Image(systemName: "xmark").font(.footnote.weight(.bold)).foregroundStyle(.white)
                default:
                    Text(letter).font(.subheadline.weight(.semibold)).foregroundStyle(.secondary)
                }
            }
            .transition(.scale.combined(with: .opacity))

            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if let color { shape.fill(color.opacity(0.12)) }
        }
        .contentSurface(cornerRadius: 18)
        .overlay {
            if let color { shape.strokeBorder(color, lineWidth: 1.5) }
        }
        .opacity(state == .dimmed ? 0.55 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: state)
        .accessibilityLabel(text)
        .accessibilityValue(state == .correct ? "Correct answer" : state == .incorrect ? "Your answer, incorrect" : "")
    }
}

extension AnswerState {
    /// The state of one choice given what was picked and whether the answer is showing.
    static func of(choice: String, selected: String?, correct: String, revealed: Bool) -> AnswerState {
        guard revealed else { return .idle }
        if choice == correct { return .correct }
        if choice == selected { return .incorrect }
        return .dimmed
    }
}

// MARK: - Feedback Toast

/// Floating result after an answer. Transient UI over content, so it is the one piece
/// of a quiz that sits on Liquid Glass.
struct FeedbackToast<Accessory: View>: View {
    let correct: Bool
    var detail: String?
    @ViewBuilder var accessory: () -> Accessory

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(correct ? Theme.emerald : .red)
                    .symbolEffect(.bounce, value: correct)
                VStack(alignment: .leading, spacing: 2) {
                    Text(correct ? "Correct" : "Not quite")
                        .font(.headline)
                    if let detail {
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: 0)
            }
            accessory()
        }
        .padding(18)
        .glassSurface(in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .accessibilityElement(children: .contain)
    }
}

extension FeedbackToast where Accessory == EmptyView {
    init(correct: Bool, detail: String? = nil) {
        self.correct = correct
        self.detail = detail
        self.accessory = { EmptyView() }
    }
}

// MARK: - Score Hero

/// The results headline shared by both quiz types: an animated violet-to-emerald ring
/// around a scoreboard numeral, then a verdict. No trophy emoji energy, just the number.
struct ScoreHero: View {
    let correct: Int
    let total: Int
    @State private var animated = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var fraction: Double { total > 0 ? Double(correct) / Double(total) : 0 }

    private var verdict: (title: String, message: String) {
        switch fraction {
        case 0.9...: return ("Outstanding", "You have a strong command of this material.")
        case 0.7..<0.9: return ("Nicely done", "A few items are worth another look.")
        case 0.5..<0.7: return ("Getting there", "Review the ones you missed, then try again.")
        default: return ("Keep practicing", "Go through the misses below before your next round.")
        }
    }

    var body: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle().stroke(.quaternary, lineWidth: 14)
                Circle()
                    .trim(from: 0, to: animated ? fraction : 0)
                    .stroke(
                        AngularGradient(
                            colors: Theme.progressGradient,
                            center: .center,
                            startAngle: .degrees(0),
                            endAngle: .degrees(360 * max(fraction, 0.01))
                        ),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text("\(correct)")
                        .font(.numeral(52, weight: .heavy))
                        .contentTransition(.numericText())
                    Text("OF \(total)")
                        .font(.statLabel)
                        .foregroundStyle(.secondary)
                }
                .monospacedDigit()
            }
            .frame(width: 168, height: 168)

            VStack(spacing: 4) {
                Text(verdict.title)
                    .font(.title.weight(.bold))
                Text(verdict.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(correct) of \(total) correct. \(verdict.title).")
        .task {
            if reduceMotion { animated = true; return }
            try? await Task.sleep(nanoseconds: 250_000_000)
            withAnimation(.easeOut(duration: 1.0)) { animated = true }
        }
    }
}

/// A trailing check or cross for result lists.
struct ResultMark: View {
    let correct: Bool
    var body: some View {
        Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
            .font(.title3)
            .foregroundStyle(correct ? Theme.emerald : .red)
            .accessibilityLabel(correct ? "Correct" : "Missed")
    }
}
