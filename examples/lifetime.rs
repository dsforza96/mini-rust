fn sum <'a>(x: &'a int, y: &'a int) -> &'a int{
    x;
}
    let w = 10;
    let res;
    {
        let q = 5;
        res = sum (&w, &q);
        println!(res);
    }
