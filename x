fn main() {
    fn dummy <'a, 'b>(x: &'a i32, y: &'a i32) -> &'a i32{
    y
}
    let w = 1;
    let res;
    {
        let r = 1;
        let q = &w;
        res = dummy (&w, &q);
    }
    println!("{}", res);
}
