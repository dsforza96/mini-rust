fn main (){
    fn dummy(a: &i32) -> &i32 {
        a
    }

    let x = 5;
    let r;
    r = dummy(&x);
    println!("{}", r);
}
