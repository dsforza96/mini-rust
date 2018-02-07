CM.make "mini-rust.cm";

print "dummy.rs\n";
Rust.execute(Rust.compile("examples/dummy.rs"));

print "\nprint.rs\n";
Rust.execute(Rust.compile("examples/print.rs"));

print "\nsimple.rs\n";
Rust.execute(Rust.compile("examples/simple.rs"));

print "\nfunc.rs\n";
Rust.execute(Rust.compile("examples/func.rs"));

print "\nlifetime.rs\n";
Rust.execute(Rust.compile("examples/lifetime.rs"));

print "\nblockWrong.rs\n";
Rust.execute(Rust.compile("examples/blockWrong.rs")) handle RustError => print "\n";

print "\nlifetimeWrong.rs\n";
Rust.execute(Rust.compile("examples/lifetimeWrong.rs")) handle RustError => print "\n";

print "\ndoublefuncWrong.rs\n";
Rust.execute(Rust.compile("examples/doublefuncWrong.rs")) handle RustError => print "\n";

print "\n";

OS.Process.exit(OS.Process.success);
