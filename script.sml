CM.make "mini-rust.cm";
Rust.compile("examples/dummy.rs");
Rust.compile("examples/block.rs");
OS.Process.exit(OS.Process.success);
