CM.make "mini-rust.cm";

print "dummy.rs\n";
Rust.run(Rust.compile("examples/dummy.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nprint.rs\n";
Rust.run(Rust.compile("examples/print.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nsimple.rs\n";
Rust.run(Rust.compile("examples/simple.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nfunc.rs\n";
Rust.run(Rust.compile("examples/func.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nlifetime.rs\n";
Rust.run(Rust.compile("examples/lifetime.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nblockWrong.rs\n";
Rust.run(Rust.compile("examples/blockWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nlifetimeWrong.rs\n";
Rust.run(Rust.compile("examples/lifetimeWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\ndoublefuncWrong.rs\n";
Rust.run(Rust.compile("examples/doublefuncWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

OS.Process.exit(OS.Process.success);
