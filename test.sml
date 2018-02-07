CM.make "mini-rust.cm";

Rust.execute(Rust.compile("examples/dummy.rs"));
Rust.execute(Rust.compile("examples/print.rs"));
Rust.execute(Rust.compile("examples/simple.rs"));
Rust.execute(Rust.compile("examples/func.rs"));
Rust.execute(Rust.compile("examples/lifetime.rs"));
Rust.execute(Rust.compile("examples/lifetimeWrong.rs")) handle RustError => print "\n";
Rust.execute(Rust.compile("examples/doublefunc.rs")) handle RustError => print "\n";

OS.Process.exit(OS.Process.success);
