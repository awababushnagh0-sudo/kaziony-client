/// A pickup [code] as people read it out: two groups of four ("R3TW 8KQN").
/// Codes of another length come back as they are.
String formatPickupCode(String code) =>
    code.length == 8 ? '${code.substring(0, 4)} ${code.substring(4)}' : code;
