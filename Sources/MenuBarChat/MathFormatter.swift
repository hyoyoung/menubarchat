import Foundation

// Unicode approximation for inline LaTeX: frequent subset only (Greek,
// operators, sub/superscripts, \frac linearization). Anything without a
// mapping stays as written, so output is never worse than the original.
enum MathFormatter {
    static let symbols: [String: String] = [
        "alpha": "α", "beta": "β", "gamma": "γ", "delta": "δ", "epsilon": "ε",
        "zeta": "ζ", "eta": "η", "theta": "θ", "iota": "ι", "kappa": "κ",
        "lambda": "λ", "mu": "μ", "nu": "ν", "xi": "ξ", "pi": "π", "rho": "ρ",
        "sigma": "σ", "tau": "τ", "upsilon": "υ", "phi": "φ", "chi": "χ",
        "psi": "ψ", "omega": "ω",
        "Gamma": "Γ", "Delta": "Δ", "Theta": "Θ", "Lambda": "Λ", "Xi": "Ξ",
        "Pi": "Π", "Sigma": "Σ", "Phi": "Φ", "Psi": "Ψ", "Omega": "Ω",
        "sum": "Σ", "prod": "∏", "int": "∫", "sqrt": "√", "infty": "∞",
        "partial": "∂", "nabla": "∇", "pm": "±", "mp": "∓", "times": "×",
        "cdot": "⋅", "top": "⊤", "leq": "≤", "geq": "≥", "neq": "≠",
        "approx": "≈", "equiv": "≡", "in": "∈", "notin": "∉", "subset": "⊂",
        "subseteq": "⊆", "cup": "∪", "cap": "∩", "forall": "∀", "exists": "∃",
        "rightarrow": "→", "to": "→", "leftarrow": "←", "Rightarrow": "⇒",
        "mapsto": "↦", "ldots": "…", "cdots": "⋯", "sim": "∼", "propto": "∝",
        "ell": "ℓ", "mathbb{R}": "ℝ", "mathbb{E}": "𝔼",
        "left": "", "right": "",
    ]

    static let subscripts: [Character: Character] = [
        "0": "₀", "1": "₁", "2": "₂", "3": "₃", "4": "₄",
        "5": "₅", "6": "₆", "7": "₇", "8": "₈", "9": "₉",
        "+": "₊", "-": "₋", "(": "₍", ")": "₎", "=": "₌",
        "a": "ₐ", "e": "ₑ", "h": "ₕ", "i": "ᵢ", "j": "ⱼ", "k": "ₖ",
        "l": "ₗ", "m": "ₘ", "n": "ₙ", "o": "ₒ", "p": "ₚ", "r": "ᵣ",
        "s": "ₛ", "t": "ₜ", "u": "ᵤ", "v": "ᵥ", "x": "ₓ",
    ]

    static let superscripts: [Character: Character] = [
        "0": "⁰", "1": "¹", "2": "²", "3": "³", "4": "⁴",
        "5": "⁵", "6": "⁶", "7": "⁷", "8": "⁸", "9": "⁹",
        "+": "⁺", "-": "⁻", "(": "⁽", ")": "⁾", "=": "⁼",
        "n": "ⁿ", "i": "ⁱ", "T": "ᵀ", "a": "ᵃ", "e": "ᵉ", "h": "ʰ",
        "j": "ʲ", "k": "ᵏ", "l": "ˡ", "m": "ᵐ", "o": "ᵒ", "p": "ᵖ",
        "r": "ʳ", "s": "ˢ", "t": "ᵗ", "u": "ᵘ", "v": "ᵛ", "x": "ˣ",
    ]

    static func unicodeMath(in text: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"\$\$([^$]+)\$\$|\$([^$\n]+)\$"#) else {
            return text
        }
        var result = ""
        var cursor = text.startIndex
        regex.enumerateMatches(in: text, range: NSRange(text.startIndex..., in: text)) { match, _, _ in
            guard let match, let whole = Range(match.range, in: text) else { return }
            result += text[cursor..<whole.lowerBound]
            let innerRange = match.range(at: 1).length > 0 ? match.range(at: 1) : match.range(at: 2)
            guard let inner = Range(innerRange, in: text) else { return }
            let body = String(text[inner])
            // A dollar span without any TeX marker is money, not math.
            if body.contains("\\") || body.contains("^") || body.contains("_") {
                result += convert(body)
            } else {
                result += text[whole]
            }
            cursor = whole.upperBound
        }
        result += text[cursor...]
        return result
    }

    static func convert(_ latex: String) -> String {
        var body = replaceCommands(in: latex)
        body = body.replacingOccurrences(of: "^⊤", with: "ᵀ")
        body = replaceLinearFrac(in: body)
        body = convertScripts(in: body)
        for spacing in ["\\,", "\\;", "\\!", "\\ "] {
            body = body.replacingOccurrences(of: spacing, with: " ")
        }
        body = unwrapBraces(in: body)
        return body
    }

    private static func replaceCommands(in body: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"\\([a-zA-Z]+(\{[a-zA-Z]\})?)"#) else {
            return body
        }
        var result = ""
        var cursor = body.startIndex
        regex.enumerateMatches(in: body, range: NSRange(body.startIndex..., in: body)) { match, _, _ in
            guard let match, let whole = Range(match.range, in: body) else { return }
            result += body[cursor..<whole.lowerBound]
            let name = String(body[whole].dropFirst())
            result += symbols[name] ?? String(body[whole])
            cursor = whole.upperBound
        }
        result += body[cursor...]
        return result
    }

    private static func replaceLinearFrac(in body: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"\\frac\{([^{}]*)\}\{([^{}]*)\}"#) else {
            return body
        }
        return regex.stringByReplacingMatches(
            in: body, range: NSRange(body.startIndex..., in: body),
            withTemplate: "($1)/($2)"
        )
    }

    private static func convertScripts(in body: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"([_^])(\{[^{}]*\}|.)"#) else {
            return body
        }
        var result = ""
        var cursor = body.startIndex
        regex.enumerateMatches(in: body, range: NSRange(body.startIndex..., in: body)) { match, _, _ in
            guard let match, let whole = Range(match.range, in: body),
                  let marker = Range(match.range(at: 1), in: body),
                  let arg = Range(match.range(at: 2), in: body)
            else { return }
            let table = body[marker] == "_" ? subscripts : superscripts
            let characters = body[arg].filter { $0 != "{" && $0 != "}" }
            let converted = characters.compactMap { table[$0] }
            result += body[cursor..<whole.lowerBound]
            if converted.count == characters.count, !characters.isEmpty {
                result += String(converted)
            } else {
                result += body[whole]
            }
            cursor = whole.upperBound
        }
        result += body[cursor...]
        return result
    }

    private static func unwrapBraces(in body: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: #"\{([^{}]*)\}"#) else {
            return body
        }
        return regex.stringByReplacingMatches(
            in: body, range: NSRange(body.startIndex..., in: body),
            withTemplate: "$1"
        )
    }
}
