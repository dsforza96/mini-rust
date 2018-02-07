CM.make "mini-rust.cm";

print "dummy.rs\n";
Rust.execute(Rust.compile("examples/dummy.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nprint.rs\n";
Rust.execute(Rust.compile("examples/print.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nsimple.rs\n";
Rust.execute(Rust.compile("examples/simple.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nfunc.rs\n";
Rust.execute(Rust.compile("examples/func.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nlifetime.rs\n";
Rust.execute(Rust.compile("examples/lifetime.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nblockWrong.rs\n";
Rust.execute(Rust.compile("examples/blockWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\nlifetimeWrong.rs\n";
Rust.execute(Rust.compile("examples/lifetimeWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\ndoublefuncWrong.rs\n";
Rust.execute(Rust.compile("examples/doublefuncWrong.rs"))
    handle RustError => let val _ = print "\n" in 1 end;

print "\n";

OS.Process.exit(OS.Process.success);
