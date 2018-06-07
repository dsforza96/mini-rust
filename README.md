# Mini-Rust: A SML Implementation of Rust's Lifetimes

## Getting started

First clone the project to create a local copy on your computer.

```sh
git clone git@github.com:dsfoza/mini-rust.git
cd mini-rust
```

Now you can compile it using the *SML* interpreter:

```sh
sml
CM.make "mini-rust.cm";
```

With **mini-rust** you can compile and execute simple programs written in a small sub-language of *Rust* focused on lifetimes.
For example, if you would to execute the file *dummy.rs* contained in directory *examples*, you should invoke the command

```sh
Rust.execute(Rust.compile("examples/dummy.rs"));
```

## Documentation
For more informations read the documentation at [docs/relazione.pdf](docs/relazione.pdf).
