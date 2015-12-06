#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import POSIX

extension String {
  func components(separator: Character = "\n") -> [String] {
    return self.characters.split(separator).map(String.init)
  }
}

func print_if(string: String, _ should_print: Bool = false) {
  if !should_print { return }
  print(string)
}

func runcmd(cmd: [String]) -> [String]? {
  if let output = try? popen(cmd) {
    return output.components()
  } else {
    return nil
  }
}
