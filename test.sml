CM.make "mini-rust.cm";

print "~*~*~*~*~ dummy.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/dummy.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ print.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/print.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ simple.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/simple.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ func.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/func.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~  lifetime.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/lifetime.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ blockWrong.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/blockWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ lifetimeWrong.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/lifetimeWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n~*~*~*~*~ doublefuncWrong.rs ~*~*~*~*~\n";
Rust.run(Rust.compile("examples/doublefuncWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n";

OS.Process.exit(OS.Process.success);
