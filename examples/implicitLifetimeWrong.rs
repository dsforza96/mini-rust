fn main (){
    fn dummy(a: &i32, b:&i32) -> &i32 {
        a
    }

    let r;
    {
        let x = 5;
        r = dummy(&x, &x);
    }
    println!("{}", r);
}
