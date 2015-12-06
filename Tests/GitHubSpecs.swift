#if os(Linux)
import Glibc
#endif

import Chocolat
import Spectre

describe("GitHub handling") {
  $0.it("can parse GitHub SSH remotes") {
    let remote = "git@github.com:neonichu/Chores.git"
    let data = github_data_from_remote(remote)

    try expect(data?.0) == "neonichu"
    try expect(data?.1) == "Chores"
  }

  $0.it("can parse GitHub HTTPS remotes") {
    let remote = "https://github.com/kylef/Spectre"
    let data = github_data_from_remote(remote)

    try expect(data?.0) == "kylef"
    try expect(data?.1) == "Spectre"
  }

  $0.it("can parse output of `git remote -v`") {
    let output = "origin  git@github.com:neonichu/Currasow.git (fetch)"
    let data = github_data_from_remote(output)

    try expect(data?.0) == "neonichu"
    try expect(data?.1) == "Currasow"
  }

  $0.it("can read Git user information") {
    let info = git_author()

    try expect(info?.0) == "Boris Bügling"
    try expect(info?.1) == "boris@icculus.org"
  }
}
